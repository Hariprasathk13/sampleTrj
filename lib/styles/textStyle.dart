import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  const HeadText({
    super.key,
    required this.title,
    this.color=Colors.black,
    this.fontSize=22,
    this.textAlign = TextAlign.start,this.fontWeight=FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            fontSize:fontSize,
            fontWeight: fontWeight,
            color:color));
  }
}

