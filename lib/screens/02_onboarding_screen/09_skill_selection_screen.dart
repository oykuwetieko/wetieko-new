import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';
import 'package:Wetieko/screens/02_onboarding_screen/10_experience_selection_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

// ✅ Yeni importlar
import 'package:Wetieko/data/repositories/sectors_professions_skills_repository.dart';
import 'package:Wetieko/models/sectors_professions_skills_model.dart';

class SkillSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const SkillSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  final _repository = SectorsProfessionsSkillsRepository();
  final Set<String> _selectedSkills = {};
  List<SectorData> _allSectors = [];
  bool _isLoading = true;
  bool _initialized = false;
  bool _loaded = false; // 👈 tekrar yüklenmeyi engeller

  /// ✅ initState yerine didChangeDependencies kullanıyoruz
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadData();
      _loaded = true;
    }
  }

  Future<void> _loadData() async {
    final langCode = Localizations.localeOf(context).languageCode; // artık güvenli
    final sectors = await _repository.loadAll(langCode);
    if (!mounted) return;
    setState(() {
      _allSectors = sectors;
      _isLoading = false;
    });
  }

  void _initializeDefaultSkill(
    List<String> selectedSectors,
    List<String> selectedPositions,
  ) {
    if (_initialized || selectedSectors.isEmpty) return;

    for (final sectorName in selectedSectors) {
      final sector = _allSectors.firstWhere(
        (s) => s.name == sectorName,
        orElse: () => SectorData(id: '', name: '', professions: []),
      );
      if (sector.professions.isEmpty) continue;

      for (final pos in selectedPositions) {
        final profession = sector.professions.firstWhere(
          (p) => p.name == pos,
          orElse: () => Profession(name: '', skills: []),
        );
        if (profession.skills.isNotEmpty) {
          _selectedSkills.add(profession.skills.first.name);
          _initialized = true;
          return;
        }
      }
    }
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        if (_selectedSkills.length > 1) {
          _selectedSkills.remove(skill);
        }
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _handleNext() {
    context.read<UserStateNotifier>().setSkills(_selectedSkills.toList());

    if (widget.fromProfileEdit) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExperienceSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSectors = context.watch<UserStateNotifier>().state.sectors;
    final selectedPositions = context.watch<UserStateNotifier>().state.positions;
    final localizations = AppLocalizations.of(context)!;

    if (!_initialized && !_isLoading) {
      _initializeDefaultSkill(selectedSectors, selectedPositions);
    }

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
              currentStep: 6,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: _selectedSkills.isNotEmpty ? _handleNext : null,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingText(
                            title: localizations.whatCanYouDo,
                            subtitle: localizations.skillInfo,
                            align: TextAlign.left,
                          ),
                          const SizedBox(height: 16),

                          for (final sectorName in selectedSectors) ...[
                            Text(
                              sectorName,
                              style: AppTextStyles.onboardingTitle.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 8),

                            for (final sector in _allSectors.where((s) => s.name == sectorName)) ...[
                              for (final positionName in selectedPositions) ...[
                                for (final profession in sector.professions.where((p) => p.name == positionName)) ...[
                                  Text(
                                    positionName,
                                    style: AppTextStyles.onboardingTitle.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  for (final skill in profession.skills)
                                    _buildSkillItem(skill.name),
                                  const SizedBox(height: 16),
                                ],
                              ],
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

  Widget _buildSkillItem(String skill) {
    final isSelected = _selectedSkills.contains(skill);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _toggleSkill(skill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorder),
            boxShadow: isSelected
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  skill,
                  style: AppTextStyles.buttonText.copyWith(
                    color: isSelected
                        ? AppColors.onboardingButtonText
                        : AppColors.onboardingTitle,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.onboardingButtonText),
            ],
          ),
        ),
      ),
    );
  }
}
