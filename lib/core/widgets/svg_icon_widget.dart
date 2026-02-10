import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget to display SVG icons
class SvgIconWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;

  const SvgIconWidget({
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
