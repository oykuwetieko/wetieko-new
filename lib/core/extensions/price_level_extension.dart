extension PriceLevelExtension on int? {
  int get normalized => this ?? 2;

  String get toPriceLabel {
    if (normalized == 0) return 'Ücretsiz';
    return '₺' * normalized.clamp(1, 5);
  }
}
