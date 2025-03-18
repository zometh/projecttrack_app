// Modification du widget MyDatePicker
import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  DateTime date;
  final Function(DateTime) onDateChanged; // Nouveau callback
  
  MyDatePicker({
    super.key, 
    required this.date, 
    required this.onDateChanged // Callback obligatoire
  });

  @override
  State createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _pickDate,
      icon: Icon(Icons.date_range_sharp)
    );
  }
  
  _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    
    if (picked != null) {
      setState(() {
        widget.date = picked;
      });
      
      // Informer le parent de la modification
      widget.onDateChanged(picked);
    }
  }
}