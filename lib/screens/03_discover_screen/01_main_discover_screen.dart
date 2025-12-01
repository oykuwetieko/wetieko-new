import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/event_model.dart';

import 'package:Wetieko/widgets/discover/discover_main/discover_category_selector.dart';
import 'package:Wetieko/widgets/discover/discover_main/discover_header.dart';
import 'package:Wetieko/widgets/discover/discover_card/workplace_card.dart';
import 'package:Wetieko/widgets/discover/discover_card/activity_card.dart';
import 'package:Wetieko/widgets/discover/discover_card/together_card.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';

import 'package:Wetieko/data/constants/city_list.dart'; // ✅ cityList için import

class DiscoverScreen extends StatefulWidget {
  final String? initialCategoryKey;

  const DiscoverScreen({super.key, this.initialCategoryKey});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late String selectedCategoryKey;
  late EventStateNotifier eventStateNotifier;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    selectedCategoryKey = widget.initialCategoryKey ?? 'workplaces';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialEvents();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    eventStateNotifier = Provider.of<EventStateNotifier>(context, listen: false);
  }

  Future<void> _fetchInitialEvents() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final type = _getSelectedEventType();
      final placeState = context.read<PlaceStateNotifier>();
      final userState = context.read<UserStateNotifier>().state;

      // ✅ LocationTag ile aynı mantık: cityList içinde yoksa İstanbul
      final city = (userState.city != null && cityList.contains(userState.city))
          ? userState.city!
          : "İstanbul";

      if (selectedCategoryKey == 'workplaces') {
        await placeState.loadPlaces(city: city);
      } else {
        await eventStateNotifier.fetchEvents(type: type);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  EventType? _getSelectedEventType() {
    switch (selectedCategoryKey) {
      case 'cowork':
        return EventType.COWORK;
      case 'activities':
        return EventType.ETKINLIK;
      case 'collaborateNow':
        return EventType.BIRLIKTE_CALIS;
      default:
        return null;
    }
  }

  String _mapCategoryKeyToLocalized(String key, AppLocalizations loc) {
    switch (key) {
      case 'cowork':
        return loc.cowork;
      case 'activities':
        return loc.activities;
      case 'collaborateNow':
        return loc.collaborateNow;
      default:
        return loc.workplaces;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final placeState = context.watch<PlaceStateNotifier>();
    final events = context.watch<EventStateNotifier>().events;
    final selectedType = _getSelectedEventType();
    final selectedCategoryLabel = _mapCategoryKeyToLocalized(selectedCategoryKey, loc);
    final currentUser = context.watch<UserStateNotifier>().state.user;

    return Scaffold(
      backgroundColor: AppColors.neutralLight,
      extendBody: false,
      body: Column(
        children: [
          DiscoverHeader(
            selectedCategory: selectedCategoryLabel,
            workplaces: placeState.places,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DiscoverCategorySelector(
                    selectedCategoryKey: selectedCategoryKey,
                    onCategorySelected: (key) async {
                      if (key == selectedCategoryKey &&
                          eventStateNotifier.isFiltered) {
                        await eventStateNotifier.fetchEvents(
                          type: _getSelectedEventType(),
                        );
                      } else {
                        setState(() {
                          selectedCategoryKey = key;
                        });
                        await _fetchInitialEvents();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  Builder(
                    builder: (context) {
                      if (selectedCategoryKey == 'workplaces') {
                        final places = placeState.places;

                        if (places.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: EmptyStateWidget(
                              type: EmptyStateType.noPlaceWithFeatures,
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DiscoverWorkplaceDetailScreen(place: place),
                                    ),
                                  );
                                },
                                child: WorkplaceCard(place: place),
                              ),
                            );
                          },
                        );
                      }

                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (errorMessage != null) {
                        return Center(child: Text('Hata: $errorMessage'));
                      }

                      final now = DateTime.now();

                      final filtered = events.where((e) {
                        try {
                          final eventDate = DateTime.parse(e.date);
                          final startParts = e.startTime.split(':');
                          final startHour = int.parse(startParts[0]);
                          final startMinute = int.parse(startParts[1]);

                          final eventStart = DateTime(
                            eventDate.year,
                            eventDate.month,
                            eventDate.day,
                            startHour,
                            startMinute,
                          );

                          final isUpcoming = eventStart.isAfter(now);
                          final matchesType =
                              selectedType == null || e.type == selectedType;
                          return isUpcoming && matchesType;
                        } catch (_) {
                          return false;
                        }
                      }).toList();

                      filtered.sort((a, b) {
                        final dateA = DateTime.parse(a.date).add(Duration(
                          hours: int.parse(a.startTime.split(':')[0]),
                          minutes: int.parse(a.startTime.split(':')[1]),
                        ));
                        final dateB = DateTime.parse(b.date).add(Duration(
                          hours: int.parse(b.startTime.split(':')[0]),
                          minutes: int.parse(b.startTime.split(':')[1]),
                        ));
                        return dateA.compareTo(dateB);
                      });

                      if (filtered.isEmpty) {
                        return EmptyStateWidget(
                          type: selectedType == EventType.ETKINLIK
                              ? EmptyStateType.noEvents
                              : selectedType == EventType.COWORK
                                  ? EmptyStateType.noCowork
                                  : EmptyStateType.noCollab,
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final event = filtered[index];
                          final isEventOwner =
                              currentUser?.id == event.creator.id;

                          if (selectedType == EventType.BIRLIKTE_CALIS) {
                            return TogetherCard(
                              event: event,
                              isCreatedByUser: isEventOwner,
                            );
                          } else {
                            return ActivityCard(
                              event: event,
                              isCreatedByUser: isEventOwner,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
