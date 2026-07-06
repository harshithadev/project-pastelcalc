import 'package:flutter/material.dart';

import '../theme/pastel_theme.dart';

class CalcButton extends StatefulWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = PastelColors.butter,
    this.foregroundColor = PastelColors.textOnAccent,
    this.flex = 1,
    this.isWide = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final int flex;
  final bool isWide;
  final IconData? icon;
  final bool expand;

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    widget.onPressed();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final button = ScaleTransition(
      scale: _scale,
      child: Material(
        color: widget.backgroundColor,
        elevation: 0,
        shadowColor: PastelColors.lavender.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white.withValues(alpha: 0.35),
          highlightColor: Colors.white.withValues(alpha: 0.18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withValues(alpha: 0.55),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.icon != null
                ? Icon(widget.icon, color: widget.foregroundColor, size: 22)
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        widget.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: widget.foregroundColor,
                              fontSize: widget.label.length > 2 ? 18 : 24,
                            ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );

    if (!widget.expand) return button;
    if (widget.isWide) {
      return Expanded(flex: widget.flex, child: button);
    }
    return Expanded(child: button);
  }
}
