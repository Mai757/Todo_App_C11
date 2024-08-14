import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/list/TaskItem.dart';

class TasksListTab extends StatelessWidget {
  const TasksListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context ,index){
      return TaskItem();

    },separatorBuilder: (_ , __)=>Container(height: 24,)

        , itemCount: 5);
  }
}
