// lib/extensions/place_address_extension.dart

extension PlaceAddressExtension on String {
  String get formattedShortAddress {
    if (isEmpty) return 'Adres bilinmiyor';

    final parts = split(RegExp(r'[,\n]'));
    final lastPart = parts.lastWhere((p) => p.contains('/'), orElse: () => '');
    if (lastPart.contains('/')) {
      final subParts = lastPart.split('/');
      final district = subParts[0].replaceAll(RegExp(r'[0-9]'), '').trim();
      final city = subParts[1].split(' ').first.trim();
      return '${district.isNotEmpty ? district : 'İlçe'}, $city';
    }

    return 'Adres bilinmiyor';
  }
}
