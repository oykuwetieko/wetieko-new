import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

extension PlaceHoursExtension on List<String> {
  static final _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool get isOpenNow {
    final istanbul = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(istanbul);
    final today = _days[now.weekday - 1];

    final todayLine = firstWhere((e) => e.startsWith(today), orElse: () => '');
    if (todayLine.isEmpty || !todayLine.contains(': ')) return false;

    final times = todayLine.split(': ')[1].split('–');
    if (times.length != 2) return false;

    try {
      final openTime = _parseTimeInIstanbul(times[0].trim());
      final closeTime = _parseTimeInIstanbul(times[1].trim());

      return closeTime.isBefore(openTime)
          ? now.isAfter(openTime) || now.isBefore(closeTime)
          : now.isAfter(openTime) && now.isBefore(closeTime);
    } catch (e) {
    
      return false;
    }
  }

  String getTodayFormattedHours() {
    final istanbul = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(istanbul);
    final today = _days[now.weekday - 1];

    final todayLine = firstWhere((e) => e.startsWith(today), orElse: () => '');
    if (!todayLine.contains(': ')) return '';

    final times = todayLine.split(': ')[1].split('–');
    if (times.length != 2) return '';

    try {
      final open = _parseTimeInIstanbul(times[0].trim());
      final close = _parseTimeInIstanbul(times[1].trim());

      return '${_formatTime(open)} – ${_formatTime(close)}';
    } catch (e) {
   
      return '';
    }
  }

  String? getWeekdayHours() {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final filtered = where((e) => weekdays.any((day) => e.startsWith(day))).toList();
    return _mergeFormattedTimeRanges(filtered);
  }

  String? getWeekendHours() {
    final weekends = ['Saturday', 'Sunday'];
    final filtered = where((e) => weekends.any((day) => e.startsWith(day))).toList();
    return _mergeFormattedTimeRanges(filtered);
  }

  (tz.TZDateTime? open, tz.TZDateTime? close) getOpenCloseTimes() {
    final istanbul = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(istanbul);
    final today = _days[now.weekday - 1];

    final todayLine = firstWhere((e) => e.startsWith(today), orElse: () => '');
    if (!todayLine.contains(': ')) return (null, null);

    final times = todayLine.split(': ')[1].split('–');
    if (times.length != 2) return (null, null);

    try {
      final open = _parseTimeInIstanbul(times[0].trim());
      final close = _parseTimeInIstanbul(times[1].trim());

      return (open, close);
    } catch (e) {
    
      return (null, null);
    }
  }

  tz.TZDateTime _parseTimeInIstanbul(String timeStr) {
    final istanbul = tz.getLocation('Europe/Istanbul');

    final cleaned = timeStr
        .replaceAll(' ', '') 
        .replaceAll(' ', '') 
        .trim();

    final withSpace = cleaned.replaceAllMapped(
      RegExp(r'(?<=\d)(AM|PM)', caseSensitive: false),
      (match) => ' ${match.group(0)}',
    );

    try {
      final parsed = DateFormat.jm().parse(withSpace);
      final now = tz.TZDateTime.now(istanbul);

      return tz.TZDateTime(
        istanbul,
        now.year,
        now.month,
        now.day,
        parsed.hour,
        parsed.minute,
      );
    } catch (e) {
    
      rethrow;
    }
  }

  
  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }


  String _mergeFormattedTimeRanges(List<String> entries) {
    final istanbul = tz.getLocation('Europe/Istanbul');

    final ranges = entries
        .map((e) => e.split(': ').length > 1 ? e.split(': ')[1].trim() : '')
        .where((e) => e.isNotEmpty)
        .map((range) {
          final times = range.split('–');
          if (times.length != 2) return null;

          try {
            final open = _parseTimeInIstanbul(times[0].trim());
            final close = _parseTimeInIstanbul(times[1].trim());

            return '${_formatTime(open)} – ${_formatTime(close)}';
          } catch (_) {
            return null;
          }
        })
        .whereType<String>()
        .toSet()
        .toList();

    return ranges.length == 1 ? ranges.first : ranges.join(' / ');
  }
}
