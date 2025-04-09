import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  
  final VoidCallback onTap;
  const MyFloatingActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: ValueKey("add-project"),
      onPressed: onTap,
    child: Icon(Icons.add),
    );
  }
}
