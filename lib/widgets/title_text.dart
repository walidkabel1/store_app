import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget(
      {super.key,
      required this.label,
      this.color,
      this.fontSize = 20,
      this.fontWeight = FontWeight.bold,
      this.fontStyle = FontStyle.italic,
      this.textDecoration = TextDecoration.none,
      this.maxlines});

  final String label;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxlines,
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
