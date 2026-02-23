import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streak_up/core/constants/app_colors.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// Alışkanlık check butonu widget
///
/// Animated checkbox - tamamlanma durumunu gösterir ve değiştirir
class HabitCheckButton extends StatefulWidget {
  /// Constructor
  const HabitCheckButton({
    super.key,
    required this.isCompleted,
    required this.onToggle,
    this.color,
    this.size = AppDimensions.checkButtonSize,
  });

  /// Tamamlandı mı?
  final bool isCompleted;

  /// Toggle callback
  final VoidCallback onToggle;

  /// Buton rengi (null ise default success rengi)
  final Color? color;

  /// Buton boyutu
  final double size;

  @override
  State<HabitCheckButton> createState() => _HabitCheckButtonState();
}

class _HabitCheckButtonState extends State<HabitCheckButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppDimensions.animationDurationMs,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isCompleted) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(HabitCheckButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted) {
      if (widget.isCompleted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.success;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onToggle();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? buttonColor
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: buttonColor,
                  width: 2.5,
                ),
              ),
              child: widget.isCompleted
                  ? ScaleTransition(
                      scale: _checkAnimation,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: widget.size * 0.5,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
