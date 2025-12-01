class EventFilterBirlikteCalisRequestDto {
  final String? date;
  final List<String>? cities;
  final int? age;
  final List<String>? gender;
  final List<String>? industry;
  final List<String>? careerPosition;
  final List<String>? careerStage;

  EventFilterBirlikteCalisRequestDto({
    this.date,
    this.cities,
    this.age,
    this.gender,
    this.industry,
    this.careerPosition,
    this.careerStage,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "cities": cities,
      "age": age,
      "gender": gender,
      "industry": industry,
      "careerPosition": careerPosition,
      "careerStage": careerStage,
    };
  }
}
