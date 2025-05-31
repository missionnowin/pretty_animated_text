// Custom Spring Curve using Flutter's SpringSimulation
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringCurve extends Curve {
  @override
  double transform(double t) {
    // A SpringSimulation that will simulate spring physics.
    final simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        ratio: 0.5,
        stiffness: 400,
        mass: 1,
      ),
      0,
      1,
      5,
      snapToEnd: true,
    );

    return simulation.x(t); // The position of the spring at time t
  }
}
