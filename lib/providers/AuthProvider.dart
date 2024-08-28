import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/database/collections/UsersCollection.dart';
import 'package:todo_app/database/models/AppUser.dart';

class AppAuthProvider extends ChangeNotifier{
  UsersCollection usersCollection = UsersCollection();
  User? authUser;
  AppUser? appUser;
  AppAuthProvider(){
    authUser = FirebaseAuth.instance.currentUser;
    if(authUser!=null){
      signInWithUid(authUser!.uid);

    }

  }
  void signInWithUid(String uid) async{
    appUser = await usersCollection.readUser(uid);
    notifyListeners();
  }
  bool isLoggedIn(){
    return authUser != null;
  }

   void login(User newUser){
    authUser = newUser;
  }
  void logout(){
    authUser = null;
    FirebaseAuth.instance.signOut();
  }
  Future<AppUser?> createUserWithEmailAndPassword(
      String email,
      String password,
      String fullName
      )async{
    UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if(credential.user !=null){
      login(credential.user!);
       appUser = AppUser(
        authId: credential.user?.uid,
        fullName:fullName ,
        email: email
      );
     var result= await usersCollection.createUser(appUser!);
     return appUser!;

    }
    return null;

  }
  Future<AppUser?> signInWithEmailAndPassword(
      String email,
      String password
      )async{
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if(credential.user !=null){
      login(credential.user!);
       appUser = await usersCollection.readUser(credential.user!.uid);


    }
    return appUser;

  }
}