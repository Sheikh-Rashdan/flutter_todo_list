import 'package:flutter/material.dart';
import 'package:todo_list/widgets/primary_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.iconData,
    this.onCancel,
    this.onConfirm,
  });

  final String title;
  final IconData iconData;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Row(
        spacing: 10,
        children: [
          Icon(
            iconData,
            size: Theme.of(context).textTheme.headlineLarge?.fontSize,
          ),
          Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 10,
          children: [
            PrimaryButton(
              text: "Cancel",
              icon: Icon(Icons.cancel_rounded),
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop();
              },
            ),
            PrimaryButton(
              text: "Confirm",
              icon: Icon(Icons.check_circle_rounded),
              onPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
