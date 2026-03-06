// Custom Spring Curve using Flutter's SpringSimulation
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A [Curve] that accurately replicates a physical spring simulation.
///
/// It mathematically calculates the physical position without clamping,
/// allowing for a natural, smooth overshoot and settle behavior.
class SpringCurve extends Curve {
  /// By default, parameters are tuned for a pleasant bounce effect.
  const SpringCurve({
    this.mass = 1.0,
    this.stiffness = 80.0,
    this.damping = 10.0,
    this.duration = 1.0,
  });

  /// The mass of the spring.
  final double mass;

  /// The stiffness of the spring.
  final double stiffness;

  /// The damping of the spring.
  final double damping;

  /// Used to map the parameter [t] into the time domain of the simulation.
  final double duration;

  @override
  double transformInternal(double t) {
    // Return precise endpoints
    if (t == 0.0) return 0.0;
    if (t == 1.0) return 1.0;

    // Creating this simulation on the fly is computationally very lightweight.
    final simulation = SpringSimulation(
      SpringDescription(
        mass: mass,
        stiffness: stiffness,
        damping: damping,
      ),
      0.0, // initial position
      1.0, // target position
      0.0, // initial velocity
    );

    // Evaluate the simulation at the scaled elapsed time
    final time = t * duration;
    return simulation.x(time);
  }
}
