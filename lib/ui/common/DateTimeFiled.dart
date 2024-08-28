
import 'package:flutter/material.dart';
import 'package:todo_app/ui/common/MaterialTextFormFiled.dart';

class DateTimeFiled extends StatelessWidget {
  String title;
  String hint;
  VoidCallback onClick;
   DateTimeFiled({required this.title,required this.hint,
   required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.blue
        )
        ),
        MaterialTextFormFiled(hint: hint,
        editable: false,
        onClick: onClick,)
      ],
    );
  }
}
