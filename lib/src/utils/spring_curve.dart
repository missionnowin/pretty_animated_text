// Custom Spring Curve using Flutter's SpringSimulation
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringCurve extends Curve {
  const SpringCurve();

  SpringSimulation get _sim => SpringSimulation(
        const SpringDescription(
          mass: 1,
          stiffness: 80,
          damping: 10,
        ),
        0,
        1,
        0,
      );

  final double _duration = 1.0; // Total normalized duration

  @override
  double transform(double t) {
    final double time = t * _duration; // Scale to expected time
    final double value = _sim.x(time);

    // Clamp and normalize if necessary
    return value.clamp(0.0, 1.0);
  }
}

class SmoothedSpringCurve extends Curve {
  final List<double> _samples;

  SmoothedSpringCurve({
    int sampleCount = 100,
    SpringDescription spring = const SpringDescription(
      mass: 1,
      stiffness: 80,
      damping: 10,
    ),
  }) : _samples = _generateSamples(sampleCount, spring);

  static List<double> _generateSamples(int count, SpringDescription desc) {
    final simulation = SpringSimulation(desc, 0, 1, 0);
    final List<double> samples = List.filled(count, 0);
    const double maxTime = 3.0; // Enough time for spring to settle

    for (int i = 0; i < count; i++) {
      final t = i / (count - 1);
      final simTime = t * maxTime;
      final x = simulation.x(simTime).clamp(0.0, 1.0);
      samples[i] = x;
    }

    return samples;
  }

  @override
  double transform(double t) {
    final double clampedT = t.clamp(0.0, 1.0);
    final double position = clampedT * (_samples.length - 1);
    final int lower = position.floor();
    final int upper = position.ceil();

    if (lower == upper) return _samples[lower];

    final double mix = position - lower;
    return _samples[lower] * (1 - mix) + _samples[upper] * mix;
  }
}
