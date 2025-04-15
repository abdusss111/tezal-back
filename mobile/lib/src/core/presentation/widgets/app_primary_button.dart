import 'package:flutter/material.dart';

enum ButtonType {
  elevated,
  outlined,
  filled,
  filledTonal,
  text,
}

class AppPrimaryButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final IconData? icon;
  final ButtonType buttonType;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const AppPrimaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.borderColor,
    this.buttonType = ButtonType.filled,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final size = Size(width ?? double.maxFinite, height ?? 48);
    final RoundedRectangleBorder roundedRectangleBorder =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: roundedRectangleBorder,
            minimumSize: size,
            side: borderColor != null
                ? BorderSide(
                    color: borderColor ?? Theme.of(context).primaryColor)
                : null,
          ),
          child: _ButtonContent(
            text: text,
            textColor: textColor,
            icon: icon,
            textStyle: textStyle,
          ),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color:
                  textColor ?? Theme.of(context).textTheme.labelLarge!.color!,
            ),
            shape: roundedRectangleBorder,
            minimumSize: size,
          ),
          child: _ButtonContent(
            text: text,
            textColor: textColor,
            icon: icon,
            textStyle: textStyle,
          ),
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor ?? Colors.white,
            side: borderColor != null
                ? BorderSide(
                    color: borderColor ?? Theme.of(context).primaryColor)
                : null,
            shape: roundedRectangleBorder,
            minimumSize: Size(width ?? double.maxFinite, height ?? 46),
          ),
          child: _ButtonContent(
            text: text,
            textColor: textColor,
            icon: icon,
            textStyle: textStyle,
          ),
        );
      case ButtonType.filledTonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: roundedRectangleBorder,
            minimumSize: size,
            side: borderColor != null
                ? BorderSide(
                    color: borderColor ?? Theme.of(context).primaryColor)
                : null,
          ),
          child: _ButtonContent(
            text: text,
            textColor: textColor,
            icon: icon,
            textStyle: textStyle,
          ),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            minimumSize: size,
            side: borderColor != null
                ? BorderSide(
                    color: borderColor ?? Theme.of(context).primaryColor)
                : null,
          ),
          child: _ButtonContent(
            text: text,
            textColor: textColor,
            icon: icon,
            textStyle: textStyle,
          ),
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.textColor,
    required this.icon,
    this.textStyle,
  });

  final String text;
  final Color? textColor;
  final IconData? icon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: textStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textColor, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: 2),
          Icon(
            icon,
            size: 14,
          ),
        ],
      ],
    );
  }
}
