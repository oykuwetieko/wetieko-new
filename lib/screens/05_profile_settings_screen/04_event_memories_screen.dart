import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/profile_settings/past_future_tab_switcher.dart';
import 'package:Wetieko/widgets/profile_settings/add_button_widget.dart';
import 'package:Wetieko/widgets/profile_settings/cowork_event_match_segment.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/widgets/discover/discover_card/activity_card.dart';
import 'package:Wetieko/widgets/discover/discover_card/together_card.dart';
import 'package:Wetieko/states/event_state_notifier.dart';

class EventMemoriesScreen extends StatefulWidget {
  const EventMemoriesScreen({super.key});

  @override
  State<EventMemoriesScreen> createState() => _EventMemoriesScreenState();
}

class _EventMemoriesScreenState extends State<EventMemoriesScreen> {
  String? selectedLabel;
  int selectedTabIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final notifier = context.read<EventStateNotifier>();
    await notifier.fetchJoinedEvents();
    await notifier.fetchCreatedEvents();
    setState(() => isLoading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;
    selectedLabel ??= loc.cowork;
  }

  /// ✅ Tüm tarih formatlarını (ISO, yyyy-MM-dd, dd/MM/yyyy) destekleyen parser
  DateTime? parseDate(String dateStr, String timeStr) {
    try {
      final timeParts = timeStr.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // ISO 8601 formatı (örnek: 2025-10-27T00:00:00.000Z)
      if (dateStr.contains('T')) {
        final parsed = DateTime.parse(dateStr).toLocal();
        return DateTime(parsed.year, parsed.month, parsed.day, hour, minute);
      }

      // dd/MM/yyyy
      if (dateStr.contains('/')) {
        final d = dateStr.split('/');
        return DateTime(
          int.parse(d[2]),
          int.parse(d[1]),
          int.parse(d[0]),
          hour,
          minute,
        );
      }

      // yyyy-MM-dd
      if (dateStr.contains('-')) {
        final d = dateStr.split('-');
        return DateTime(
          int.parse(d[0]),
          int.parse(d[1]),
          int.parse(d[2]),
          hour,
          minute,
        );
      }

      return null;
    } catch (e) {
      debugPrint('❌ parseDate hatası: $e ($dateStr $timeStr)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();

    final joinedEvents = context.watch<EventStateNotifier>().joinedEvents;
    final createdEvents = context.watch<EventStateNotifier>().createdEvents;

    // 🔹 Aynı ID'ye sahip etkinlikleri tekilleştir
    final allEventsMap = <String, EventModel>{};
    for (var e in [...joinedEvents, ...createdEvents]) {
      allEventsMap[e.id] = e;
    }
    final allEvents = allEventsMap.values.toList();

    final createdEventIds = createdEvents.map((e) => e.id).toSet();

    // 🔹 Tarih + saat olarak filtreleme (debug print’li)
    final filteredByTime = allEvents.where((event) {
      try {
        final startDateTime = parseDate(event.date, event.startTime);
        final endDateTime = parseDate(event.date, event.endTime);
        if (startDateTime == null || endDateTime == null) {
          debugPrint('⚠️ [${event.title}] tarih parse edilemedi: ${event.date}');
          return false;
        }

        final now = DateTime.now();
        

        if (selectedTabIndex == 0) {
          final isFuture = endDateTime.isAfter(now);
        
          return isFuture;
        } else {
          final isPast = endDateTime.isBefore(now);
         
          return isPast;
        }
      } catch (e) {
        debugPrint('❌ Hata [${event.title}]: $e');
        return false;
      }
    }).toList();

    // 🔹 Tür filtresi
    final filteredByType = filteredByTime.where((event) {
      if (selectedLabel == loc.match) {
        return event.type == EventType.BIRLIKTE_CALIS;
      } else if (selectedLabel == loc.activities) {
        return event.type == EventType.ETKINLIK;
      } else {
        return event.type == EventType.COWORK;
      }
    }).toList();

    // 🔹 Sıralama
    filteredByType.sort((a, b) {
      final dateA = parseDate(a.date, a.startTime) ?? DateTime.now();
      final dateB = parseDate(b.date, b.startTime) ?? DateTime.now();
      return selectedTabIndex == 0
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });

    // 🔹 Önce oluşturulanlar, sonra katıldıkların
    final sortedFilteredEvents = [
      ...filteredByType.where((e) => createdEventIds.contains(e.id)),
      ...filteredByType.where((e) => !createdEventIds.contains(e.id)),
    ];

    EmptyStateType? emptyType;
    if (!isLoading && sortedFilteredEvents.isEmpty) {
      if (selectedLabel == loc.match) {
        emptyType = EmptyStateType.noCollab;
      } else if (selectedLabel == loc.activities) {
        emptyType = EmptyStateType.noEvents;
      } else {
        emptyType = EmptyStateType.noCowork;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.eventHistory,
        showStepBar: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CoworkEventMatchSegment(
                selectedLabel: selectedLabel,
                onSelectionChanged: (label) {
                  setState(() {
                    selectedLabel = label;
                  });
                },
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TabSwitcher(
                  onTabChanged: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : sortedFilteredEvents.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: sortedFilteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = sortedFilteredEvents[index];
                              final isCreatedByUser =
                                  createdEventIds.contains(event.id);
                              final canDelete =
                                  isCreatedByUser && selectedTabIndex == 0;

                              if (event.type == EventType.ETKINLIK ||
                                  event.type == EventType.COWORK) {
                                return ActivityCard(
                                  event: event,
                                  isCreatedByUser: isCreatedByUser,
                                  canDelete: canDelete,
                                );
                              } else {
                                return TogetherCard(
                                  event: event,
                                  isCreatedByUser: isCreatedByUser,
                                  canDelete: canDelete,
                                );
                              }
                            },
                          ),
              ),
            ],
          ),
          if (!isLoading &&
              sortedFilteredEvents.isEmpty &&
              emptyType != null)
            Center(child: EmptyStateWidget(type: emptyType!)),
          AddButtonWidget(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const MainNavigationWrapper(initialIndex: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
