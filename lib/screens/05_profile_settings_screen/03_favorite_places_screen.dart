import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/discover/discover_card/workplace_card.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/models/place_model.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final placeNotifier = Provider.of<PlaceStateNotifier>(context, listen: false);
      try {
        await placeNotifier.loadFavorites();
      } catch (e) {
        debugPrint('❌ Favoriler yüklenirken hata: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final placeNotifier = Provider.of<PlaceStateNotifier>(context);
    final allFavorites = placeNotifier.favorites;
    final isLoading = placeNotifier.isLoading;

    final filteredPlaces = allFavorites
        .where((place) => place.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: loc.favoritePlaces,
          showStepBar: false,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : allFavorites.isEmpty
                ? const EmptyStateWidget(type: EmptyStateType.noFavorites)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 100),
                      children: [
                        const SizedBox(height: 16),
                        // 🔍 Arama kutusu
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.textFieldBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              color: AppColors.textFieldText,
                              fontSize: 14,
                            ),
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              hintText: loc.searchPlaces,
                              hintStyle: TextStyle(
                                color: AppColors.textFieldText.withOpacity(0.5),
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // 📍 Favori mekan listesi
                        ...filteredPlaces.map((place) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: WorkplaceCard(
                              place: place,
                              showFavoriteIcon: true,
                              onFavoriteRemoved: () {
                                CustomAlert.show(
                                  context,
                                  title: loc.favoriteRemovedTitle,
                                  description: '${place.name} ${loc.favoriteRemovedMessage}',
                                  icon: Icons.check_circle_rounded,
                                  confirmText: loc.ok,
                                  onConfirm: () {},
                                );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DiscoverWorkplaceDetailScreen(place: place),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
