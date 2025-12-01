import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/models/create_event_dto.dart';
import 'package:Wetieko/screens/03_discover_screen/06_discover_search_screen.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/widgets/create_option/create_option_tile.dart';
import 'package:Wetieko/widgets/create_option/date_picker_field.dart';
import 'package:Wetieko/widgets/create_option/time_picker_field.dart';
import 'package:Wetieko/widgets/create_option/event_features_grid.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/04_create_options_screen/validators/event_form_validator.dart';
import 'package:Wetieko/data/constants/creation_option_type.dart';
import 'package:Wetieko/models/update_event_dto.dart';
import 'package:Wetieko/widgets/create_option/create_option_step_bar.dart';

class OptionActivityScreen extends StatefulWidget {
  final CreateOptionType type;
  final EventModel? existingEvent;
  final bool isEditing;

  const OptionActivityScreen({
    super.key,
    required this.type,
    this.existingEvent,
    this.isEditing = false,
  });

  @override
  State<OptionActivityScreen> createState() => _OptionActivityScreenState();
}

class _OptionActivityScreenState extends State<OptionActivityScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final participantController = TextEditingController();
  final dateController = TextEditingController();

  late String selectedDateIso;
  int selectedDayIndex = 0;
  int? selectedParticipant;
  String? selectedPlaceId;
  bool _isInitialized = false;
  Set<String> selectedFeatures = {};

  @override
  void initState() {
    super.initState();

    bool titleAlertShown = false;
    bool descAlertShown = false;

    titleController.addListener(() {
      if (titleController.text.length > 25) {
        if (!titleAlertShown) {
          titleAlertShown = true;
          _showErrorAlert('invalidTitle');
        }
      } else {
        titleAlertShown = false;
      }
    });

    descriptionController.addListener(() {
      if (descriptionController.text.length > 300) {
        if (!descAlertShown) {
          descAlertShown = true;
          _showErrorAlert('invalidDescription');
        }
      } else {
        descAlertShown = false;
      }
    });

    if (widget.isEditing && widget.existingEvent != null) {
      final e = widget.existingEvent!;
      titleController.text = e.title;
      descriptionController.text = e.description;
      startTimeController.text = e.startTime;
      endTimeController.text = e.endTime;
      locationController.text = e.place.name ?? '';
      selectedPlaceId = e.place.id;
      selectedParticipant = e.maxParticipants;
      selectedFeatures = {
  if (e.hasSpeaker) 'hasSpeaker',
  if (e.hasWorkshop) 'hasWorkshop',
  if (e.hasCertificate) 'hasCertificate',
  if (e.isFree) 'isFree',
  if (e.hasTreat) 'hasTreat',
  if (e.hasRaffle) 'hasRaffle',
  if (e.hasGift) 'hasGift',
  if (e.isOutdoor) 'isOutdoor',
  if (e.hasSeatTable) 'hasSeatTable',
  if (e.hasPhotoVideo) 'hasPhotoVideo',
};

// Katılımcı sayısını kontrol et (5,10,15 dışındaysa text alanı dolu gelsin)
if (e.maxParticipants != null) {
  final mp = e.maxParticipants!;
  if ([5, 10, 15].contains(mp)) {
    selectedParticipant = mp;
  } else {
    selectedParticipant = null;
    participantController.text = mp.toString();
  }
}

_setDateText(DateTime.parse(e.date));
    }
  }

  void _showErrorAlert(String errorKey) {
    final loc = AppLocalizations.of(context)!;

    final errorMap = {
      'invalidTitle': {
        'title': loc.invalidTitle,
        'description': loc.invalidTitleDescription,
      },
      'invalidDescription': {
        'title': loc.invalidDescription,
        'description': loc.invalidDescriptionDetail,
      },
      'invalidLocation': {
        'title': loc.locationNotSelected,
        'description': loc.locationNotSelectedDescription,
      },
      'invalidParticipant': {
        'title': loc.participantMissing,
        'description': loc.participantMissingDescription,
      },
    };

    final error = errorMap[errorKey];
    if (error != null) {
      FocusScope.of(context).unfocus();
      CustomAlert.show(
        context,
        title: error['title']!,
        description: error['description']!,
        icon: Icons.error_outline_rounded,
        confirmText: loc.ok,
        onConfirm: () {},
      );
    }
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_isInitialized) {
    // yalnızca yeni oluşturma modunda (düzenleme değilse)
    if (!widget.isEditing) {
      final now = DateTime.now();
      _setDateText(now);
      startTimeController.text = TimeOfDay.fromDateTime(now).format(context);
      endTimeController.text =
          TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))).format(context);
    }

    _isInitialized = true;
  }
}


  void _setDateText(DateTime date) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMMM yyyy', 'tr_TR').format(date);
    final iso = DateFormat('yyyy-MM-dd').format(date);

    final difference = date.difference(DateTime(now.year, now.month, now.day)).inDays;

    setState(() {
      dateController.text = formattedDate;
      selectedDateIso = iso;
      selectedDayIndex = (difference >= 0 && difference <= 2) ? difference : -1;
    });
  }

  String getTitle(AppLocalizations loc) {
    switch (widget.type) {
      case CreateOptionType.collaborate:
        return loc.createCollaborate;
      case CreateOptionType.cowork:
        return loc.cowork;
      case CreateOptionType.activity:
        return loc.activities;
    }
  }

  ButtonStyle _minimalistButtonStyle({required bool isSelected}) {
    return OutlinedButton.styleFrom(
      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary.withOpacity(isSelected ? 0.7 : 0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    participantController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title = getTitle(loc);
    final selectedDayLabels = [loc.today, loc.tomorrow, loc.dayAfterTomorrow];

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: '$title ${loc.details}',
        showStepBar: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateOptionStepBar(totalSteps: 2, currentStep: 2),
              const SizedBox(height: 24),
              CreateOptionTile(
                type: widget.type,
                localizations: loc,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: '$title ${loc.title}',
                hintText: "$title'ine ${loc.shortName}",
                controller: titleController,
                borderColor: AppColors.primary,
                iconColor: AppColors.primary,
                labelColor: AppColors.neutralDark,
                textColor: AppColors.neutralDark,
                hintTextColor: AppColors.neutralText,
                uppercase: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: '$title ${loc.description}',
                hintText: loc.noteToParticipants,
                controller: descriptionController,
                borderColor: AppColors.primary,
                iconColor: AppColors.primary,
                labelColor: AppColors.neutralDark,
                textColor: AppColors.neutralDark,
                hintTextColor: AppColors.neutralText,
                isExpandable: true,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final capitalized = value[0].toUpperCase() + value.substring(1);
                    if (descriptionController.text != capitalized) {
                      final pos = descriptionController.selection;
                      descriptionController.value = TextEditingValue(
                        text: capitalized,
                        selection: pos,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
              Stack(
                children: [
                  CustomTextField(
                    label: '$title ${loc.date}',
                    hintText: '24 Mart 2025',
                    icon: Icons.calendar_today,
                    controller: dateController,
                    borderColor: AppColors.primary,
                    iconColor: AppColors.primary,
                    labelColor: AppColors.neutralDark,
                    textColor: AppColors.neutralDark,
                    hintTextColor: AppColors.neutralText,
                    readOnly: true,
                  ),
                  DatePickerField(onDateSelected: (picked) => _setDateText(picked)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(3, (index) {
                  final isSelected = selectedDayIndex == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedDayIndex = index;
                            final newDate = DateTime.now().add(Duration(days: index));
                            _setDateText(newDate);
                          });
                        },
                        style: _minimalistButtonStyle(isSelected: isSelected),
                        child: Text(selectedDayLabels[index]),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text(
                '$title ${loc.time}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.neutralDark,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CustomTextField(
                          hintText: '13:20',
                          controller: startTimeController,
                          icon: Icons.access_time,
                          borderColor: AppColors.primary,
                          iconColor: AppColors.primary,
                          textColor: AppColors.neutralDark,
                          hintTextColor: AppColors.neutralText,
                        ),
                        TimePickerField(onTimeSelected: (pickedTime) {
                          final formatted = pickedTime.format(context);
                          setState(() => startTimeController.text = formatted);
                        }),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, color: AppColors.primary),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomTextField(
                          hintText: '14:20',
                          controller: endTimeController,
                          icon: Icons.access_time,
                          borderColor: AppColors.primary,
                          iconColor: AppColors.primary,
                          textColor: AppColors.neutralDark,
                          hintTextColor: AppColors.neutralText,
                        ),
                        TimePickerField(onTimeSelected: (pickedTime) {
                          final formatted = pickedTime.format(context);
                          setState(() => endTimeController.text = formatted);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  final placeState = context.read<PlaceStateNotifier>();

                  final selectedPlace = await Navigator.push<Place>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscoverSearchScreen(
                        places: placeState.places,
                        showHeader: false,
                        onPlaceSelected: (place) {
                          Navigator.pop(context, place);
                        },
                      ),
                    ),
                  );

                  if (selectedPlace != null) {
                    setState(() {
                      locationController.text = selectedPlace.name ?? '';
                      selectedPlaceId = selectedPlace.id;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: '$title ${loc.where}',
                    hintText: loc.selectMeetingPlace,
                    icon: Icons.location_on,
                    controller: locationController,
                    borderColor: AppColors.primary,
                    iconColor: AppColors.primary,
                    labelColor: AppColors.neutralDark,
                    textColor: AppColors.neutralDark,
                    hintTextColor: AppColors.neutralText,
                    readOnly: true,
                  ),
                ),
              ),
              if (widget.type == CreateOptionType.activity) ...[
                const SizedBox(height: 24),
              EventFeaturesGrid(
  initialSelectedFeatures: selectedFeatures, // ✅ mevcut seçili özellikleri gönder
  onChanged: (features) {
    setState(() {
      selectedFeatures = features;
    });
  },
),

              ],
              const SizedBox(height: 24),
              if (widget.type == CreateOptionType.cowork ||
                  widget.type == CreateOptionType.activity) ...[
                Text(
                  loc.participantCount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.neutralDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [5, 10, 15].map((num) {
                    final isSelected = selectedParticipant == num;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: num == 5 ? 0 : 8),
                        child: OutlinedButton(
                          onPressed: () => setState(() => selectedParticipant = num),
                          style: _minimalistButtonStyle(isSelected: isSelected),
                          child: Text('$num'),
                        ),
                      ),
                    );
                  }).toList()
                    ..add(
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: OutlinedButton(
                            onPressed: () => setState(() => selectedParticipant = null),
                            style: _minimalistButtonStyle(
                                isSelected: selectedParticipant == null),
                            child: Text(loc.other),
                          ),
                        ),
                      ),
                    ),
                ),
                const SizedBox(height: 12),
                if (selectedParticipant == null)
                  CustomTextField(
                    hintText: loc.participantCount,
                    controller: participantController,
                    borderColor: AppColors.primary,
                    textColor: AppColors.neutralDark,
                    hintTextColor: AppColors.neutralText,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 45),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final loc = AppLocalizations.of(context)!;

              final eventType = widget.type == CreateOptionType.collaborate
                  ? EventType.BIRLIKTE_CALIS
                  : widget.type == CreateOptionType.cowork
                      ? EventType.COWORK
                      : EventType.ETKINLIK;

              final description = descriptionController.text.trim();
              if (description.length > 300) {
                _showErrorAlert('invalidDescription');
                return;
              }

              EventFormValidator.handleTitleInputLimit(titleController);
              EventFormValidator.handleDescriptionInputLimit(descriptionController);

              final validationError = EventFormValidator.getValidationError(
                type: eventType,
                title: titleController.text,
                description: descriptionController.text,
                locationText: locationController.text,
                placeId: selectedPlaceId,
                selectedParticipant: selectedParticipant,
                participantText: participantController.text,
              );

              if (validationError != null) {
                _showErrorAlert(validationError);
                return;
              }

              final startTime = TimeOfDay(
                hour: int.parse(startTimeController.text.split(':')[0]),
                minute: int.parse(startTimeController.text.split(':')[1]),
              );

              final endTime = TimeOfDay(
                hour: int.parse(endTimeController.text.split(':')[0]),
                minute: int.parse(endTimeController.text.split(':')[1]),
              );

              final now = DateTime.now();
              final startDateTime = DateTime(
                  now.year, now.month, now.day, startTime.hour, startTime.minute);
              final endDateTime = DateTime(
                  now.year, now.month, now.day, endTime.hour, endTime.minute);

              if (!endDateTime.isAfter(startDateTime)) {
                CustomAlert.show(
                  context,
                  title: loc.invalidTimeSelectionTitle,
                  description: loc.invalidTimeSelectionDescription,
                  icon: Icons.error_outline_rounded,
                  confirmText: loc.ok,
                  onConfirm: () {},
                );
                return;
              }

            final localDate =
    DateTime.parse(selectedDateIso).add(const Duration(hours: 3));
final isoUtcDate = localDate.toUtc().toIso8601String();

final dto = CreateEventDto(
  type: eventType,
  title: titleController.text.trim(),
  description: descriptionController.text.trim(),
  date: isoUtcDate,
  startTime: startTimeController.text,
  endTime: endTimeController.text,
  placeId: selectedPlaceId ?? '',
  maxParticipants: selectedParticipant ??
      int.tryParse(participantController.text),
  hasSpeaker: selectedFeatures.contains('hasSpeaker'),
  hasWorkshop: selectedFeatures.contains('hasWorkshop'),
  hasCertificate: selectedFeatures.contains('hasCertificate'),
  isFree: selectedFeatures.contains('isFree'),
  hasTreat: selectedFeatures.contains('hasTreat'),
  hasRaffle: selectedFeatures.contains('hasRaffle'),
  hasGift: selectedFeatures.contains('hasGift'),
  isOutdoor: selectedFeatures.contains('isOutdoor'),
  hasSeatTable: selectedFeatures.contains('hasSeatTable'),
  hasPhotoVideo: selectedFeatures.contains('hasPhotoVideo'),
);

try {
  final eventNotifier = context.read<EventStateNotifier>();
 if (widget.isEditing && widget.existingEvent != null) {
  final original = widget.existingEvent!;
final Map<String, dynamic> updateData = {};

// 🟢 1. Basit alanlar
if (titleController.text.trim() != original.title) {
  updateData['title'] = titleController.text.trim();
}
if (descriptionController.text.trim() != original.description) {
  updateData['description'] = descriptionController.text.trim();
}

// 🟢 2. Tarih karşılaştırması (format farkı hatasını önle)
final originalDateOnly = original.date.split('T').first;
final selectedDateOnly = selectedDateIso.split('T').first;
if (selectedDateOnly != originalDateOnly) {
  updateData['date'] = isoUtcDate;
}

// 🟢 3. Saat kontrolü
if (startTimeController.text.trim() != original.startTime.trim()) {
  updateData['startTime'] = startTimeController.text.trim();
}
if (endTimeController.text.trim() != original.endTime.trim()) {
  updateData['endTime'] = endTimeController.text.trim();
}

// 🟢 4. Mekan kontrolü (boş string gönderme!)
if (selectedPlaceId != null && selectedPlaceId!.isNotEmpty && selectedPlaceId != original.place.id) {
  updateData['placeId'] = selectedPlaceId!;
}

// 🟢 5. Katılımcı sayısı (hem preset hem manuel sayıyı kontrol et)
final newParticipantCount =
    selectedParticipant ?? int.tryParse(participantController.text);
if (newParticipantCount != original.maxParticipants) {
  updateData['maxParticipants'] = newParticipantCount;
}

// 🟢 6. Özellik farklarını kontrol et
final updatedFeatures = {
  'hasSpeaker': selectedFeatures.contains('hasSpeaker'),
  'hasWorkshop': selectedFeatures.contains('hasWorkshop'),
  'hasCertificate': selectedFeatures.contains('hasCertificate'),
  'isFree': selectedFeatures.contains('isFree'),
  'hasTreat': selectedFeatures.contains('hasTreat'),
  'hasRaffle': selectedFeatures.contains('hasRaffle'),
  'hasGift': selectedFeatures.contains('hasGift'),
  'isOutdoor': selectedFeatures.contains('isOutdoor'),
  'hasSeatTable': selectedFeatures.contains('hasSeatTable'),
  'hasPhotoVideo': selectedFeatures.contains('hasPhotoVideo'),
};

updatedFeatures.forEach((key, value) {
  dynamic originalValue;
  switch (key) {
    case 'hasSpeaker':
      originalValue = original.hasSpeaker;
      break;
    case 'hasWorkshop':
      originalValue = original.hasWorkshop;
      break;
    case 'hasCertificate':
      originalValue = original.hasCertificate;
      break;
    case 'isFree':
      originalValue = original.isFree;
      break;
    case 'hasTreat':
      originalValue = original.hasTreat;
      break;
    case 'hasRaffle':
      originalValue = original.hasRaffle;
      break;
    case 'hasGift':
      originalValue = original.hasGift;
      break;
    case 'isOutdoor':
      originalValue = original.isOutdoor;
      break;
    case 'hasSeatTable':
      originalValue = original.hasSeatTable;
      break;
    case 'hasPhotoVideo':
      originalValue = original.hasPhotoVideo;
      break;
  }

  if (originalValue != value) {
    updateData[key] = value;
  }
});


  final updateDto = UpdateEventDto.fromJson(updateData);
  await eventNotifier.updateEvent(widget.existingEvent!.id, updateDto);

  CustomAlert.show(
    context,
    title: loc.updateSuccessTitle,
    description: loc.updateSuccessDescription,
    icon: Icons.check_circle,
    confirmText: loc.ok,
    onConfirm: () {
      Navigator.pop(context);
    },
  );
}
 else {
    await eventNotifier.createEvent(dto);
    await eventNotifier.fetchCreatedEvents();

    CustomAlert.show(
      context,
      title: loc.postPublished,
      description: loc.thanksForJoining,
      icon: Icons.rocket_launch_rounded,
      confirmText: loc.ok,
      onConfirm: () {
        String mapEventTypeToCategoryKey(EventType type) {
          switch (type) {
            case EventType.ETKINLIK:
              return 'activities';
            case EventType.COWORK:
              return 'cowork';
            case EventType.BIRLIKTE_CALIS:
              return 'collaborateNow';
            default:
              return 'workplaces';
          }
        }

        final categoryKey = mapEventTypeToCategoryKey(eventType);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainNavigationWrapper(
              initialIndex: 0,
              initialDiscoverCategoryKey: categoryKey,
            ),
          ),
          (route) => false,
        );
      },
    );
  }
} catch (e) {
  // hata durumunda sessiz geçiliyor
}

            },
         icon: Icon(
  widget.isEditing
      ? Icons.save
      : (widget.type == CreateOptionType.collaborate
          ? Icons.people_alt
          : widget.type == CreateOptionType.cowork
              ? Icons.groups
              : Icons.diversity_3),
  size: 20,
  color: Colors.white,
),
label: Text(
  widget.isEditing ? loc.saveChanges : '$title ${loc.start}',
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.white,
  ),
),

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.fabBackground,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}
