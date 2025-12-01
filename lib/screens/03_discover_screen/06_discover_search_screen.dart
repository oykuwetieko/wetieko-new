import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/discover/discover_main/search_header.dart';
import 'package:Wetieko/widgets/discover/discover_main/profile_search_list.dart';
import 'package:Wetieko/widgets/discover/discover_main/workplace_search_list.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';
import 'package:Wetieko/data/constants/city_list.dart'; // ✅ cityList kontrolü için eklendi

class DiscoverSearchScreen extends StatefulWidget {
  final bool showUsers;
  final bool showHeader;
  final List<Place> places;
  final ValueChanged<Place>? onPlaceSelected;

  const DiscoverSearchScreen({
    super.key,
    this.showUsers = false,
    this.showHeader = true,
    required this.places,
    this.onPlaceSelected,
  });

  @override
  State<DiscoverSearchScreen> createState() => _DiscoverSearchScreenState();
}

class _DiscoverSearchScreenState extends State<DiscoverSearchScreen> {
  late bool showUsers;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    showUsers = widget.showUsers;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (showUsers) {
        // Kullanıcılar sekmesi için kullanıcıları çek
        await context.read<UserStateNotifier>().fetchAllUsers();
      } else {
        // Mekanlar sekmesi için şehir doğrulaması yap
        final userCity = context.read<UserStateNotifier>().state.city;
        final validCity =
            (userCity != null && cityList.contains(userCity)) ? userCity : "İstanbul";
        await context.read<PlaceStateNotifier>().loadPlaces(city: validCity);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onToggle(bool value) async {
    setState(() {
      showUsers = value;
    });

    if (value) {
      // Kullanıcılar sekmesine geçildi
      await context.read<UserStateNotifier>().fetchAllUsers();
    } else {
     
      final userCity = context.read<UserStateNotifier>().state.city;
      final validCity =
          (userCity != null && cityList.contains(userCity)) ? userCity : "İstanbul";
      await context.read<PlaceStateNotifier>().loadPlaces(city: validCity);
    }
  }

  void _onPlaceSelected(Place place) {
    if (widget.onPlaceSelected != null) {
      Navigator.pop(context, place);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscoverWorkplaceDetailScreen(place: place),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final placeNotifier = context.watch<PlaceStateNotifier>();

    final hintText = showUsers
        ? loc.whoDoYouWantToWorkWithToday
        : loc.whereDoYouWantToWorkToday;

    final appBarTitle = showUsers ? loc.users : loc.places;

    return Scaffold(
      backgroundColor: AppColors.neutralLight,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.bottomNavBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.neutralLight,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: AppColors.neutralLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SearchHeader(
              showUsers: showUsers,
              onToggle: widget.showHeader ? _onToggle : null,
              hintText: hintText,
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: showUsers
                  ? ProfileSearchList(searchQuery: searchQuery)
                  : placeNotifier.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : WorkplaceSearchList(
                          places: placeNotifier.places,
                          searchQuery: searchQuery,
                          onPlaceTap: _onPlaceSelected,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
