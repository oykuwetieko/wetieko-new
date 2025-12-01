import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/widgets/discover/discover_filter/rating_selector.dart';
import 'package:Wetieko/widgets/discover/discover_filter/working_condition_stepper.dart';
import 'package:Wetieko/widgets/discover/discover_filter/filter_slider.dart';
import 'package:Wetieko/widgets/discover/discover_filter/filter_selector.dart';
import 'package:Wetieko/widgets/discover/discover_filter/switch_block.dart';
import 'package:Wetieko/widgets/discover/discover_filter/open_status_switcher.dart';
import 'package:Wetieko/widgets/create_option/date_picker_field.dart';
import 'package:Wetieko/widgets/common/modal_drag_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/data/constants/city_list.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/models/filter_event_dto.dart';
import 'package:Wetieko/models/filter_birlikte_calis_dto.dart';
import 'package:Wetieko/data/repositories/sectors_professions_skills_repository.dart';
import 'package:Wetieko/models/sectors_professions_skills_model.dart';

class DiscoverFilter extends StatefulWidget {
  /// 'workplace' | 'togetherWork' | 'cowork' | 'activity'
  final String filterType;

  const DiscoverFilter({super.key, required this.filterType});

  @override
  State<DiscoverFilter> createState() => _DiscoverFilterState();
}

class _DiscoverFilterState extends State<DiscoverFilter> {
  final TextEditingController dateController = TextEditingController();

  final Set<int> selectedCityIndices = {};
  final Set<int> selectedFeatureIndices = {}; 
  final Set<int> selectedSectorIndices = {};
  final Set<int> selectedExperienceIndices = {};
  final _sectorRepo = SectorsProfessionsSkillsRepository();
  List<SectorData> _sectors = [];
  int? selectedGenderIndex;

  // Workplace switches (hepsi OFF başlar)
  bool swOpenNow = false;              // Açık mekânlar
  bool swPrice = false;                // Fiyat
  bool swRatings = false;              // Puan
  bool swPlaceFeatures = false;        // Mekân özellikleri
  bool swWorkingConditions = false;    // Çalışma koşulları

  // TogetherWork switches
  bool swDateTW = false;
  bool swCityTW = false;
  bool swSectorTW = false;
  bool swExperienceTW = false;
  bool swGenderTW = false;
  bool swAgeTW = false;

  // Activity/Cowork switches
  bool swDateAC = false;
  bool swCityAC = false;
  bool swEventFeaturesAC = false; // sadece activity’de görünür
  bool swParticipantAC = false;

  // Değerler
  double price = 3;
  double distance = 5; // şu an kullanılmıyor ama bırakıyorum

  /// Çoklu rating seçimi 1..5
  final Set<int> selectedRatings = {4, 5};

  double selectedAge = 25;
  double participantCount = 5;

  DateTime? _selectedDate; // seçilen tarih (sadece gün bazlı)

