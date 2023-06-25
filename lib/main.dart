import 'package:flutter/material.dart';
import 'package:multi_select_madness/multi_select_gridview.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MultiSelectGridView(
          count: 20,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: MediaQuery.of(context).size.width ~/ 100,
          itemBuilder: (key, index, selected) {
            return SelectableItem(
              key: key,
              index: index,
              selected: selected,
            );
          },
        ),
      ),
    );
  }
}

class SelectableItem extends StatelessWidget {
  const SelectableItem({
    super.key,
    required this.index,
    required this.selected,
  });

  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? Colors.blue : Colors.red,
    );
  }
}
