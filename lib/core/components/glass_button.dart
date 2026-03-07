import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// A premium glassmorphic button with scale animation, haptic feedback, and glow.
class GlassButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? glowColor;
  final bool isLoading;
  final bool outlined;
  final double? width;
  final double height;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.gradient,
    this.glowColor,
    this.isLoading = false,
    this.outlined = false,
    this.width,
    this.height = 54,
  });

  const GlassButton.outlined({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.glowColor,
    this.isLoading = false,
    this.width,
    this.height = 54,
  })  : gradient = null,
        outlined = true;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.onPressed == null || widget.isLoading) return;
    _controller.reverse();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(_) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveGradient = widget.gradient ?? AppColors.primaryGradient;
    final effectiveGlow = widget.glowColor ?? AppColors.primary.withOpacity(0.4);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: widget.outlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.glassBorder : AppColors.borderLight,
                    width: 1.5,
                  ),
                  color: isDark
                      ? AppColors.glassWhite
                      : Colors.white.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveGlow.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                )
              : BoxDecoration(
                  gradient: isDisabled
                      ? LinearGradient(
                          colors: [Colors.grey.shade600, Colors.grey.shade700])
                      : effectiveGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveGlow,
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.outlined
                                  ? (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight)
                                  : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: widget.outlined
                                  ? (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.primary)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
