import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/widgets/primary_button.dart';
import 'package:todo_list/widgets/title_card.dart';

class EditSheet extends StatefulWidget {
  const EditSheet({
    super.key,
    required this.title,
    required this.textFieldLabel,
    required this.currentString,
    required this.newStringController,
    required this.editObject,
  });

  final String title;
  final String textFieldLabel;
  final TextEditingController newStringController;
  final String currentString;
  final void Function(String newString) editObject;

  @override
  State<EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<EditSheet> {
  @override
  Widget build(BuildContext context) {
    bool buttonEnabled =
        widget.newStringController.text != widget.currentString;
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: max(50, MediaQuery.of(context).viewInsets.bottom + 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleCard(title: widget.title),
          TextField(
            controller: widget.newStringController,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              label: Text(
                widget.textFieldLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prefixIcon: Icon(Icons.bookmark_add),
              prefixIconColor: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
          PrimaryButton(
            text: "Edit",
            icon: Icon(Icons.edit_rounded),
            onPressed: buttonEnabled
                ? () {
                    String newString = widget.newStringController.text;
                    if (newString != widget.currentString) {
                      widget.editObject(newString);
                    }
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
