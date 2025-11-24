import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final displayText = selectedDate != null 
        ? dateFormat.format(selectedDate!) 
        : 'Selecione a data';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Selecione a data',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF17603A)),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: 16,
                color: selectedDate != null ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ),
        if (validator != null && validator!(selectedDate) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              validator!(selectedDate)!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
