import 'package:flutter/material.dart';

/// Small, shared sizing helpers that keep the compact mobile layout usable on
/// both narrow phones and large text-scale accessibility settings.
extension ResponsiveBuildContext on BuildContext {
  double get horizontalPadding {
    final width = MediaQuery.sizeOf(this).width;
    return (width * .055).clamp(16.0, 28.0).toDouble();
  }

  double get verticalGap =>
      (MediaQuery.sizeOf(this).height * .02).clamp(12.0, 24.0).toDouble();
}
