import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/Utils.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Slidable(
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(onPressed: (_){},
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: 'delete',
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),)
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Row(
              children: [
                Container(width: 4, height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).primaryColor,)
                ),
                SizedBox(width: 12,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Task Title',
                      style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(width: 8,),
                        Text('Time',
                          style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    )
                  ],
                )),
                SizedBox(width: 12,),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 24,
                        vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ImageIcon(
                      AssetImage(getImagePath('ic_check.png'),),
                      color: Colors.white,
                    ))
              ],
            ),

          ),
        ),
      ),
    );
  }
}
