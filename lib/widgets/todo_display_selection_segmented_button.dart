import 'package:flutter/material.dart';

class TodoDisplaySelectionSegmentedButton extends StatelessWidget {
  const TodoDisplaySelectionSegmentedButton({
    super.key,
    required this.selectedOutput,
    required this.onSelectionChanged,
  });

  final String selectedOutput;
  final ValueChanged<Set<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(
          value: "Uncompleted",
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Uncompleted"),
          ),
          icon: Icon(Icons.view_headline_rounded),
        ),
        ButtonSegment(
          value: "Completed",
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Completed"),
          ),
          icon: Icon(Icons.checklist_rounded),
        ),
      ],
      selected: {selectedOutput},
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        textStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        iconSize: Theme.of(context).textTheme.titleLarge?.fontSize,
        selectedBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
      onSelectionChanged: onSelectionChanged,
    );
  }
}
