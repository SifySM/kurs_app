import 'package:intl/intl.dart';

DateTime convertMillisecondsToDateTime(String milliseconds) {
  int millisecondsSinceEpoch = int.parse(milliseconds);
  return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
}

String convertMillisecondsToTimeString(String milliseconds) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(milliseconds));
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  return(formattedDate); // Выводит строку
}

double convertToDouble(String? input) {
  return double.parse(input ?? '0');
}

String formatTimeInMinutes(String timeInMilliseconds) {
  try {
    final timeInMs = int.parse(timeInMilliseconds);
    final timeInMinutes = (timeInMs / 60000).floor(); // 1 minute = 60,000 milliseconds
    return '$timeInMinutes';
  } catch (e) {
    // Handle any exceptions that may occur during parsing
    return 'N/A';
  }
}