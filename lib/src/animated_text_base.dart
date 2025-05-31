import 'package:flutter/material.dart';
import 'package:pretty_animated_text/src/animation_config.dart';
import 'package:pretty_animated_text/src/utils/text_transformation.dart';
import 'package:pretty_animated_text/src/enums/animation_type.dart';
import 'package:pretty_animated_text/src/animated_text_controller.dart';
import 'package:pretty_animated_text/src/utils/interval_step_by_overlap_factor.dart';
import 'package:pretty_animated_text/src/utils/custom_curved_animation.dart';

/// Base widget for text animations that provides efficient animation handling
class AnimatedTextBase extends StatefulWidget {
  /// The text to animate
  final String text;

  /// The style to apply to the text
  final TextStyle? style;

  /// The text alignment
  final TextAlign textAlign;

  /// The animation configuration
  final AnimationConfig config;

  /// The builder function that creates the animated text
  final Widget Function(BuildContext context,
      List<Animation<double>> animations, List<String> segments) builder;

  /// Optional controller to control the animation
  final AnimatedTextController? controller;

  const AnimatedTextBase({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    required this.config,
    required this.builder,
    this.controller,
  });

  @override
  State<AnimatedTextBase> createState() => _AnimatedTextBaseState();
}

class _AnimatedTextBaseState extends State<AnimatedTextBase>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  late List<String> _segments;
  late AnimatedTextController _textController;
  int _repeatCount = 0;

  @override
  void initState() {
    super.initState();

    // Split text into segments based on animation type
    _segments = widget.config.type == AnimationType.letter
        ? widget.text.splittedLetters.map((dto) => dto.text).toList()
        : widget.text.splittedWords.map((dto) => dto.text).toList();

    _controller = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    // Create text controller
    _textController = AnimatedTextController();
    _textController.onPlay = play;
    _textController.onPause = pause;
    _textController.onResume = resume;
    _textController.onReverse = reverse;
    _textController.onRestart = restart;
    _textController.onRepeat = repeat;

    // Add status listener for callbacks
    _controller.addStatusListener(_handleAnimationStatus);

    // Create overlapped animations for each segment
    final segmentCount = _segments.length;
    final intervalStep = intervalStepByOverlapFactor(segmentCount, widget.config.overlapFactor);

    _animations = List.generate(segmentCount, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        curvedAnimation(
          _controller,
          index,
          intervalStep,
          widget.config.overlapFactor,
          curve: widget.config.curve,
        ),
      );
    });

    // Initialize external controller if provided
    if (widget.controller != null) {
      widget.controller!.onPlay = play;
      widget.controller!.onPause = pause;
      widget.controller!.onResume = resume;
      widget.controller!.onReverse = reverse;
      widget.controller!.onRestart = restart;
      widget.controller!.onRepeat = repeat;
    }

    _setupAnimation();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        widget.config.onPlay?.call(_textController);
        break;
      case AnimationStatus.completed:
        widget.config.onComplete?.call(_textController);
        if (widget.config.repeat) {
          _handleRepeat();
        }
        break;
      case AnimationStatus.dismissed:
        widget.config.onDismissed?.call(_textController);
        break;
      case AnimationStatus.reverse:
        widget.config.onRepeat?.call(_textController);
        break;
    }
  }

  void _handleRepeat() {
    if (widget.config.repeatCount != null) {
      _repeatCount++;
      if (_repeatCount >= widget.config.repeatCount!) {
        return;
      }
    }
    
    if (widget.config.repeatDelay > Duration.zero) {
      Future.delayed(widget.config.repeatDelay, () {
        if (mounted) {
          _controller.reset();
          if (widget.config.reverse) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        }
      });
    } else {
      _controller.reset();
      if (widget.config.reverse) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  void _setupAnimation() {
    if (widget.config.delay > Duration.zero) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          _startAnimation();
        }
      });
    } else {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _repeatCount = 0;
    if (widget.config.reverse) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  // Public methods to control animation
  void play() {
    _repeatCount = 0;
    _controller.forward();
    widget.config.onPlay?.call(_textController);
  }

  void pause() {
    _controller.stop();
    widget.config.onPause?.call(_textController);
  }

  void resume() {
    _controller.forward();
    widget.config.onResume?.call(_textController);
  }

  void reverse() {
    _controller.reverse();
  }

  void restart() {
    _repeatCount = 0;
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 10), () {
      if (widget.config.reverse) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      widget.config.onPlay?.call(_textController);
    });
  }

  void repeat({bool reverse = false}) {
    _repeatCount = 0;
    _controller.repeat(reverse: reverse);
    widget.config.onRepeat?.call(_textController);
  }

  @override
  void didUpdateWidget(AnimatedTextBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config || oldWidget.text != widget.text) {
      _controller.duration = widget.config.duration;
      _repeatCount = 0;

      // Recreate animations with new configuration
      final segmentCount = _segments.length;
      final intervalStep = intervalStepByOverlapFactor(segmentCount, widget.config.overlapFactor);

      _animations = List.generate(segmentCount, (index) {
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          curvedAnimation(
            _controller,
            index,
            intervalStep,
            widget.config.overlapFactor,
            curve: widget.config.curve,
          ),
        );
      });

      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.builder(context, _animations, _segments);
      },
    );
  }
}
