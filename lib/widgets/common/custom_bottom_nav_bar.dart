import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 🔢 Okunmamış mesaj sayısı (socket üzerinden anlık gelir)
  final int unreadCount;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.unreadCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(
            painter: NavBarPainter(),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(icon: Icons.explore, index: 0),
                  _navIcon(icon: Icons.message, index: 1),
                  const SizedBox(width: 60),
                  _navIcon(icon: Icons.event, index: 3),
                  _navIcon(icon: Icons.person, index: 4),
                ],
              ),
            ),
          ),
          // 🔹 Ortadaki "Add" butonu
          Positioned(
            top: -40,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: FloatingActionButton(
                onPressed: () => onTap(2),
                backgroundColor: AppColors.fabBackground,
                foregroundColor: AppColors.fabIcon,
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon({required IconData icon, required int index}) {
    final isMessageIcon = icon == Icons.message;
    final showBadge = isMessageIcon && unreadCount > 0;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index
                ? AppColors.bottomNavActive
                : AppColors.bottomNavInactive,
          ),
          if (showBadge)
            Positioned(
              right: -6,
              top: -4,
              child: _buildBadge(unreadCount),
            ),
        ],
      ),
    );
  }

  /// 🔴 Küçük kırmızı nokta veya sayı gösterimi
  Widget _buildBadge(int count) {
    if (count <= 0) return const SizedBox.shrink();

    // 1–9: küçük daire, 10+ : sayı kutucuğu
    final showNumber = count > 9 ? "9+" : count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        showNumber,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = AppColors.onboardingBackground
      ..style = PaintingStyle.fill;

    final barPaint = Paint()
      ..color = AppColors.bottomNavBackground
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    const slopeHeight = 24.0;
    const dipDepth = 70.0;
    const dipEdge = 65.0;

    // Arka plan
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);

    // Özel kavisli path
    path.moveTo(0, 0);
    path.lineTo(centerX - dipEdge, 0);
    path.quadraticBezierTo(centerX - dipEdge + 15, 0, centerX - dipEdge + 30, slopeHeight);
    path.quadraticBezierTo(centerX, dipDepth, centerX + dipEdge - 30, slopeHeight);
    path.quadraticBezierTo(centerX + dipEdge - 15, 0, centerX + dipEdge, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 4, true);
    canvas.drawPath(path, barPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
