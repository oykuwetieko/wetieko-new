extension TimeAgoExtension on DateTime {
  String timeAgo() {
    final diff = DateTime.now().difference(this);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      // Haftadan eskiyse tarihi kısa formatla göster
      return '${this.day}/${this.month}/${this.year}';
    }
  }
}
