import 'package:flutter/material.dart';
import '../configs/app_color.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool hasShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.lightCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(
          color: borderColor!,
          width: borderWidth,
        )
            : null,
        boxShadow: hasShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}