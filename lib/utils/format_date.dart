import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormatDate {
  String formatDateComplete(DateTime date) {
    return DateFormat("yMMMMEEEEd", 'fr_FR').format(date);
  }

  String formatToDate(Timestamp date) {
    return DateFormat.yMMMMd("fr_FR").format(date.toDate());
  }
  String formatToSimple(Timestamp date) {
    return DateFormat.yMd("fr_FR").format(date.toDate());
  }
}
