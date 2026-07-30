/// Reusable UI formatters for Roti Saku.
///
/// Use these helpers to keep currency and related presentation
/// consistent across customer and admin screens.
import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  String toRupiah() {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }
}
