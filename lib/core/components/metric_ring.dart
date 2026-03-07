import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated circular progress ring with gradient stroke using CustomPainter.
/// Shows icon, value, and unit in the center.
class MetricRing extends StatefulWidget {
  final double progress; // 0.0 – 1.0
  final String value;
  final String unit;
  final IconData icon;
  final Gradient gradient;
  final double size;

  const MetricRing({
    super.key,
    required this.progress,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gradient,
    this.size = 160,
  });

  @override
  State<MetricRing> createState() => _MetricRingState();
}

class _MetricRingState extends State<MetricRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(MetricRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Extract primary color from gradient
    final ringColor = (widget.gradient as LinearGradient).colors.last;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => CustomPaint(
          painter: _RingPainter(
            progress: _animation.value,
            gradient: widget.gradient,
            trackColor: isDark ? AppColors.progressTrackDark : AppColors.progressTrackLight,
            strokeWidth: widget.size * 0.09,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: ringColor, size: widget.size * 0.18),
                const SizedBox(height: 4),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: widget.size * 0.175,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    height: 1.0,
                  ),
                ),
                Text(
                  widget.unit,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: widget.size * 0.09,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.gradient,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Gradient arc
    final sweepAngle = 2 * 3.141592653589793 * progress;
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -3.141592653589793 / 2, // Start at top
      sweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
