import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated pulsing loader — Apple-style minimal loading indicator.
class AnimatedLoader extends StatefulWidget {
  final Color? color;
  final double size;

  const AnimatedLoader({super.key, this.color, this.size = 48});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.primary;

    return Center(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) => Opacity(
          opacity: _pulse.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: effectiveColor,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated success checkmark drawn via TweenAnimationBuilder.
class AnimatedCheckmark extends StatelessWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedCheckmark({
    super.key,
    this.size = 64,
    this.color = AppColors.success,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              Icons.check_rounded,
              color: color,
              size: size * 0.55,
            ),
          ),
        );
      },
    );
  }
}
