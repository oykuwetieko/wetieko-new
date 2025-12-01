import 'package:flutter/material.dart';

class PhotoAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const PhotoAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.orange,
            size: 32,
          ),
        ),
      ),
    );
  }
}
