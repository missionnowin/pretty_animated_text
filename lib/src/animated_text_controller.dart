import 'package:flutter/material.dart';

/// A controller for animated text widgets
class AnimatedTextController {
  VoidCallback? _playCallback;
  VoidCallback? _pauseCallback;
  VoidCallback? _resumeCallback;
  VoidCallback? _reverseCallback;
  VoidCallback? _restartCallback;
  void Function({bool reverse})? _repeatCallback;

  /// Play the animation
  void play() => _playCallback?.call();

  /// Pause the animation
  void pause() => _pauseCallback?.call();

  /// Resume the animation
  void resume() => _resumeCallback?.call();

  /// Reverse the animation
  void reverse() => _reverseCallback?.call();

  /// Restart the animation
  void restart() => _restartCallback?.call();

  /// Repeat the animation
  void repeat({bool reverse = false}) => _repeatCallback?.call(reverse: reverse);

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
} 