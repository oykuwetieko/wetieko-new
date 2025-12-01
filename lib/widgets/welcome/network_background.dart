import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class NetworkBackground extends StatelessWidget {
  const NetworkBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bottomNavBackground, // Eklenen renk
            AppColors.neutralDark,
            AppColors.primary,
          ],
        ),
      ),
      child: Stack(
        children: const [
          Positioned.fill(child: GradientHaloLayer()),
          Positioned.fill(child: BezierGridPainterLayer()),
          Positioned.fill(child: VisualNodeLayer()),
        ],
      ),
    );
  }
}

class GradientHaloLayer extends StatelessWidget {
  const GradientHaloLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.1, -0.4),
          radius: 1.4,
          colors: [
            AppColors.primary.withOpacity(0.25),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class BezierGridPainterLayer extends StatelessWidget {
  const BezierGridPainterLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BezierGlowPainter());
  }
}

class _BezierGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = AppColors.bottomNavBackground.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final paths = <Path>[];

    final rows = [0.2, 0.4, 0.6, 0.8];
    for (var y in rows) {
      final path = Path();
      path.moveTo(0, size.height * y);
      path.cubicTo(
        size.width * 0.3,
        size.height * (y - 0.1),
        size.width * 0.7,
        size.height * (y + 0.1),
        size.width,
        size.height * y,
      );
      paths.add(path);
    }

    final columns = [0.2, 0.4, 0.6, 0.8];
    for (var x in columns) {
      final path = Path();
      path.moveTo(size.width * x, 0);
      path.cubicTo(
        size.width * (x - 0.1),
        size.height * 0.3,
        size.width * (x + 0.1),
        size.height * 0.7,
        size.width * x,
        size.height,
      );
      paths.add(path);
    }

    for (final path in paths) {
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, basePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class VisualNodeLayer extends StatelessWidget {
  const VisualNodeLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final positions = [
      Offset(40, 100),
      Offset(160, 60),
      Offset(280, 90),
      Offset(100, 200),
      Offset(220, 180),
      Offset(320, 240),
      Offset(60, 320),
      Offset(180, 300),
      Offset(290, 330),
    ];

    final icons = [
      Icons.wifi,
      Icons.chat_bubble_outline,
      Icons.laptop_mac,
      Icons.groups,
     
    ];

    final imagePaths = [
      'assets/images/w3.png',
      'assets/images/w4.png',
      'assets/images/w2.png',
      'assets/images/w1.png',
      'assets/images/w5.png',
    ];

    return Stack(
      children: positions.asMap().entries.map((entry) {
        final i = entry.key;
        final pos = entry.value;
        final isImage = i % 2 == 0;
        final size = 50.0 + (i % 3) * 6.0;

        final icon = icons[(i ~/ 2) % icons.length];

        return Positioned(
          top: pos.dy,
          left: pos.dx,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.neutralLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.9),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: AppColors.bottomNavActive.withOpacity(0.8),
                  blurRadius: 6,
                  spreadRadius: -2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: isImage
                  ? CircleAvatar(
                      backgroundImage: AssetImage(
                        imagePaths[i % imagePaths.length],
                      ),
                      radius: size * 0.4,
                      backgroundColor: Colors.transparent,
                    )
                  : Icon(
                      icon,
                      size: size * 0.48,
                      color: AppColors.primary,
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
