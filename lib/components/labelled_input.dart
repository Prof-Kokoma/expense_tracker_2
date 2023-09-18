import 'package:expense_tracker_2/components/textfield_component.dart';
import 'package:flutter/material.dart';

class LabelledInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelledName;
  final TextInputType keyboardType;
  final String hintText;
  const LabelledInput({
    super.key,
    required this.controller,
    required this.labelledName,
    required this.keyboardType,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$labelledName: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: InputTextField(
            controller: controller,
            hintText: hintText,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}
