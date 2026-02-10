import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom clipper for navbar notch to accommodate QR button
/// Follows Single Responsibility Principle (SRP)
/// Creates a triangular notch in the center of the navbar
class NavbarNotchClipper extends CustomClipper<Path> {
  final double notchWidth;
  final double notchDepth;

  const NavbarNotchClipper({this.notchWidth = 100, this.notchDepth = 60});

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final notchTop = 0.0; // Notch starts at the top edge
    final notchBottom = notchDepth; // Depth of the notch (pointing downward)
    final cornerRadius = 8.0; // Radius for rounded corners at notch edges
    final notchHalfWidth = notchWidth / 2;

    // Start from top left
    path.moveTo(0, notchTop);

    // Line to left edge of notch (before rounded corner)
    path.lineTo(centerX - notchHalfWidth - cornerRadius, notchTop);

    // Rounded corner at left edge of notch (top-left corner)
    path.arcToPoint(
      Offset(centerX - notchHalfWidth, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
      largeArc: false,
    );

    // Bottom point of notch (center, pointing downward into the navbar)
    path.lineTo(centerX, notchBottom);

    // Right side of notch - line back to top edge (before rounded corner)
    path.lineTo(centerX + notchHalfWidth, cornerRadius);

    // Rounded corner at right edge of notch (top-right corner)
    path.arcToPoint(
      Offset(centerX + notchHalfWidth + cornerRadius, notchTop),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
      largeArc: false,
    );

    // Continue to top right
    path.lineTo(size.width, notchTop);

    // Line to bottom right
    path.lineTo(size.width, size.height);

    // Line to bottom left
    path.lineTo(0, size.height);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}

/// Custom clipper for QR button to create triangular cutout at bottom
/// Follows Single Responsibility Principle (SRP)
/// Creates a circular button with a triangular notch at the bottom
class QrButtonNotchClipper extends CustomClipper<Path> {
  final double notchWidth;
  final double notchDepth;

  const QrButtonNotchClipper({this.notchWidth = 100, this.notchDepth = 25});

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;
    final notchHalfWidth = notchWidth / 2;

    // Create a circle with a triangular notch at the bottom
    // The notch creates a cutout that allows the navbar to show through

    // Start from top of circle and go clockwise
    // Start at angle -90 degrees (top)
    final startAngle = -math.pi / 2;

    // Calculate where the notch starts (right side of notch)
    // Angle from center to right edge of notch
    final notchStartAngle = math.asin(notchHalfWidth / radius);

    // Draw arc from top to right side of notch
    path.addArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      math.pi + notchStartAngle, // Go around to right side of notch
    );

    // Now we're at the right edge of the notch on the circle
    // Create triangular notch pointing inward (upward)
    // Right point of notch (on circle edge)
    final notchRightX = centerX + notchHalfWidth;
    final notchRightY = size.height;

    // Top point of notch (center of cutout, pointing inward)
    final notchTopX = centerX;
    final notchTopY = size.height - notchDepth;

    // Left point of notch (on circle edge)
    final notchLeftX = centerX - notchHalfWidth;
    final notchLeftY = size.height;

    // Draw the notch triangle (cutting inward)
    path.lineTo(notchRightX, notchRightY);
    path.lineTo(notchTopX, notchTopY);
    path.lineTo(notchLeftX, notchLeftY);

    // Continue the circle from left side of notch back to top
    final notchEndAngle = -notchStartAngle;
    path.addArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle + notchEndAngle, // Start from left side of notch
      math.pi - notchStartAngle - notchEndAngle, // Complete the circle
    );

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
