import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final double? width;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.getSurface(context)) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? AppColors.borderRadius),
        border: border ?? Border.all(color: AppColors.getBorder(context), width: 1),
        boxShadow: boxShadow ?? [AppColors.softShadow(context)],
      ),
      padding: padding ?? const EdgeInsets.all(AppColors.padding),
      child: child,
    );
  }
}
