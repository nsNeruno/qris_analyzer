import 'package:intl/intl.dart';

extension NumUtils on num {

  String toCurrencyFormat() {
    final isInt = this % 1 == 0;
    return NumberFormat.currency(
      symbol: 'Rp ', decimalDigits: isInt ? 0 : 2,
    ).format(this,);
  }
}