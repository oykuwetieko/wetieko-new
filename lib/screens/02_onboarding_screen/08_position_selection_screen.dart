import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';
import 'package:Wetieko/screens/02_onboarding_screen/09_skill_selection_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

// ✅ JSON tabanlı veri yapısı importları
import 'package:Wetieko/data/repositories/sectors_professions_skills_repository.dart';
import 'package:Wetieko/models/sectors_professions_skills_model.dart';

class PositionSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const PositionSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<PositionSelectionScreen> createState() => _PositionSelectionScreenState();
}

class _PositionSelectionScreenState extends State<PositionSelectionScreen> {
  final _repository = SectorsProfessionsSkillsRepository();
  final Set<String> _selectedPositions = {};
  List<SectorData> _allSectors = [];
  bool _isLoading = true;
  bool _loaded = false; // tekrar yüklenmeyi önlemek için

  /// ✅ Artık initState yerine didChangeDependencies kullanıyoruz.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadPositions();
      _loaded = true;
    }
  }

  Future<void> _loadPositions() async {
    final langCode = Localizations.localeOf(context).languageCode;
    final sectors = await _repository.loadAll(langCode);
    if (!mounted) return;
    setState(() {
      _allSectors = sectors;
      _isLoading = false;
    });
  }

  void _togglePosition(String position) {
    setState(() {
      if (_selectedPositions.contains(position)) {
        if (_selectedPositions.length > 1) {
          _selectedPositions.remove(position);
        }
      } else {
        if (_selectedPositions.length < 5) {
          _selectedPositions.add(position);
        }
      }
    });
  }

  void _handleNext() {
    context.read<UserStateNotifier>().setPositions(_selectedPositions.toList());

    if (widget.fromProfileEdit) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SkillSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSectors = context.watch<UserStateNotifier>().state.sectors;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: widget.fromProfileEdit
          ? AppBar(
              backgroundColor: AppColors.onboardingBackground,
              elevation: 0,
              automaticallyImplyLeading: false,
            )
          : const CustomAppBar(
              totalSteps: 10,
              currentStep: 5,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: _selectedPositions.isNotEmpty ? _handleNext : null,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingText(
                            title: localizations.whichPosition,
                            subtitle: localizations.positionInfo,
                            align: TextAlign.left,
                          ),
                          const SizedBox(height: 16),
                          for (final sectorName in selectedSectors) ...[
                            Text(
                              sectorName,
                              style: AppTextStyles.onboardingTitle
                                  .copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 8),

                            // 🔹 JSON'dan o sektörün profesyonlarını bul
                            for (final sector in _allSectors
                                .where((s) => s.name == sectorName)) ...[
                              for (final profession in sector.professions)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GestureDetector(
                                    onTap: () =>
                                        _togglePosition(profession.name),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: _selectedPositions
                                                .contains(profession.name)
                                            ? AppColors.primary
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.textFieldBorder),
                                        boxShadow: _selectedPositions
                                                .contains(profession.name)
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              profession.name,
                                              style: AppTextStyles.buttonText
                                                  .copyWith(
                                                color: _selectedPositions
                                                        .contains(
                                                            profession.name)
                                                    ? AppColors
                                                        .onboardingButtonText
                                                    : AppColors
                                                        .onboardingTitle,
                                              ),
                                            ),
                                          ),
                                          if (_selectedPositions
                                              .contains(profession.name))
                                            const Icon(
                                              Icons.check_circle,
                                              color: AppColors
                                                  .onboardingButtonText,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
