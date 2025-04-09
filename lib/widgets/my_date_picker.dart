// Modification du widget MyDatePicker
import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  DateTime date;
  final Function(DateTime) onDateChanged;
  final bool isEndDate;
  MyDatePicker({
    super.key, 
    required this.date, 
    required this.onDateChanged ,
    this.isEndDate = false,
    this.initialDate
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
    DateTime now = widget.initialDate ?? DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: widget.isEndDate ? now.add(const Duration(days: 1)) : now,
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