import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmountInputController extends AppSafeChangeNotifier {
  int _amountPaid = 0;

  int get amountPaid => _amountPaid;

  void setAmount(double amount) {
    _amountPaid = amount.toInt();
    notifyListeners();
  }

  void clearAmount() {
    _amountPaid = 0;
    notifyListeners();
  }
}

class AmountInputDialog extends StatefulWidget {
  final Function(double) onAmountSubmitted;

  const AmountInputDialog({super.key, required this.onAmountSubmitted});

  @override
  _AmountInputDialogState createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<AmountInputDialog> {
  double? _amount;
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Напишите сумму, которую вы получили за заказ',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontWeight: FontWeight.bold),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              hintText: 'Введите сумму',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Navigator.of(context).pop();
            context.pop(false);
          },
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            if (_amount != null) {
              widget.onAmountSubmitted(_amount!);
              // Navigator.of(context).pop();
              context.pop(true);
            }
          },
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white),
          child: const Text('Отправить'),
        ),
      ],
    );
  }
}

Future<bool> showAmountInputDialog(
    BuildContext context, Function(double) onAmountSubmitted)async {
 final data =await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AmountInputDialog(
        onAmountSubmitted: onAmountSubmitted,
      );
    },
  );
  return data ?? false;
}
