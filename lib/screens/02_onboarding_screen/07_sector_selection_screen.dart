import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';
import 'package:Wetieko/screens/02_onboarding_screen/08_position_selection_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

// ✅ JSON tabanlı model & repo importları
import 'package:Wetieko/data/repositories/sectors_professions_skills_repository.dart';
import 'package:Wetieko/models/sectors_professions_skills_model.dart';

class SectorSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const SectorSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<SectorSelectionScreen> createState() => _SectorSelectionScreenState();
}

class _SectorSelectionScreenState extends State<SectorSelectionScreen> {
  final _repository = SectorsProfessionsSkillsRepository();

  List<SectorData> _sectors = [];
  final Set<String> _selectedSectors = {};
  bool _isLoading = true;
  bool _loaded = false; // tekrar yüklenmesin diye kontrol

  /// ✅ Artık burada değil: initState yerine didChangeDependencies kullanıyoruz.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loadSectors();
      _loaded = true;
    }
  }

  Future<void> _loadSectors() async {
    final langCode = Localizations.localeOf(context).languageCode; // artık güvenli
    final sectors = await _repository.loadAll(langCode);
    if (!mounted) return;
    setState(() {
      _sectors = sectors;
      if (_sectors.isNotEmpty) {
        _selectedSectors.add(_sectors.first.name);
      }
      _isLoading = false;
    });
  }

  void _toggleSector(String sector) {
    setState(() {
      if (_selectedSectors.contains(sector)) {
        if (_selectedSectors.length > 1) {
          _selectedSectors.remove(sector);
        }
      } else {
        if (_selectedSectors.length < 3) {
          _selectedSectors.add(sector);
        }
      }
    });
  }

  void _handleNext() {
    context.read<UserStateNotifier>().setSectors(_selectedSectors.toList());

    if (widget.fromProfileEdit) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PositionSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              currentStep: 4,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: _selectedSectors.isNotEmpty ? _handleNext : null,
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
                            title: localizations.whichSector,
                            subtitle: localizations.sectorInfo,
                            align: TextAlign.left,
                          ),
                          const SizedBox(height: 16),
                          for (final sector in _sectors)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _toggleSector(sector.name),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedSectors.contains(sector.name)
                                        ? AppColors.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.textFieldBorder,
                                    ),
                                    boxShadow:
                                        _selectedSectors.contains(sector.name)
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
                                          sector.name,
                                          style: AppTextStyles.buttonText.copyWith(
                                            color: _selectedSectors.contains(sector.name)
                                                ? AppColors.onboardingButtonText
                                                : AppColors.onboardingTitle,
                                          ),
                                        ),
                                      ),
                                      if (_selectedSectors.contains(sector.name))
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.onboardingButtonText,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
