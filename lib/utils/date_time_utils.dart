import 'package:intl/intl.dart';

extension DateTimeUtils on String? {
  String convertTo12HourFormat() {
    if (this != null) {
      // Parse the input string into a DateTime object
      DateTime dateTime = DateTime.parse(this!);

      // Format the DateTime object into 12-hour format
      String formattedTime = DateFormat('h a').format(dateTime);

      return formattedTime.toUpperCase(); // Convert to uppercase for PM/AM
    }
    return '';
  }

  String convertToMonthDayFormat() {
    if (this != null) {
      // Parse the input string into a DateTime object
      DateTime dateTime = DateTime.parse(this!);

      // Format the DateTime object into 12-hour format
      String formattedTime = DateFormat('MMM d').format(dateTime);

      return formattedTime; // Convert to uppercase for PM/AM
    }
    return '';
  }
}
