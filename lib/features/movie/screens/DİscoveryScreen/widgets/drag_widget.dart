import 'dart:math';

import 'package:flutter/material.dart';

enum SlideDirection {
  left,
  right,
  up,
}

class DragWidget extends StatefulWidget {
  const DragWidget({
    super.key,
    required this.child,
    required this.onSlideOut,
    this.isEnableDrag = true,
  });

  final Widget child;
  final Function(SlideDirection direction) onSlideOut;
  final bool isEnableDrag;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  Offset dragPosition = Offset.zero;
  double dragScale = 1;
  double angle = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
    controller.addListener(() {
      setState(() {
        dragPosition = Offset.lerp(
          dragPosition,
          Offset.zero,
          animation.value,
        )!;
        dragScale = lerpDouble(dragScale, 1, animation.value)!;
        angle = lerpDouble(angle, 0, animation.value)!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return GestureDetector(
      onPanStart: widget.isEnableDrag
          ? (_) {
              controller.stop();
            }
          : null,
      onPanUpdate: widget.isEnableDrag
          ? (details) {
              setState(() {
                dragPosition += details.delta;
                final x = dragPosition.dx;
                angle = 45 * pi / 180 * x / screenWidth;
                dragScale = 1 - 0.1 * dragPosition.distance / screenWidth;
              });
            }
          : null,
      onPanEnd: widget.isEnableDrag
          ? (_) {
              final x = dragPosition.dx;
              final y = dragPosition.dy;

              if (x.abs() >= screenWidth * 0.4) {
                widget.onSlideOut(
                    x > 0 ? SlideDirection.right : SlideDirection.left);
              } else if (y <= -screenHeight * 0.15) {
                widget.onSlideOut(SlideDirection.up);
              } else {
                controller.forward(from: 0);
              }
            }
          : null,
      child: Transform.translate(
        offset: dragPosition,
        child: Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: dragScale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
