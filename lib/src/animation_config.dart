import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:pretty_animated_text/src/animated_text_controller.dart';

/// Configuration for text animations
class AnimationConfig {
  /// The duration of the animation
  final Duration duration;

  /// The delay before the animation starts
  final Duration delay;

  /// The curve to use for the animation
  final Curve curve;

  /// Whether to reverse the animation
  final bool reverse;

  /// Whether to repeat the animation
  final bool repeat;

  /// The number of times to repeat the animation (null for infinite)
  final int? repeatCount;

  /// The delay between repeats
  final Duration repeatDelay;

  /// The callback when the animation starts
  final void Function(AnimatedTextController)? onPlay;

  /// The callback when the animation completes
  final void Function(AnimatedTextController)? onComplete;

  /// The callback when the animation is dismissed
  final void Function(AnimatedTextController)? onDismissed;

  /// The callback when the animation is paused
  final void Function(AnimatedTextController)? onPause;

  /// The callback when the animation is resumed
  final void Function(AnimatedTextController)? onResume;

  /// The callback when the animation repeats
  final void Function(AnimatedTextController)? onRepeat;

  final AnimationType type;

  const AnimationConfig({
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.reverse = false,
    this.repeat = false,
    this.repeatCount,
    this.repeatDelay = Duration.zero,
    this.onPlay,
    this.onComplete,
    this.onDismissed,
    this.onPause,
    this.onResume,
    this.onRepeat,
    this.type = AnimationType.letter,
  });

  /// Creates a copy of this configuration with the given fields replaced
  AnimationConfig copyWith({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    bool? reverse,
    bool? repeat,
    int? repeatCount,
    Duration? repeatDelay,
    void Function(AnimatedTextController)? onPlay,
    void Function(AnimatedTextController)? onComplete,
    void Function(AnimatedTextController)? onDismissed,
    void Function(AnimatedTextController)? onPause,
    void Function(AnimatedTextController)? onResume,
    void Function(AnimatedTextController)? onRepeat,
    AnimationType? type,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      reverse: reverse ?? this.reverse,
      repeat: repeat ?? this.repeat,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatDelay: repeatDelay ?? this.repeatDelay,
      onPlay: onPlay ?? this.onPlay,
      onComplete: onComplete ?? this.onComplete,
      onDismissed: onDismissed ?? this.onDismissed,
      onPause: onPause ?? this.onPause,
      onResume: onResume ?? this.onResume,
      onRepeat: onRepeat ?? this.onRepeat,
      type: type ?? this.type,
    );
  }
}
