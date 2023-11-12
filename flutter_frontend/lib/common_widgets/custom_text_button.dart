import 'package:flutter/material.dart';
import 'package:junction23/constants/design.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final void Function() onPressed;
  final double fontSize;
  final double? width;
  final double? height;
  final Color color;
  final Color hoverColor;
  const CustomTextButton(
      {Key? key,
      required this.text,
      this.width,
      this.color = black,
      this.hoverColor = Colors.blue,
      this.height,
      required this.onPressed,
      this.fontSize = 20})
      : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        maximumSize: widget.width == null
            ? null
            : MaterialStateProperty.resolveWith(
                (states) => Size(widget.width!, widget.height!)),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return widget.hoverColor;
          }
          return widget.color;
        }),
      ),
      onPressed: widget.onPressed,
      child: Text(
        style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.normal),
        widget.text,
      ),
    );
  }
}
