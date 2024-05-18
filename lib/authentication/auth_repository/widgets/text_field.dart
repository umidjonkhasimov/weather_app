import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController controller,
  required String hint,
  required String label,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
      hintText: hint,
    ),
  );
}
