import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        fillColor: Colors.red,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        label: Text(
          labelText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
