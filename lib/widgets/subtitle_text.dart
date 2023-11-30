import 'package:flutter/material.dart';

class subTitleTextWidget extends StatelessWidget {
  const subTitleTextWidget({
    super.key,
    required this.label,
    this.color,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
  });

  final String label;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          overflow: TextOverflow.ellipsis),
    );
  }
}
