import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDateTimePicker({
  required IconData iconData,
  required BuildContext context,
  required void Function(DateTime) onSelected,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    onTap: () async {
      final date = await showDatePicker(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          initialDatePickerMode: DatePickerMode.year,
          initialDate:
              DateTime.now().subtract(const Duration(days: (18 * 365) + 4)),
          firstDate: DateTime(1923),
          lastDate:
              DateTime.now().subtract(const Duration(days: (18 * 365) + 4)));
      if (date == null) return;
      controller.text = DateFormat('dd/MM/yyyy').format(date);
      onSelected(date);
    },
    validator: (value) {
      if (value!.isEmpty) {
        return "Lütfen doğum tarihinizi giriniz.";
      }
      return null;
    },
    readOnly: true,
    controller: controller,
    decoration: InputDecoration(
        prefixIcon: Icon(
          iconData,
          color: Colors.black,
        ),
        hintText: controller.text == '' ? 'Doğum Tarihi' : controller.text,
        contentPadding: const EdgeInsets.fromLTRB(74, 12, 10, 12)),
  );
}
