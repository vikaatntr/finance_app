import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Currency extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final int pennies = int.parse(newValue.text);
    final String formattedValue =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
            .format(pennies);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
