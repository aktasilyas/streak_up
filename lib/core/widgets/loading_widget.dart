import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// Loading göstergesi widget
///
/// Ortada tema renkli CircularProgressIndicator gösterir
class LoadingWidget extends StatelessWidget {
  /// Loading widget constructor
  const LoadingWidget({
    super.key,
    this.message,
    this.size,
  });

  /// Loading mesajı (opsiyonel)
  final String? message;

  /// Progress indicator boyutu
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Küçük loading göstergesi
///
/// Inline kullanım için küçük boyutlu progress indicator
class SmallLoadingWidget extends StatelessWidget {
  /// Small loading widget constructor
  const SmallLoadingWidget({
    super.key,
    this.color,
    this.size = 16.0,
  });

  /// Progress indicator rengi
  final Color? color;

  /// Progress indicator boyutu
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Overlay loading widget
///
/// Ekranın üzerine loading overlay gösterir
class LoadingOverlay extends StatelessWidget {
  /// Loading overlay constructor
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.opacity = 0.5,
  });

  /// Loading durumu
  final bool isLoading;

  /// Alt widget
  final Widget child;

  /// Loading mesajı
  final String? message;

  /// Overlay opacity
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: opacity),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}

/// Shimmer loading effect için placeholder
///
/// Veri yüklenirken skeleton screen gösterir
class ShimmerLoading extends StatefulWidget {
  /// Shimmer loading constructor
  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  /// Genişlik
  final double width;

  /// Yükseklik
  final double height;

  /// Border radius
  final double? borderRadius;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFE0E0E0);
    final highlightColor = isDark
        ? const Color(0xFF616161)
        : const Color(0xFFF5F5F5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusM,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Linear progress indicator widget
///
/// Horizontal progress bar gösterir
class LinearLoadingWidget extends StatelessWidget {
  /// Linear loading widget constructor
  const LinearLoadingWidget({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.minHeight,
  });

  /// Progress value (0.0 - 1.0), null ise indeterminate
  final double? value;

  /// Background color
  final Color? backgroundColor;

  /// Progress color
  final Color? color;

  /// Minimum height
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: backgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      color: color ?? Theme.of(context).colorScheme.primary,
      minHeight: minHeight ?? 4.0,
    );
  }
}
