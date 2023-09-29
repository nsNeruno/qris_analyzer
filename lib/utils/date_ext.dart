import 'package:intl/intl.dart';

extension DateExt on DateTime {

  String toDateFormat({String format = 'dd/MM/yyyy HH:mm',}) {
    return DateFormat(format,).format(this,);
  }
}