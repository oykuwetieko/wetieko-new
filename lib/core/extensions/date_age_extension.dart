extension AgeExtension on DateTime {
  int calculateAge() {
    final today = DateTime.now();

    int age = today.year - year;

    // Ay ve gün kontrolü (doğum günü daha gelmediyse)
    if (today.month < month ||
        (today.month == month && today.day < day)) {
      age--;
    }

    return age;
  }
}
