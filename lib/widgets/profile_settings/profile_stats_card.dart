import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/states/place_state_notifier.dart'; // ✅ eklendi

class ProfileStatsCard extends StatefulWidget {
  final bool enableSelection;
  final bool showCounts;
  final void Function(String label)? onSelectionChanged;

  /// ✅ Eğer başka bir kullanıcı gösterilecekse, userId'si verilir
  final String? externalUserId;

  const ProfileStatsCard({
    super.key,
    this.enableSelection = false,
    this.showCounts = true,
    this.onSelectionChanged,
    this.externalUserId,
  });

  @override
  State<ProfileStatsCard> createState() => _ProfileStatsCardState();
}

class _ProfileStatsCardState extends State<ProfileStatsCard> {
  String? selectedLabel;
  Map<String, int> _externalCounts = {
    'cowork': 0,
    'match': 0,
    'activity': 0,
    'checkin': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchCountsIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ProfileStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalUserId != oldWidget.externalUserId) {
      _fetchCountsIfNeeded();
    }
  }

  void _fetchCountsIfNeeded() async {
    final externalId = widget.externalUserId;
    if (externalId != null && externalId.isNotEmpty) {
      final eventNotifier = context.read<EventStateNotifier>();
      final placeNotifier = context.read<PlaceStateNotifier>();

      // ✅ Etkinlik sayaçlarını çek
      await eventNotifier.fetchJoinedCounts(externalId);
      final counts = eventNotifier.joinedCountsByType ?? {};

      // ✅ Check-in listesini çek
      await placeNotifier.loadMyCheckIns(externalId);

      setState(() {
        _externalCounts = {
          'cowork': counts['COWORK'] ?? 0,
          'match': counts['BIRLIKTE_CALIS'] ?? 0,
          'activity': counts['ETKINLIK'] ?? 0,
          'checkin': placeNotifier.myCheckInCount, // ✅ dış kullanıcı için de gerçek veri
        };
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loc = AppLocalizations.of(context)!;

    if (widget.enableSelection && selectedLabel == null) {
      selectedLabel = loc.cowork;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectionChanged?.call(selectedLabel!);
      });
    }
  }

  void _onItemSelected(String label) {
    if (!widget.enableSelection) return;
    setState(() {
      selectedLabel = label;
    });
    widget.onSelectionChanged?.call(label);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    int coworkCount = 0;
    int matchCount = 0;
    int activityCount = 0;
    int checkInCount = 0;

    if (widget.externalUserId == null) {
      // 👤 Giriş yapan kullanıcı için
      final eventNotifier = Provider.of<EventStateNotifier>(context);
      final placeNotifier = Provider.of<PlaceStateNotifier>(context);

      final Map<String, EventModel> uniqueEventsById = {};
      for (final event in [...eventNotifier.createdEvents, ...eventNotifier.joinedEvents]) {
        uniqueEventsById[event.id] = event;
      }

      final allUniqueEvents = uniqueEventsById.values.toList();
      coworkCount =
          allUniqueEvents.where((e) => e.type == EventType.COWORK).length;
      matchCount =
          allUniqueEvents.where((e) => e.type == EventType.BIRLIKTE_CALIS).length;
      activityCount =
          allUniqueEvents.where((e) => e.type == EventType.ETKINLIK).length;

      checkInCount = placeNotifier.myCheckInCount; // ✅ kendi state
    } else {
      // 👤 Dış kullanıcı için
      coworkCount = _externalCounts['cowork'] ?? 0;
      matchCount = _externalCounts['match'] ?? 0;
      activityCount = _externalCounts['activity'] ?? 0;
      checkInCount = _externalCounts['checkin'] ?? 0;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.tagBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildStatItem(label: "Check-in", count: '$checkInCount'),
          _buildDivider(),
          _buildStatItem(label: loc.match, count: '$matchCount'),
          _buildDivider(),
          _buildStatItem(label: loc.cowork, count: '$coworkCount'),
          _buildDivider(),
          _buildStatItem(label: loc.activities, count: '$activityCount'),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String label, required String count}) {
    final bool isSelected = selectedLabel == label;

    return Expanded(
      child: GestureDetector(
        onTap: widget.enableSelection ? () => _onItemSelected(label) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.tagBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              if (widget.showCounts) ...[
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.neutralText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.stepBar.withOpacity(0.2),
    );
  }
}
