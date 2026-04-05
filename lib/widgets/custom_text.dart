import 'package:flutter/material.dart';
import 'package:greenbin/configs/font_size.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final bool isItalic;
  final bool isUnderline;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = AppFontSize.bodyMedium,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.height,
    this.isItalic = false,
    this.isUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black87,
        fontWeight: fontWeight,
        height: height,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration:
            isUnderline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}
