import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppDateUtils.dart';
import 'package:todo_app/database/models/Task.dart';
import 'package:todo_app/providers/AuthProvider.dart';
import 'package:todo_app/providers/TasksProvider.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/home/list/TaskItem.dart';

class TasksListTab extends StatefulWidget {
  const TasksListTab({super.key});

  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  List<Task>? tasksList;
  late AppAuthProvider authProvider ;
   late TasksProvider tasksProvider;
   @override
  void initState() {

    super.initState();
     authProvider = Provider.of<AppAuthProvider>(context, listen: false);

   }
   var selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    tasksProvider = Provider.of<TasksProvider>(context);


    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: selectedDate,
          onDateChange: (clickedDate) {
            setState(() {
              selectedDate = clickedDate;
            });
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Task>>
            (stream: tasksProvider.tasksCollection.listenForTasks(
              authProvider.authUser?.uid ??"", selectedDate.dateOnly()),
              builder: (buildContext, snapshot) {
                if(snapshot.hasError){
                  return Center(child:
                    Column(
                      children: [
                        Text("Something went wrong"),
                        ElevatedButton(onPressed: (){
                          setState(() {});
                        }, child: Text("Try again"))
                      ],
                    ),);
          
                }
                if(snapshot.connectionState== ConnectionState.waiting){
                  return Center(child:CircularProgressIndicator() ,);
          
                }
                var tasksList = snapshot.data?.docs.map((doc) => doc.data()).toList();
                 return ListView.separated(itemBuilder: (context, index) {
                  return TaskItem(task: tasksList![index],
                  onDeleteClick: deleteTask,);
                }, separatorBuilder: (_, __) => Container(height: 24,)
          
                    , itemCount: tasksList?.length ?? 0);
          
              },),
        ),
      ],
    );


  }
  void deleteTask(Task task)async{
     showLoadingDialog(context, message: "please wait....");
     try {
       await tasksProvider.removeTask(authProvider.authUser?.uid??"", task);
       hideLoading(context);
       setState(() {

       });
     }catch(e){
       showMessageDialog(context, message: "Something went wrong ${e.toString()}",
       posButtonTitle: "retry",posButtonAction: (){
         deleteTask(task);
           });

     }

  }

}
