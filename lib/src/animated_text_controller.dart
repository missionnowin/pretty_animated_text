import 'package:flutter/material.dart';

/// A controller for animated text widgets
class AnimatedTextController {
  VoidCallback? _playCallback;
  VoidCallback? _pauseCallback;
  VoidCallback? _resumeCallback;
  VoidCallback? _reverseCallback;
  VoidCallback? _restartCallback;
  void Function({bool reverse})? _repeatCallback;
  void Function(AnimationStatus)? _statusCallback;
  void Function(double)? _progressCallback;

  /// The underlying animation controller
  AnimationController? _animationController;

  /// Current progress of the animation (0.0 to 1.0)
  double get progress => _animationController?.value ?? 0.0;

  /// Whether the animation is currently playing
  bool get isPlaying => _animationController?.isAnimating ?? false;

  /// Whether the animation is paused
  bool get isPaused => !isPlaying && progress > 0.0 && progress < 1.0;

  /// Whether the animation is completed
  bool get isCompleted => _animationController?.status == AnimationStatus.completed;

  /// Whether the animation is dismissed
  bool get isDismissed => _animationController?.status == AnimationStatus.dismissed;

  /// Current status of the animation
  AnimationStatus? get status => _animationController?.status;

  /// Set the underlying animation controller
  set animationController(AnimationController? controller) {
    if (_animationController != null) {
      _animationController!.removeStatusListener(_handleStatusChange);
      _animationController!.removeListener(_handleProgressChange);
    }
    _animationController = controller;
    if (_animationController != null) {
      _animationController!.addStatusListener(_handleStatusChange);
      _animationController!.addListener(_handleProgressChange);
    }
  }

  void _handleStatusChange(AnimationStatus status) {
    _statusCallback?.call(status);
  }

  void _handleProgressChange() {
    _progressCallback?.call(progress);
  }

  /// Play the animation
  void play() {
    _animationController?.forward();
    _playCallback?.call();
  }

  /// Pause the animation
  void pause() {
    _animationController?.stop();
    _pauseCallback?.call();
  }

  /// Resume the animation
  void resume() {
    if (isPaused) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
    _resumeCallback?.call();
  }

  /// Reverse the animation
  void reverse() {
    _animationController?.reverse();
    _reverseCallback?.call();
  }

  /// Restart the animation
  void restart() {
    _animationController?.reset();
    _animationController?.forward();
    _restartCallback?.call();
  }

  /// Repeat the animation
  void repeat({bool reverse = false}) {
    _animationController?.repeat(reverse: reverse);
    _repeatCallback?.call(reverse: reverse);
  }

  /// Set the play callback
  set onPlay(VoidCallback callback) => _playCallback = callback;

  /// Set the pause callback
  set onPause(VoidCallback callback) => _pauseCallback = callback;

  /// Set the resume callback
  set onResume(VoidCallback callback) => _resumeCallback = callback;

  /// Set the reverse callback
  set onReverse(VoidCallback callback) => _reverseCallback = callback;

  /// Set the restart callback
  set onRestart(VoidCallback callback) => _restartCallback = callback;

  /// Set the repeat callback
  set onRepeat(void Function({bool reverse}) callback) => _repeatCallback = callback;

  /// Set the status change callback
  set onStatusChange(void Function(AnimationStatus) callback) => _statusCallback = callback;

  /// Set the progress change callback
  set onProgressChange(void Function(double) callback) => _progressCallback = callback;

  /// Dispose the controller
  void dispose() {
    if (_animationController != null) {
      _animationController!.removeStatusListener(_handleStatusChange);
      _animationController!.removeListener(_handleProgressChange);
    }
  }
} 