import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/rating_with_star_widget.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_history/statistic.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_statistic/request_statistic.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/request_history/request_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestHistoryData {
  final int requestId;

  RequestHistoryData({required this.requestId});
}

class RequestHistoryScreen extends StatefulWidget {
  final RequestHistoryData requestHistoryData;
  const RequestHistoryScreen({super.key, required this.requestHistoryData});

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  late final RequestHistoryController requestHistoryController;

  @override
  void initState() {
    super.initState();
    requestHistoryController =
        Provider.of<RequestHistoryController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      requestHistoryController.setupHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.requestHistoryData.requestId.toString());
    return Consumer<RequestHistoryController>(
        builder: (context, controller, child) {
      final requestStatisticResponse = controller.requestStatisticResponse;
      debugPrint(
          'Общее время заказа: ${DateTimeUtils.formatDurationFromNanoSeconds(controller.requestStatisticResponse?.statistic?.total ?? -1)}');
      return Scaffold(
          appBar: AppBar(
            title: const Text('История заказа'),
          ),
          body: !controller.isLoading
              ? requestStatisticResponse != null
                  ? ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white, // Фон контейнера
                                borderRadius: BorderRadius.circular(
                                    16), // Скруглённые углы
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(
                                        -1, -1), // Смещение вверх и влево
                                    blurRadius: 5, // Радиус размытия
                                    color: Color.fromRGBO(0, 0, 0,
                                        0.04), // Чёрный цвет с 4% прозрачностью
                                  ),
                                  BoxShadow(
                                    offset:
                                        Offset(1, 1), // Смещение вниз и вправо
                                    blurRadius: 5, // Радиус размытия
                                    color: Color.fromRGBO(0, 0, 0,
                                        0.04), // Чёрный цвет с 4% прозрачностью
                                  ),
                                ],
                              ),
                              child: _StatisticColumn(
                                requestStatisticResponse:
                                    requestStatisticResponse,
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white, // Фон контейнера
                                borderRadius: BorderRadius.circular(
                                    16), // Скруглённые углы
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(
                                        -1, -1), // Смещение вверх и влево
                                    blurRadius: 5, // Радиус размытия
                                    color: Color.fromRGBO(0, 0, 0,
                                        0.04), // Чёрный цвет с 4% прозрачностью
                                  ),
                                  BoxShadow(
                                    offset:
                                        Offset(1, 1), // Смещение вниз и вправо
                                    blurRadius: 5, // Радиус размытия
                                    color: Color.fromRGBO(0, 0, 0,
                                        0.04), // Чёрный цвет с 4% прозрачностью
                                  ),
                                ],
                              ),
                              child: TimeLine(controller: controller),
                            ))
                      ],
                    )
                  : const SizedBox.shrink()
              : const AppCircularProgressIndicator());
    });
  }
}

class _StatisticColumn extends StatelessWidget {
  final RequestStatistic? requestStatisticResponse;
  const _StatisticColumn({required this.requestStatisticResponse});

  @override
  Widget build(BuildContext context) {
    final statistic = requestStatisticResponse?.statistic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          'Общее время',
          style: Theme.of(context).textTheme.titleLarge,
        )),
        _StatisticRow(
          label: 'Заказ:',
          icon: Icons.access_time,
          value: statistic?.total,
        ),
        _StatisticRow(
          label: 'В пути:',
          icon: Icons.directions_car,
          value: statistic?.onRoad,
        ),
        _StatisticRow(
          label: 'В работе:',
          icon: Icons.work,
          value: statistic?.working,
        ),
        _StatisticRow(
          label: 'В паузе:',
          icon: Icons.pause_circle_outline,
          value: statistic?.pause,
        ),
      ],
    );
  }
}

class _StatisticRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? value;

  const _StatisticRow({
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blueGrey[700],
            size: 24,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateTimeUtils.formatDurationFromNanoSeconds(value ?? -1),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeLine extends StatefulWidget {
  final RequestHistoryController controller;
  const TimeLine({
    super.key,
    required this.controller,
  });

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    final statistics = widget.controller.historyList;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: statistics.length,
      itemBuilder: (context, index) {
        final statistic = statistics[index];
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Column(children: [
                Container(
                  width: 2,
                  height: 50,
                  color: (index == 0)
                      ? Colors.transparent
                      : _getVerticalLineColor(),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _getIconColor(statistic),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    _getIcon(statistic),
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: (index == statistics.length - 1)
                      ? Colors.transparent
                      : _getVerticalLineColor(),
                ),
              ]),
              Expanded(
                child: EventCard(
                    title: _getTitle(statistic), statistic: statistic),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getVerticalLineColor() =>
      AppColors.appOwnerPrimaryColor.withOpacity(0.2);

  String _getTitle(Statistic statistic) {
    if (statistic.rate != 0) {
      return 'Клиент оценил заказ';
    }
    switch (statistic.status) {
      case 'AWAITS_START':
        return 'В ожидании начала';
      case 'ON_ROAD':
        return 'В пути';
      case 'WORKING':
        return 'Водитель начал работу';
      case 'PAUSE':
        return 'Водитель приостановил работу';
      case 'RESUME':
        return 'Водитель возобновил работу';
      case 'FINISHED':
        return 'Водитель завершил работу';
      default:
        return 'Неизвестный статус';
    }
  }

  IconData _getIcon(Statistic statistic) {
    if (statistic.rate != 0) return Icons.star;

    switch (statistic.status) {
      case 'AWAITS_START':
        return Icons.timer;
      case 'ON_ROAD':
        return Icons.directions_car;
      case 'WORKING':
        return Icons.play_arrow;
      case 'PAUSE':
        return Icons.pause;
      case 'RESUME':
        return Icons.play_arrow_outlined;
      case 'FINISHED':
        return Icons.done;
      default:
        return Icons.help;
    }
  }

  Color _getIconColor(Statistic statistic) {
    switch (statistic.status) {
      case 'AWAITS_START':
        return Colors.orange;
      case 'ON_ROAD':
        return Colors.blue;
      case 'WORKING':
        return Colors.green;
      case 'RESUME':
        return Colors.green;
      case 'PAUSE':
        return Colors.red;
      case 'FINISHED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.statistic,
  });

  final String title;
  final Statistic statistic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          statistic.rate != 0
              ? Row(
                  children: [
                    const Text(
                      'Оценка: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    RatingWithStarWidget(
                      rating: statistic.rate?.toDouble(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          statistic.duration != 0 && statistic.status != 'FINISHED'
              ? Text(
                  'Длительность: ${DateTimeUtils.formatDurationFromNanoSeconds(statistic.duration ?? -1)}',
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
          Text(
            '${_getStartStatusLabel(statistic)}: ${DateTimeUtils.formatDateLabel(statistic.startStatusAt)}',
            style: const TextStyle(fontSize: 14),
          ),
          statistic.endStatusAt != null && statistic.status != 'FINISHED'
              ? Text(
                  'Конец: ${DateTimeUtils.formatDateLabel(statistic.endStatusAt)}',
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  String _getStartStatusLabel(Statistic statistic) {
    if (statistic.rate != 0) {
      return 'Время оценки';
    }
    if (statistic.status == 'FINISHED') {
      return 'Время завершения';
    }
    return 'Начало';
  }
}
