import 'package:flutter/material.dart';
import '../configs/app_color.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
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
    this.onTap,
    this.hasShadow = true,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (!_isHovered && widget.onTap != null) {
      _isHovered = true;
      _hoverController.forward();
    }
  }

  void _onHoverExit() {
    if (_isHovered) {
      _isHovered = false;
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.lightCard,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: widget.borderColor != null
                    ? Border.all(
                  color: widget.borderColor!,
                  width: widget.borderWidth,
                )
                    : null,
                boxShadow: widget.hasShadow
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05 + (_elevationAnimation.value * 0.05)),
                    blurRadius: 10 + (_elevationAnimation.value * 4),
                    offset: Offset(0, 2 + _elevationAnimation.value),
                  ),
                ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  splashColor: AppColors.primary.withOpacity(0.1),
                  highlightColor: AppColors.primary.withOpacity(0.05),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(16.0),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}