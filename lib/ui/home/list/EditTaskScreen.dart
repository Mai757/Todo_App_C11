
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppDateUtils.dart';
import 'package:todo_app/database/collections/TasksCollection.dart';
import 'package:todo_app/database/models/Task.dart';
import 'package:todo_app/providers/AuthProvider.dart';
import 'package:todo_app/providers/TasksProvider.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/common/DateTimeFiled.dart';
import 'package:todo_app/ui/common/MaterialTextFormFiled.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});
  static const String routeName = "EditTask";

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
   var selectedDate = DateTime.now();


  var title =   TextEditingController();
  var description=   TextEditingController();
  var formKey = GlobalKey<FormState>();
  late Task taskModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){
       taskModel = ModalRoute.of(context)!.settings.arguments as Task;
      title.text = taskModel.title ??'';
      description.text = taskModel.description ??'';
      setState(() {

      });

    });

  }
   @override

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("To Do List",
        style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height:screenSize.height*.1 ,
            color: Theme.of(context).primaryColor,
          ),
         Container(

        padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,

    ),
    height: screenSize.height*.75,
    margin: EdgeInsets.symmetric(horizontal: screenSize.width*.1,
        vertical: screenSize.height*.03),

    child:
    Column(
      children: [
        Text("Edite Task",
        style: Theme.of(context).textTheme.titleMedium,),

    Form(
    key: formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    MaterialTextFormFiled(hint: "Task title",
    validator:(text) {
    if(text == null || text.trim().isEmpty){
    return "please enter task title";
    }
    return null;
    } ,
    controller:title ,),
    MaterialTextFormFiled(hint: "Task Description",
    lines: 3,
    validator:(text) {
    if(text == null || text.trim().isEmpty){
    return "please enter task description";
    }
    return null;
    } ,
    controller:description ,),
    SizedBox(height: 12,),
    Row(
    children: [
    Expanded(child: DateTimeFiled(title: "Task Date", hint:
    selectedDate == null?
    " select date":"${selectedDate.formatDate()}",
    onClick: (){
    showDatePickerDialog();
    },)),
    Expanded(child: DateTimeFiled(title: "Task Time", hint:
    selectedTime ==null ?
    " select time": "${selectedTime?.formatTime()}",
    onClick: (){
    showTimePickerDialog();
    },))

    ],
    ),
    ElevatedButton(onPressed: (){
    editTask();
    },
       style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
        child: Text("Save Changes"))


    ],

    ))
    ],
      ),
    ),
      ],
    ),
    );

  }

  void showDatePickerDialog()async {
    var date = await showDatePicker(context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if( date ==null) return;
    setState(() {
      selectedDate = date;
    });

  }
  TimeOfDay? selectedTime;

  void showTimePickerDialog()async {
    var time = await showTimePicker(context: context,
      initialTime:selectedTime ?? TimeOfDay.now(),);
    if(time ==null) return;
    setState(() {
      selectedTime = time;
    });
  }
  bool isValidTask(){
    bool isValid = true;
    if(formKey.currentState?.validate() == false){
      isValid = false;
    }
    if(selectedDate == null){
      showMessageDialog(context, message: "Please select task date",
          posButtonTitle: "ok");
      isValid = false;
    }
    if(selectedTime == null){
      showMessageDialog(context, message: "Please select task time",
          posButtonTitle: "ok");
      isValid = false;
    }
    return isValid;
  }

  void editTask()async {
    if(isValidTask() == false)return;

    var authProvider = Provider.of<AppAuthProvider>(context, listen: false);


    var tasksProvider = Provider.of<TasksProvider>(context,listen: false);
    var task = Task(
         title: title.text,
        description: description.text,
        date: selectedDate?.dateOnly(),
        time: selectedTime?.timeSinceEpoch(),

    );
    TasksCollection.editIsDone(task:task,uId:authProvider.authUser!.uid);



    try{
      showLoadingDialog(context, message: "Edit task please wait");
      var result = await tasksProvider.addTask(authProvider.appUser?.authId ??"", task);
      hideLoading(context);
      showMessageDialog(context, message: "Task Edited successfully",
          posButtonTitle: "ok",
          posButtonAction: (){
            Navigator.pop(context);

          });


    }catch(e){
      hideLoading(context);
      showMessageDialog(context, message: e.toString(),
        posButtonTitle: "ok",

      );


    }


  }
}







