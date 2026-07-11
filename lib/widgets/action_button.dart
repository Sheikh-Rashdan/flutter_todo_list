import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.icon, required this.onPressed});

  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white.withAlpha(50),
      ),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
