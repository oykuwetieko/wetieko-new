import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:Wetieko/models/sectors_professions_skills_model.dart';

class SectorsProfessionsSkillsRepository {
  Future<List<SectorData>> loadAll(String langCode) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/sectors_professions_skills.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // "Sectors" anahtarını veya doğrudan üst düzey sektörleri al
      final sectorsRaw = jsonData['Sectors'] ?? jsonData['sectors'] ?? jsonData;

      final Map<String, dynamic> sectorsMap =
          Map<String, dynamic>.from(sectorsRaw);

      final List<SectorData> sectors = [];

      for (final entry in sectorsMap.entries) {
        final parsed = _parseSector(entry.key, entry.value, langCode);
        if (parsed != null) sectors.add(parsed);
      }

      print("✅ Yüklenen sektör sayısı: ${sectors.length}");
      return sectors;
    } catch (e) {
      print('❌ JSON yüklenirken hata: $e');
      return [];
    }
  }

  SectorData? _parseSector(String id, dynamic value, String langCode) {
    try {
      if (value is! Map) return null;
      final localizedData = value[langCode] ?? value['en'] ?? value['tr'];
      if (localizedData == null) return null;

      final name = localizedData['sektor'] ?? localizedData['sector'] ?? id;
      final professionsList =
          localizedData['meslekler'] ?? localizedData['professions'] ?? [];

      final professions = (professionsList as List)
          .map((p) => Profession.fromJson(
                Map<String, dynamic>.from(p),
                langCode,
              ))
          .toList();

      return SectorData(id: id, name: name, professions: professions);
    } catch (e) {
      print('⚠️ $id sektörü parse edilemedi: $e');
      return null;
    }
  }

  Future<List<Profession>> getProfessionsBySectorId(
      String sectorId, String langCode) async {
    final allSectors = await loadAll(langCode);
    final sector = allSectors.firstWhere(
      (s) => s.id == sectorId,
      orElse: () => SectorData(id: '', name: '', professions: []),
    );
    return sector.professions;
  }

  Future<List<Skill>> getSkillsForProfession(
      String sectorId, String professionName, String langCode) async {
    final professions = await getProfessionsBySectorId(sectorId, langCode);
    final profession = professions.firstWhere(
      (p) => p.name == professionName,
      orElse: () => Profession(name: '', skills: []),
    );
    return profession.skills;
  }
}
