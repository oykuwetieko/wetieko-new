import 'package:flutter/material.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/date_string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/widgets/common/map_options_bottom_sheet.dart';
import 'package:Wetieko/widgets/common/profile_detail_button.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/states/user_state_notifier.dart';

class ActivityOverview extends StatelessWidget {
  final EventModel event;

  const ActivityOverview({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final title = event.title;
    final date = event.date.toFormattedDate();
    final hours = '${event.startTime} - ${event.endTime}';
    final location = event.place.name ?? '';
    final creator = event.creator;
    final creatorName = creator.name ?? 'Organizatör';
    final creatorImage = creator.profileImage;
    final place = event.place;

    final currentUserId = context.read<UserStateNotifier>().state.user?.id;
    final isOwnProfile = creator.id == currentUserId;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Başlık
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.onboardingTitle,
            ),
          ),

          const SizedBox(height: 8),

          /// 👤 Organizator (resim + ad + buton)
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.tagBackground,
                child: (creatorImage != null && creatorImage.trim().isNotEmpty)
                    ? ClipOval(
                        child: Image.network(
                          creatorImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                creatorName,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              ProfileDetailButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileViewScreen(
                        externalUser: isOwnProfile ? null : creator,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 📅 Tarih & saat
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                '$date • $hours',
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.onboardingSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 📍 Lokasyon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.onboardingSubtitle,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => MapOptionsBottomSheet(place: place),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.near_me,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
