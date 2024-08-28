import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppDateUtils.dart';
import 'package:todo_app/database/collections/TasksCollection.dart';
import 'package:todo_app/database/models/Task.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/Utils.dart';
import 'package:todo_app/ui/home/list/EditTaskScreen.dart';

import '../../../providers/AuthProvider.dart';

typedef OnTaskDeleteClick =  void Function(Task task);
class TaskItem extends StatefulWidget {
  Task task;
  OnTaskDeleteClick onDeleteClick;
   TaskItem({required this.task,required this.onDeleteClick});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {

    var authProvider = Provider.of<AppAuthProvider>(context);

    String? uId = authProvider.authUser!.uid;
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(EditTaskScreen.routeName,arguments: widget.task);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Slidable(
          startActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(onPressed: (buildContext){
                showMessageDialog(context, message:
                "Are you sure to delete this task ?",
                posButtonTitle: "confirm",posButtonAction: (){
                  widget.onDeleteClick(widget.task);

                    },
                negButtonTitle: "cancel");
              },
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
                        color:  widget.task.isDone==true ? Colors.green :Theme.of(context).primaryColor,)
                  ),
                  SizedBox(width: 12,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.task.title}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith
                          (color:widget.task.isDone==true ?
                        Colors.green:Theme.of(context).primaryColor )),
                      SizedBox(height: 8,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.watch_later_outlined
                          ,color:widget.task.isDone==true ?
                              Colors.green:Theme.of(context).primaryColor),

                          SizedBox(width: 8,),
                          Text('${widget.task.time?.formatTime()}',
                            style: Theme.of(context).textTheme.bodySmall,),
                        ],
                      )
                    ],
                  )),
                  SizedBox(width: 12,),
                  InkWell(
                    onTap: (){
                      widget.task.isDone =! widget.task.isDone!;
                      TasksCollection.editIsDone(task:widget.task,uId:uId);
                      setState(() {

                      });
                    },
                    child:widget.task.isDone == true?
                    Text('Done!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith
                          (color:widget.task.isDone==true ?
                        Colors.green:Theme.of(context).primaryColor )):

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
                        )),
                  )
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }
}
