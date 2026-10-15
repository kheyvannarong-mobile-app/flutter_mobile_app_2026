class DateFormatter {
  DateFormatter._();

  static String format(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "";
    try {
      final date = DateTime.parse(isoString);
      final months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];
      final month = months[date.month - 1];
      final day = date.day.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return "$day $month $year, $hour:$minute";
    } catch (_) {
      return isoString;
    }
  }

  static String formatShort(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "";
    try {
      final date = DateTime.parse(isoString);
      final months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];
      final month = months[date.month - 1];
      final day = date.day.toString().padLeft(2, '0');
      return "$day $month";
    } catch (_) {
      return isoString;
    }
  }
}
