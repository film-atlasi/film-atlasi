import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget AddVerticalSpace(BuildContext context, double size) => SizedBox(
      height: MediaQuery.of(context).size.height * size,
    );

Widget AddHorizontalSpace(BuildContext context, double size) => SizedBox(
      width: MediaQuery.of(context).size.width * size,
    );

// Tarihi biçimlendirmek için yardımcı bir fonksiyon
String formatDate(DateTime? date) {
  if (date == null) {
    return 'Unknown';
  }
  return DateFormat('dd MMMM yyyy').format(date);
}
