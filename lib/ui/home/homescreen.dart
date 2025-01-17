import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/AuthProvider.dart';
import 'package:todo_app/ui/home/AddTaskBottomSheet.dart';
import 'package:todo_app/ui/home/list/TasksListTab.dart';
import 'package:todo_app/ui/home/settings/settingsTab.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;

  var tabs = [
    TasksListTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(

        title: Text("Welcome : ${provider.appUser?.fullName}"),
        actions: [
          InkWell(
            onTap: (){
              provider.logout();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
              child: Icon(Icons.logout))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white,
              width: 4),
        ),
        onPressed: (){
          showAddTaskBottomSheet();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 24,

        child: BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (newSelectedIndex){
            selectedTabIndex = newSelectedIndex;
            setState(() {

            });

          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: ''),
          ],

        ),
      ),
      body: tabs[selectedTabIndex],
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(context: context, builder: (buildContext){
      return AddTaskBottomSheet();
    });
  }
}