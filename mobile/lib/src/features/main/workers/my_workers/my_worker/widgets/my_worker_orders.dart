import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/request_execution_item_card.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../my_worker_controller.dart';

class OrdersContent extends StatefulWidget {
  final int? workerId;

  const OrdersContent({super.key, required this.workerId});

  @override
  State<OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<OrdersContent> {
  DateTime? _startDate;
  DateTime? _endDate;
  PaymentAmount? _paymentAmount;
  String? currentUserId;
  late final MyWorkerController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<MyWorkerController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDate = DateTime.now().subtract(const Duration(days: 30));
      _endDate = DateTime.now();
      _fetchPayment();
    });
  }

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
                rangeSelectionBackgroundColor:
                    Colors.orange // Цвет для дней внутри диапазона
                ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.orange
                      .shade300, // Цвет для активного выбора даты (маркер, индикация)
                  onPrimary: Colors.black, // Цвет текста на активном маркере
                  onSurface: Colors.black, // Цвет текста дат
                ),
            dividerTheme: const DividerThemeData(color: Colors.transparent),
            dialogBackgroundColor: Colors.white, // Фон календаря
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _fetchPayment();
      _fetchOrder();
    }
  }

  Future<void> _fetchPayment() async {
    if (_startDate != null && _endDate != null) {
      final startDateFormatted = DateFormat('yyyy-MM-dd').format(_startDate!);
      final endDateFormatted = DateFormat('yyyy-MM-dd')
          .format(_endDate!.add(const Duration(days: 1)));
      final token = await TokenService().getToken();
      try {
        if (token == null) {
          return;
        }
        final payload = TokenService().extractPayloadFromToken(token);
        currentUserId = payload.sub;

        final result = await controller.fetchSumPaymentAmount(
            widget.workerId, startDateFormatted, endDateFormatted);
        setState(() {
          _paymentAmount = result;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<List<dynamic>> _fetchOrder() async {
    if (_startDate != null && _endDate != null) {
      final startDateFormatted = DateFormat('yyyy-MM-dd').format(_startDate!);
      final endDateFormatted = DateFormat('yyyy-MM-dd')
          .format(_endDate!.add(const Duration(days: 1)));
      final token = await TokenService().getToken();
      try {
        if (token == null) {
          return [];
        }
        final payload = TokenService().extractPayloadFromToken(token);
        currentUserId = payload.sub;

        final result = await controller.fetchOrders(
            widget.workerId.toString(), startDateFormatted, endDateFormatted);

        return [result, payload];
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return [];
  }

  Widget _buildOrderList(List<RequestExecution> orders, Payload payload) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return RequestExecutionItemCard(
            onTap: () {
              RequestExecutionListScreenController(
                      requestExecutionRepository: RequestExecutionRepository(),
                      factory: RequestDataHandlerFactory())
                  .onTapDriverRequestExecution(order);
            },
            request: order,
            userMode: UserMode.owner,
            payload: payload,
            isFromOwnerDriversList: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickDateRange,
          child: Text(
            _startDate != null && _endDate != null
                ? 'С ${DateFormat('yyyy-MM-dd').format(_startDate!)} по ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                : 'Выберите диапазон дат',
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                  future: _fetchOrder(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }
                    final List<RequestExecution> orders = snapshot.data![0];
                    final payload = snapshot.data![1];
                    return _buildOrderList(orders, payload);
                  }),
              _paymentAmount != null
                  ? Text(
                      'Доход: ${_paymentAmount!.amount} тг',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
