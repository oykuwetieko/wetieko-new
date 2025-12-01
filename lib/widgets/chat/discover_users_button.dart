import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/03_discover_screen/06_discover_search_screen.dart';

class DiscoverUsersButton extends StatelessWidget {
  const DiscoverUsersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.people, color: AppColors.fabBackground),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DiscoverSearchScreen(
              showUsers: true,
              places: [],
            ),
          ),
        );
      },
    );
  }
}
