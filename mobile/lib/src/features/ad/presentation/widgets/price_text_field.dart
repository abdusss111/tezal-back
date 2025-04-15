import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceTextField extends StatefulWidget {
  final TextEditingController priceController;
  final void Function(String) onEndEditing;
  final String? initialValue;
  const PriceTextField({
    super.key,
    this.initialValue,
    required this.priceController,
    required this.onEndEditing,
  });

  @override
  State<PriceTextField> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  final List<String> values = ['тг/час', 'Договорная'];
  @override
  initState() {
    super.initState();
    final text = widget.initialValue;

    if (text == '0' || text == '2000') {
      currentDropDownValue = 1;

      widget.onEndEditing(priseISNUll);
      widget.priceController.text = priseISNUll;
    } else {
      currentDropDownValue = 0;
      if (widget.initialValue != null) {
        widget.priceController.text = widget.initialValue!;
      }
    }
  }

  late int currentDropDownValue;
  final priceSet = 'Укажите цену';
  final priseISNUll = 'Договорная';
  @override
  Widget build(BuildContext context) {
    if (!(int.tryParse(widget.initialValue ?? 'sd').runtimeType == int ||
            double.tryParse(widget.initialValue ?? 'sd').runtimeType ==
                double) &&
        widget.initialValue != null) {
      widget.priceController.text = widget.initialValue!;
    }
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: widget.priceController,
            readOnly: currentDropDownValue == 1,
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onTapOutside: (reason) {
              widget.onEndEditing(widget.priceController.text);
            },
            onSubmitted: (value) {
              widget.onEndEditing(widget.priceController.text);
            },
            onChanged: (value) {
              widget.onEndEditing(widget.priceController.text);
            },
            onEditingComplete: () {
              widget.onEndEditing(widget.priceController.text);
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: AppDimensions.appPrimaryInputPadding,
              hintText: currentDropDownValue == 0 ? priceSet : priseISNUll,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: DropdownButton<String>(
            items: values
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  currentDropDownValue = values.indexOf(value);
                });
                if (currentDropDownValue == 1) {
                  widget.onEndEditing(priseISNUll);
                } else {
                  widget.onEndEditing('');
                }
              }
            },
            value: values[currentDropDownValue],
          ),
        ),
      ],
    );
  }
}
