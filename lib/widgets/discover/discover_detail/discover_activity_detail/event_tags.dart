import 'package:flutter/material.dart';
import 'package:Wetieko/models/event_model.dart'; // ActivityTag burada tanımlıysa

import 'package:Wetieko/core/theme/colors.dart';

class EventTagsWidget extends StatelessWidget {
  final List<ActivityTag> tags;

  const EventTagsWidget({
    Key? key,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.neutralGrey,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tag.icon,
                size: 16,
                color: AppColors.neutralDark,
              ),
              const SizedBox(width: 6),
              Text(
                tag.label,
                style: const TextStyle(
                  color: AppColors.neutralDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
