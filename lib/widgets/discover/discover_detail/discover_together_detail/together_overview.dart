import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/profile_detail_button.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/core/extensions/date_string_extension.dart';
import 'package:Wetieko/core/extensions/date_age_extension.dart';
import 'package:Wetieko/widgets/common/map_options_bottom_sheet.dart';
import 'package:Wetieko/states/user_state_notifier.dart';

class TogetherOverview extends StatelessWidget {
  final EventModel event;

  const TogetherOverview({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final name = event.creator.name;
    final age = event.creator.birthDate?.calculateAge().toString() ?? '';
    final job = event.creator.careerPosition.join(', ');
    final title = event.title;
    final date = event.date.toFormattedDate();
    final hours = '${event.startTime} - ${event.endTime}';
    final location = event.place.name ?? '';
    final place = event.place;

    final currentUserId = context.read<UserStateNotifier>().state.user?.id;
    final isOwnProfile = event.creator.id == currentUserId;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 👤 İsim, yaş, job, title ve profil butonu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Kullanıcı bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      age.isNotEmpty ? '$name • $age' : name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onboardingTitle,
                        height: 1.4,
                      ),
                    ),
                    if (job.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          job,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                AppColors.onboardingSubtitle.withOpacity(0.85),
                          ),
                        ),
                      ),
                    if (title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              /// 👉 Profili Gör butonu
              ProfileDetailButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileViewScreen(
                        externalUser: isOwnProfile ? null : event.creator,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

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

          const SizedBox(height: 2),

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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
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
