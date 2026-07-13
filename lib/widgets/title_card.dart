import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({super.key, this.title, this.widget})
    : assert(title != null || widget != null);

  final String? title;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (title != null) {
      child = Text(
        title!,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
      );
    } else {
      child = widget!;
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      alignment: Alignment.center,
      child: child,
    );
  }
}
