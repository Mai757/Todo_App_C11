import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/AuthProvider.dart';
import 'package:todo_app/providers/TasksProvider.dart';
import 'package:todo_app/ui/home/homescreen.dart';
import 'package:todo_app/ui/home/list/EditTaskScreen.dart';
import 'package:todo_app/ui/login/LoginScreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';
import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppAuthProvider()),
      ChangeNotifierProvider(create: (_) => TasksProvider()),

    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context);
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        textTheme: TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            titleSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white
            )
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Color(0xffC8C9CB),
        ),
        scaffoldBackgroundColor: Color(0xffDFECDB),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      routes: {
        HomeScreen.routeName : (_)=> HomeScreen(),
        RegisterScreen.routeName : (_)=>RegisterScreen(),
        LoginScreen.routeName : (_)=>LoginScreen(),
        EditTaskScreen.routeName: (_)=>EditTaskScreen(),
      },
      initialRoute:
      authProvider.isLoggedIn()?HomeScreen.routeName :
      LoginScreen.routeName,
    );
  }
}

