class FilterBirlikteCalisDto {
  final DateTime? date;           
  final List<String>? cities;     
  final List<String>? industry;   
  final List<String>? careerPosition; 
  final List<String>? careerStage;   
  final List<String>? gender;       
  final int? age;                 

  FilterBirlikteCalisDto({
    this.date,
    this.cities,
    this.industry,
    this.careerPosition,
    this.careerStage,
    this.gender,
    this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      if (date != null)
        'date': DateTime.utc(date!.year, date!.month, date!.day).toIso8601String(),
      if (cities != null && cities!.isNotEmpty) 'cities': cities,
      if (industry != null && industry!.isNotEmpty) 'industry': industry,
      if (careerPosition != null && careerPosition!.isNotEmpty) 'careerPosition': careerPosition,
      if (careerStage != null && careerStage!.isNotEmpty) 'careerStage': careerStage,
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
      if (age != null) 'age': age,
    };
  }
}
