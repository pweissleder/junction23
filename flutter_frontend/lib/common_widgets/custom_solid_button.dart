import 'package:flutter/material.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';

class CustomSolidButton extends StatefulWidget {
  final String text;
  final double leftMargin;
  final double rightMargin;
  final double botMargin;
  final double topMargin;
  final double fontSize;
  final Function()? onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final IconData? icon;
  final double? width;

  const CustomSolidButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.width,
      this.gradient,
      this.backgroundColor,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.botMargin = 0,
      this.topMargin = 0,
      this.fontSize = h7 + 2,
      this.icon,
      this.isLoading = false})
      : super(key: key);

  @override
  State<CustomSolidButton> createState() => _CustomSolidButtonState();
}

class _CustomSolidButtonState extends State<CustomSolidButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.leftMargin, widget.topMargin,
            widget.rightMargin, widget.botMargin),
        child: widget.isLoading
            ? const CircularProgressIndicator()
            : Container(
                width: widget.width,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  gradient: widget.gradient,
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(Spacing.p16),
                ),
                child: ElevatedButton(
                    onPressed: widget.onPressed,
                    onHover: (value) {
                      setState(() {
                        value ? hovered = true : hovered = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Spacing.p32)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Spacing.p16, Spacing.p8, Spacing.p16, Spacing.p8),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(widget.text,
                              style: TextStyle(
                                  color: black,
                                  fontSize: widget.fontSize,
                                  fontFamily: "NotoSans",
                                  fontWeight: FontWeight.bold)),
                          hovered ? gapW16 : gapW8,
                          if (widget.icon != null)
                            Icon(
                              widget.icon!,
                              size: Spacing.p16,
                            )
                        ])))));
  }
}
