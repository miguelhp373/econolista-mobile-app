import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConverterStrings {
  String convertTimeStampToString(Timestamp timestampValue) {
    DateTime isTimeStampToDateTime = timestampValue.toDate();

    return DateFormat('dd/MM/yyyy HH:mm').format(isTimeStampToDateTime);
  }
}
