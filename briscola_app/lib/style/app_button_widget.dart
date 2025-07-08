import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text_styles.dart';
import 'palette.dart';

class AppButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Palette palette;
  final CustomTextStyles textStyles;

  static const double _horizontalPadding = 15;
  static const double _verticalPadding = 10;
  static const double _borderRadius = 30;
  static const Color _defaultTextColor = Palette.defaultBlue;

  const AppButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.palette,
    required this.textStyles,
    this.textColor,
  });

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _elevation = 4.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_scaleAnimation.value * 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppButtonWidget._borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: _elevation * 2,
                  offset: Offset(0, _elevation),
                ),
              ],
            ),
            child: Material(
              color: widget.palette.defaultButtonBackground,
              elevation: 0,
              borderRadius:
                  BorderRadius.circular(AppButtonWidget._borderRadius),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(AppButtonWidget._borderRadius),
                onTapDown: (_) {
                  _animationController.forward();
                  setState(() {
                    _elevation = 2.0;
                  });
                },
                onTapUp: (_) {
                  _animationController.reverse();
                  setState(() {
                    _elevation = 4.0;
                  });
                },
                onTapCancel: () {
                  _animationController.reverse();
                  setState(() {
                    _elevation = 4.0;
                  });
                },
                onTap: widget.onPressed,
                onLongPress: () {
                  HapticFeedback.heavyImpact();
                },
                splashColor: widget.palette.defaultButtonOverlayColor,
                highlightColor:
                    widget.palette.defaultButtonOverlayColor.withOpacity(0.3),
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppButtonWidget._horizontalPadding,
                    vertical: AppButtonWidget._verticalPadding,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      style: widget.textStyles.buttonText.copyWith(
                        color: widget.textColor ??
                            AppButtonWidget._defaultTextColor,
                        letterSpacing: _scaleAnimation.value * 0.5,
                      ),
                      child: Text(
                        widget.text,
                        style: widget.textStyles.buttonText.copyWith(
                            color: widget.textColor ??
                                AppButtonWidget._defaultTextColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
