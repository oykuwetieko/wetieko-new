class Skill {
  final String name;
  Skill({required this.name});

  factory Skill.fromJson(dynamic json) {
    return Skill(name: json.toString());
  }
}

class Profession {
  final String name;
  final List<Skill> skills;

  Profession({required this.name, required this.skills});

  factory Profession.fromJson(Map<String, dynamic> json, String langCode) {
    final nameKey = langCode == 'tr' ? 'meslek' : 'profession';
    final skillsKey = langCode == 'tr' ? 'yetenekler' : 'skills';

    final name = json[nameKey] ?? '';
    final skills = (json[skillsKey] as List? ?? [])
        .map((e) => Skill.fromJson(e))
        .toList();

    return Profession(name: name, skills: skills);
  }
}

class SectorData {
  final String id;
  final String name;
  final List<Profession> professions;

  SectorData({
    required this.id,
    required this.name,
    required this.professions,
  });
}
