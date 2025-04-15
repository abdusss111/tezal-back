import 'package:flutter/material.dart';

class RequestListActionButton extends StatelessWidget {
  const RequestListActionButton({
    super.key,
    this.backGroundColor,
    this.foregroundColor,
    this.sideColor,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? backGroundColor;
  final Color? foregroundColor;
  final Color? sideColor;

  @override
  Widget build(BuildContext context) {
    final isFinishButton = text == 'Завершить';
    final isStartButton = text == 'Начать';

    return FilledButton(
      style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: backGroundColor ??
              ((isFinishButton || isStartButton)
                  ? Theme.of(context).primaryColor
                  : Colors.white),
          foregroundColor: foregroundColor ??
              ((isFinishButton || isStartButton)
                  ? Colors.white
                  : Theme.of(context).primaryColor),
          side: sideColor != null
              ? BorderSide(color: sideColor!)
              : ((isFinishButton || isStartButton)
                  ? null
                  : BorderSide(color: Theme.of(context).primaryColor))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
