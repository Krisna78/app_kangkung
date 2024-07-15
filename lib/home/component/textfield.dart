import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldPage extends StatelessWidget {
  final controller;
  final String hintText;
  final bool isLongText;
  final TextInputType textInputType;
  final int? maxLine;

  const TextFieldPage({
    super.key,
    required this.controller,
    required this.hintText,
    this.isLongText = false,
    this.textInputType = TextInputType.text,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            maxLines: maxLine,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: textInputType,
            inputFormatters: textInputType == TextInputType.number
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.deny(RegExp(r'[ \-\,\.]')),
                  ]
                : [],
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                fontSize: 14,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF80AF81))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF80AF81))),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF80AF81))),
              fillColor: Colors.grey.shade100,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            validator: (value) {
              if (isLongText) {
                return null;
              } else if (value == null || value.isEmpty) {
                return "Mohon wajib di isi";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
