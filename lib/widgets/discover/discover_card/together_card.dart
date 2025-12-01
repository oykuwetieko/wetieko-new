import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';
import 'package:Wetieko/core/extensions/date_string_extension.dart';
import 'package:Wetieko/core/extensions/date_age_extension.dart';
import 'package:Wetieko/screens/03_discover_screen/02_discover_together_detail_screen.dart';
import 'package:Wetieko/screens/04_create_options_screen/02_option_activity_screen.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/data/constants/creation_option_type.dart';

class TogetherCard extends StatelessWidget {
  final EventModel event;
  final bool isCreatedByUser;
  final bool canDelete;

  const TogetherCard({
    super.key,
    required this.event,
    required this.isCreatedByUser,
    this.canDelete = false,
  });

  /// ✅ Etkinlik tarihini kontrol et (geçmiş mi)
  bool _isEventCompleted() {
    try {
      DateTime? parsedDate;

      // 🔹 ISO format desteği
      parsedDate = DateTime.tryParse(event.date);

      // 🔹 Eğer ISO değilse manuel çözüm
      if (parsedDate == null) {
        if (event.date.contains('-')) {
          // yyyy-MM-dd
          final dateParts = event.date.split('-');
          final timeParts = event.endTime.split(':');
          parsedDate = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
        } else if (event.date.contains('/')) {
          // dd/MM/yyyy
          final dateParts = event.date.split('/');
          final timeParts = event.endTime.split(':');
          parsedDate = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
        }
      }

      if (parsedDate == null) return false;
      return parsedDate.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = event.title;
    final name = event.creator.name ?? 'Kullanıcı';
    final age = event.creator.birthDate?.calculateAge()?.toString() ?? '';
    final job = event.creator.careerPosition.join(', ');
    final date = event.date.toFormattedDate();
    final hours = '${event.startTime} - ${event.endTime}';
    final location = event.place.name ?? '';
    final description = event.description;
    final placeImageUrl = event.place.imageUrl;
    final loc = AppLocalizations.of(context)!;

    final isEventCompleted = _isEventCompleted();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiscoverTogetherDetailScreen(event: event),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🧱 Ana kart
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            color: AppColors.cardBackground,
            shadowColor: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📸 Görsel
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 90,
                          height: 120,
                          color: Colors.grey[300],
                          child: placeImageUrl != null
                              ? Image.network(
                                  placeImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),

                      /// 📋 Bilgiler
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    age.isNotEmpty ? '$name • $age' : name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onboardingTitle,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCreatedByUser)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.verified,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              job,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textFieldText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            _infoRow(Icons.calendar_today_rounded, date),
                            const SizedBox(height: 3),
                            _infoRow(Icons.access_time_rounded, hours),
                            const SizedBox(height: 3),
                            _infoRow(Icons.location_on_rounded, location),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _shorten(description),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onboardingSubtitle,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          /// 📍 Sağ üst köşedeki "More" butonu (yalnızca geçmiş değilse)
          if (isCreatedByUser && !isEventCompleted)
            Positioned(
              top: -2,
              right: -4,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  enableFeedback: false,
                  elevation: 1.2,
                  color: AppColors.overlayBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.08),
                      width: 0.8,
                    ),
                  ),
                  offset: const Offset(-6, 25),
                  constraints: const BoxConstraints(minWidth: 110),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      height: 28,
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            loc.edit,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onboardingTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      enabled: false,
                      height: 4,
                      child: Divider(
                        height: 1,
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      height: 28,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              size: 16,
                              color: AppColors.logoutButtonBackground),
                          const SizedBox(width: 8),
                          Text(
                            loc.delete,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.logoutButtonBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OptionActivityScreen(
                            type: _mapEventTypeToOptionType(event.type),
                            existingEvent: event,
                            isEditing: true,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      CustomAlert.show(
                        context,
                        title: loc.confirmDeleteTitle,
                        description: loc.confirmDeleteDescription,
                        icon: Icons.delete_forever,
                        confirmText: loc.delete,
                        cancelText: loc.cancel2,
                        onConfirm: () async {
                          try {
                            await context
                                .read<EventStateNotifier>()
                                .deleteEvent(event.id);
                            CustomAlert.show(
                              context,
                              title: loc.deleteSuccessTitle,
                              description: loc.deleteSuccessDescription,
                              icon: Icons.check_circle,
                              confirmText: loc.ok,
                              onConfirm: () {},
                            );
                          } catch (_) {}
                        },
                        onCancel: () {},
                      );
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textFieldText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _shorten(String text, {int maxLength = 100}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trim()}...';
  }

  CreateOptionType _mapEventTypeToOptionType(EventType type) {
    switch (type) {
      case EventType.BIRLIKTE_CALIS:
        return CreateOptionType.collaborate;
      case EventType.COWORK:
        return CreateOptionType.cowork;
      case EventType.ETKINLIK:
        return CreateOptionType.activity;
    }
  }
}
