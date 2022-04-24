import 'package:intl/intl.dart';

class DateUtil {
  static const DATE_FORMAT = 'dd/MM/yyyy';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }

  String getFormattedDate(DateTime dateTime) {
    List months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    String date = "";
    date = dateTime.day.toString() +
        " " +
        months[dateTime.month - 1].toString() +
        " " +
        dateTime.year.toString();
    return date;
  }
}
