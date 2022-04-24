import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : '1 weekw ago';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} day ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : '1 day ago';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hours ago' : '1 hours ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minutes' : '1 minutes ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

} 