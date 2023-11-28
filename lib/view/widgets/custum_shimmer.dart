import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  ShimmerWidget.circle(
      {super.key,
      required this.height,
      required this.width,
      this.shapeBorder = const CircleBorder()});

  ShimmerWidget.rectangular(
      {required this.height,
      required this.width,
      this.shapeBorder = const RoundedRectangleBorder()});

  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade800,
      child: Container(
        height: height,
        width: width,
        decoration:
            ShapeDecoration(color: Colors.grey.shade800, shape: shapeBorder),
      ),
    );
  }
}
