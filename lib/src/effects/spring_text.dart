import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pretty_animated_text/src/widgets/paragraph_text.dart';
import 'package:pretty_animated_text/src/animated_text_base.dart';
import 'package:pretty_animated_text/src/animated_text_controller.dart';
import 'package:pretty_animated_text/src/animation_config.dart';

/// A widget that animates text with a spring effect
class SpringText extends StatelessWidget {
  /// The text to animate
  final String text;

  /// The style to apply to the text
  final TextStyle? style;

  /// The text alignment
  final TextAlign textAlign;

  /// The animation configuration
  final AnimationConfig config;

  /// On controller created
  final void Function(AnimatedTextController)? onControllerCreated;

  const SpringText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    required this.config,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextBase(
      text: text,
      style: style,
      textAlign: textAlign,
      config: config,
      onControllerCreated: onControllerCreated,
      builder: (context, animations, segments) {
        return Wrap(
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : textAlign == TextAlign.end
                  ? WrapAlignment.end
                  : WrapAlignment.start,
          children: List.generate(segments.length, (index) {
            final rotateAnimation =
                Tween<double>(begin: 180.0, end: 0.0).animate(
              CurvedAnimation(
                parent: animations[index],
                curve: config.curve,
              ),
            );

            final springAnimation = Tween<double>(begin: 1, end: 0).animate(
              CurvedAnimation(
                parent: animations[index],
                curve: config.curve,
              ),
            );

            return AnimatedBuilder(
              animation: springAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..translate(0.0, springAnimation.value.clamp(-1.0, 1.0))
                    ..rotateZ(rotateAnimation.value * pi / 180),
                  child: Opacity(
                    opacity: animations[index].value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: ParagraphText(
                segments[index],
                style: style,
              ),
            );
          }),
        );
      },
    );
  }
}