  /// Çalışma koşulları (kontrollü)
  Map<String, int> workingConditions = {
    'wifi': 4,
    'socket': 4,
    'silence': 4,
    'workDesk': 4,
    'lighting': 4,
    'ventilation': 4,
  };

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sectors.isEmpty) {
      final langCode = Localizations.localeOf(context).languageCode;
      _sectorRepo.loadAll(langCode).then((data) {
        setState(() => _sectors = data);
      });
    }
  }


  // Sadece tarih kısmını (00:00) koruyan "bugün"
  DateTime _todayDateOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _setDateText(DateTime picked) {
    _selectedDate = DateTime(picked.year, picked.month, picked.day);
    final formatted = DateFormat("d MMMM y", "tr_TR").format(_selectedDate!);
    setState(() => dateController.text = formatted);
  }

  void _ensureTodayInFieldIfEmpty() {
    if (_selectedDate == null) {
      final today = _todayDateOnly();
      _selectedDate = today;
      dateController.text = DateFormat("d MMMM y", "tr_TR").format(today);
    }
  }

  void clearAll() {
    setState(() {
      // tüm switch’ler OFF
      swOpenNow = false;
      swPrice = false;
      swRatings = false;
      swPlaceFeatures = false;
      swWorkingConditions = false;

      swDateTW = false;
      swCityTW = false;
      swSectorTW = false;
      swExperienceTW = false;
      swGenderTW = false;
      swAgeTW = false;

      swDateAC = false;
      swCityAC = false;
      swEventFeaturesAC = false;
      swParticipantAC = false;

      price = 3;
      distance = 5;

      selectedRatings
        ..clear()
        ..addAll({4, 5});

      selectedAge = 25;
      participantCount = 5;
      _selectedDate = null;
      dateController.clear();

      selectedFeatureIndices.clear();
      selectedCityIndices.clear();
      selectedSectorIndices.clear();
      selectedExperienceIndices.clear();
      selectedGenderIndex = null;

      workingConditions = {
        'wifi': 4,
        'socket': 4,
        'silence': 4,
        'workDesk': 4,
        'lighting': 4,
        'ventilation': 4,
      };
    });
  }

  /// Seçili şehirleri isim listesine çevir
  List<String> _getSelectedCitiesList() {
    return selectedCityIndices
        .where((i) => i >= 0 && i < cityList.length)
        .map((i) => cityList[i])
        .toList();
  }


  /// ✅ JSON'dan dinamik sektör isimlerini getir
  List<String> _sectorOptions() {
    return _sectors.map((s) => s.name).toList();
  }

  // Deneyim seçenekleri (FilterSelector ile aynı sırada/aynı metinler)
  List<String> _experienceOptions(AppLocalizations loc) => [
        loc.teamLead,
        loc.junior,
        loc.founder,
        loc.midLevel,
        loc.senior,
        loc.manager,
      ];

  // Cinsiyet seçenekleri (FilterSelector ile aynı sırada/aynı metinler)
  List<String> _genderOptions(AppLocalizations loc) =>
      [loc.female, loc.male, loc.preferNotToSay];

  List<String> _getSelectedFromIndices(Set<int> indices, List<String> source) {
    return indices
        .where((i) => i >= 0 && i < source.length)
        .map((i) => source[i])
        .toList();
  }

  List<String> _getSelectedSectors() {
    return _getSelectedFromIndices(selectedSectorIndices, _sectorOptions());
  }

  List<String> _getSelectedExperiences(AppLocalizations loc) {
    return _getSelectedFromIndices(selectedExperienceIndices, _experienceOptions(loc));
  }

  List<String> _getSelectedGenders(AppLocalizations loc) {
  if (selectedGenderIndex == null) return [];
  final opts = _genderOptions(loc);
  final idx = selectedGenderIndex!;
  if (idx < 0 || idx >= opts.length) return [];
  final value = opts[idx];
  return [value]; 
}


  /// Yaş slider’ını en yakın kovaya (18, 23, 28, 34, 39, 44, 50) yuvarla
  int _bucketizeAge(double v) {
    const buckets = [18, 23, 28, 34, 39, 44, 50];
    int best = buckets.first;
    double bestDiff = (v - best).abs();
    for (final b in buckets) {
      final d = (v - b).abs();
      if (d < bestDiff) {
        best = b;
        bestDiff = d;
      }
    }
    return best;
  }

  /// Katılımcı slider değerini 0/5/10/15/20 kovalarına yuvarla
  int _bucketizeParticipant(double v) {
    final rounded = (v / 5).round() * 5;
    if (rounded < 0) return 0;
    if (rounded > 20) return 20;
    return rounded;
  }

  void _maybeAdd(Map<String, dynamic> map, String key, dynamic value, bool cond) {
    if (cond) map[key] = value;
  }

  // Switch açıkken tarih değerini çözen yardımcı
  DateTime? _resolveDate(bool enabled) => enabled ? (_selectedDate ?? _todayDateOnly()) : null;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final todayFormatted = DateFormat("d MMMM y", "tr_TR").format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const ModalDragHandle(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.filters,
                    style: AppTextStyles.textFieldText.copyWith(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: clearAll,
                  child: Text(local.clear,
                      style: AppTextStyles.textFieldText.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      )),
                )
              ],
            ),
        
            const SizedBox(height: 30),

            // ========== WORKPLACE ==========
            if (widget.filterType == 'workplace') ...[
              // Açık mekânlar
              OpenStatusSwitch(
                isOpen: swOpenNow,
                onChanged: (v) => setState(() => swOpenNow = v),
              ),
              const SizedBox(height: 24),

              // Fiyat
              SwitchBlock(
                enabled: swPrice,
                onToggle: (v) => setState(() => swPrice = v),
                child: FilterSlider(
                  type: 'price',
                  value: price,
                  onChanged: (v) => setState(() => price = v),
                ),
              ),
              const SizedBox(height: 24),

              // Puan
              SwitchBlock(
                enabled: swRatings,
                onToggle: (v) => setState(() => swRatings = v),
                child: RatingSelector(
                  selectedRatings: selectedRatings,
                  onToggle: (value, wasSelected) {
                    setState(() {
                      if (wasSelected) {
                        selectedRatings.remove(value);
                      } else {
                        selectedRatings.add(value);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Mekân özellikleri
              SwitchBlock(
                enabled: swPlaceFeatures,
                onToggle: (v) => setState(() => swPlaceFeatures = v),
                child: FilterSelector(
                  type: 'feature',
                  selectedIndices: selectedFeatureIndices,
                  onToggle: (index, isSelected) {
                    setState(() {
                      isSelected
                          ? selectedFeatureIndices.remove(index)
                          : selectedFeatureIndices.add(index);
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Çalışma koşulları
              SwitchBlock(
                enabled: swWorkingConditions,
                onToggle: (v) => setState(() => swWorkingConditions = v),
                child: WorkingConditionSelector(
                  values: workingConditions,
                  onChanged: (key, newValue) {
                    setState(() {
                      workingConditions[key] = newValue.clamp(1, 5);
                    });
                  },
                ),
              ),
            ],

            // ========== TOGETHER WORK ==========
            if (widget.filterType == 'togetherWork') ...[
  // Sektör
SwitchBlock(
  enabled: swSectorTW,
  onToggle: (v) => setState(() => swSectorTW = v),
  child: FilterSelector(
    type: 'sector',
    options: _sectorOptions(), // ✅ JSON'dan gelen sektör isimleri
    selectedIndices: selectedSectorIndices,
    onToggle: (index, isSelected) {
      setState(() {
        isSelected
            ? selectedSectorIndices.remove(index)
            : selectedSectorIndices.add(index);
      });
    },
  ),
),
  const SizedBox(height: 24),

  // Şehir
  SwitchBlock(
    enabled: swCityTW,
    onToggle: (v) => setState(() => swCityTW = v),
    child: FilterSelector(
      type: 'city',
      selectedIndices: selectedCityIndices,
      onToggle: (index, isSelected) {
        setState(() {
          isSelected
              ? selectedCityIndices.remove(index)
              : selectedCityIndices.add(index);
        });
      },
    ),
  ),
  const SizedBox(height: 24),

              // Sektör
SwitchBlock(
  enabled: swSectorTW,
  onToggle: (v) => setState(() => swSectorTW = v),
  child: FilterSelector(
    type: 'sector',
    options: _sectorOptions(), // ✅ JSON'dan gelen sektör isimleri
    selectedIndices: selectedSectorIndices,
    onToggle: (index, isSelected) {
      setState(() {
        isSelected
            ? selectedSectorIndices.remove(index)
            : selectedSectorIndices.add(index);
      });
    },
  ),
),
      
              const SizedBox(height: 24),

              // Deneyim
              SwitchBlock(
                enabled: swExperienceTW,
                onToggle: (v) => setState(() => swExperienceTW = v),
                child: FilterSelector(
                  type: 'experience',
                  selectedIndices: selectedExperienceIndices,
                  onToggle: (index, isSelected) {
                    setState(() {
                      isSelected
                          ? selectedExperienceIndices.remove(index)
                          : selectedExperienceIndices.add(index);
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Cinsiyet
              SwitchBlock(
                enabled: swGenderTW,
                onToggle: (v) => setState(() => swGenderTW = v),
                child: FilterSelector(
                  type: 'gender',
                  selectedIndex: selectedGenderIndex,
                  onSelect: (index) =>
                      setState(() => selectedGenderIndex = index),
                ),
              ),
              const SizedBox(height: 24),

              // Yaş
              SwitchBlock(
                enabled: swAgeTW,
                onToggle: (v) => setState(() => swAgeTW = v),
                child: FilterSlider(
                  type: 'age',
                  value: selectedAge,
                  onChanged: (val) => setState(() => selectedAge = val),
                ),
              ),
            ],

            // ========== ACTIVITY & COWORK ==========
            if (widget.filterType == 'activity' || widget.filterType == 'cowork') ...[
              // Tarih
              SwitchBlock(
                enabled: swDateAC,
                onToggle: (v) => setState(() {
                  swDateAC = v;
                  if (v) _ensureTodayInFieldIfEmpty(); // YENİ
                }),
                child: Stack(
                  children: [
                    CustomTextField(
                      hintText: todayFormatted,
                      icon: Icons.calendar_today,
                      controller: dateController,
                      borderColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      labelColor: AppColors.neutralDark,
                      textColor: AppColors.neutralDark,
                      hintTextColor: AppColors.neutralText,
                    ),
                    DatePickerField(onDateSelected: _setDateText),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Şehir
              SwitchBlock(
                enabled: swCityAC,
                onToggle: (v) => setState(() => swCityAC = v),
                child: FilterSelector(
                  type: 'city',
                  selectedIndices: selectedCityIndices,
                  onToggle: (index, isSelected) {
                    setState(() {
                      isSelected
                          ? selectedCityIndices.remove(index)
                          : selectedCityIndices.add(index);
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Etkinlik özellikleri (sadece activity)
              if (widget.filterType == 'activity') ...[
                SwitchBlock(
                  enabled: swEventFeaturesAC,
                  onToggle: (v) => setState(() => swEventFeaturesAC = v),
                  child: FilterSelector(
                    type: 'eventFeature',
                    selectedIndices: selectedFeatureIndices,
                    onToggle: (index, isSelected) {
                      setState(() {
                        isSelected
                            ? selectedFeatureIndices.remove(index)
                            : selectedFeatureIndices.add(index);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Katılımcı
              SwitchBlock(
                enabled: swParticipantAC,
                onToggle: (v) => setState(() => swParticipantAC = v),
                child: FilterSlider(
                  type: 'participant',
                  value: participantCount,
                  onChanged: (v) => setState(() => participantCount = v),
                ),
              ),
            ],

            const SizedBox(height: 30),
        CustomButton(
  text: local.showResults,
  onPressed: () async {
    final eventState =
        Provider.of<EventStateNotifier?>(context, listen: false);

    final int pcBucket = _bucketizeParticipant(participantCount);
    final List<String> selectedCities = _getSelectedCitiesList();

    if (widget.filterType == 'workplace') {
      final placeState =
          Provider.of<PlaceStateNotifier?>(context, listen: false);
      final currentCity = placeState?.lastFetchedCity ?? "İstanbul";

      // Place feature anahtarları (backend ile eşleşir)
      final featureKeys = [
        'hasMeetingArea',
        'hasOutdoorArea',
        'isPetFriendly',
        'hasParking',
        'hasView',
      ];
      final selectedFeaturesMap = {
        for (var i = 0; i < featureKeys.length; i++)
          featureKeys[i]: selectedFeatureIndices.contains(i)
      };

      // Çalışma koşulları backend mapping
      final wcBackendMap = {
        'wifi': 'avgWifi',
        'socket': 'avgSocket',
        'silence': 'avgNoiseLevel',
        'workDesk': 'avgWorkDesk',
        'lighting': 'avgLighting',
        'ventilation': 'avgVentilation',
      };
      final wcMapped = {
        for (var entry in workingConditions.entries)
          wcBackendMap[entry.key]!: entry.value
      };

      final filters = <String, dynamic>{};
      _maybeAdd(filters, 'city', currentCity, true); // city her zaman gider
      filters['isOpenNow'] = swOpenNow; // ✅ her zaman backend'e gönderiliyor
      _maybeAdd(filters, 'priceLevel', price.toInt(), swPrice);
      _maybeAdd(
        filters,
        'ratings',
        selectedRatings.toList(),
        swRatings && selectedRatings.isNotEmpty,
      );
      if (swPlaceFeatures) {
        filters.addAll(selectedFeaturesMap);
      }
      if (swWorkingConditions) {
        filters.addAll(wcMapped);
      }

      await placeState?.loadFilteredPlaces(filters);
    } else if (widget.filterType == 'cowork') {
      final dto = FilterEventDto(
        cities: swCityAC ? selectedCities : null,
        date: _resolveDate(swDateAC), // ✅ Switch açıksa bugün/tarih
        participantCount: swParticipantAC ? pcBucket : null,
      );
      await eventState?.fetchFilteredEvents(dto);
    } else if (widget.filterType == 'activity') {
      // Activity: event feature’ları backend’e isim listesi olarak gönder (OR)
      const featureKeysForEvent = [
        'hasSpeaker',
        'hasWorkshop',
        'hasCertificate',
        'isFree',
        'hasTreat',
        'hasRaffle',
        'hasGift',
        'isOutdoor',
        'hasSeatTable',
        'hasPhotoVideo',
      ];
      final selectedFeatureNames = <String>[];
      for (var i = 0; i < featureKeysForEvent.length; i++) {
        if (selectedFeatureIndices.contains(i)) {
          selectedFeatureNames.add(featureKeysForEvent[i]);
        }
      }

      final dto = FilterEventDto(
        cities: swCityAC ? selectedCities : null,
        date: _resolveDate(swDateAC), // ✅ Switch açıksa bugün/tarih
        participantCount: swParticipantAC ? pcBucket : null,
        eventFeatures: (swEventFeaturesAC && selectedFeatureNames.isNotEmpty)
            ? selectedFeatureNames
            : null,
      );
      await eventState?.fetchFilteredEvents(dto);
    } else if (widget.filterType == 'togetherWork') {
      // Birlikte Çalış özel DTO’su ile çağrı (backend: /events/filter-birlikte-calis)
      final List<String>? cities = swCityTW ? selectedCities : null;
     final List<String>? industries =
    swSectorTW ? _getSelectedSectors() : null;
      final List<String>? positions =
          swExperienceTW ? _getSelectedExperiences(local) : null;
      final List<String>? genders =
          swGenderTW ? _getSelectedGenders(local) : null;
      final int? ageVal = swAgeTW ? _bucketizeAge(selectedAge) : null;

      final dto = FilterBirlikteCalisDto(
        date: _resolveDate(swDateTW),
        cities: (cities == null || cities.isEmpty) ? null : cities,
        industry:
            (industries == null || industries.isEmpty) ? null : industries,
        careerPosition:
            (positions == null || positions.isEmpty) ? null : positions,
        careerStage: null,
        gender: (genders == null || genders.isEmpty) ? null : genders,
        age: ageVal,
      );

      await eventState?.fetchFilteredBirlikteCalis(dto);
    }

    if (mounted) Navigator.pop(context);
  },
  backgroundColor: AppColors.primary,
  textColor: Colors.white,
  icon: Icons.filter_alt,
),

          ],
        ),
      ),
    );
  }
}
