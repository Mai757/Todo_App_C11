import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/FirebaseAuthCodes.dart';
import 'package:todo_app/providers/AuthProvider.dart';
import 'package:todo_app/ui/DialogUtils.dart';
import 'package:todo_app/ui/Utils.dart';
import 'package:todo_app/ui/ValidationUtils.dart';
import 'package:todo_app/ui/common/TextFormFiled.dart';
import 'package:todo_app/ui/home/homescreen.dart';
import 'package:todo_app/ui/register/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.routeMainColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Form(
            key:formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 48,),
                Image.asset(getImagePath('route_logo.png'),
                  width: double.infinity,),

                AppFormFiled(
                  title: "Email Address",
                  hint: "enter your email address",
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    if(text?.trim().isEmpty ==true){
                      return "Please enter email";
                    }
                    if(!isValidEmail(text!)){
                      return "Please Enter Valid Email";

                    }
                    return null;
                  },
                  controller: email,
                ),
                AppFormFiled(
                  title: "Password",
                  hint: "enter your password",
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text){
                    if(text?.trim().isEmpty ==true){
                      return "Please enter your password";
                    }
                    if(!isValidPassword(text!)){
                      return "Password at least 6 chars";

                    }
                    return null;
                  },
                  controller: password,
                ),

                SizedBox(
                  height: 24,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20)
                    ),
                    onPressed: (){
                      login();

                    }, child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.routeMainColor,
                  ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Donot have an account?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    ),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    }, child: Text("Create Account",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(){
    if(formKey.currentState?.validate()==false){
      return;
    }
    signIn();
  }

  void signIn()async {
    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
    try {
      showLoadingDialog(context, message: 'please wait.....');
      final appUser = await authProvider.signInWithEmailAndPassword(email.text,
          password.text);
      hideLoading(context);
      if(appUser==null){
        showMessageDialog(context, message: "Something went wrong",
            posButtonTitle: 'try again',
            posButtonAction: (){
              signIn();
            });
        return;


      }
      showMessageDialog(context, message: "Logged in successfully",
          posButtonTitle: 'ok',
          posButtonAction: (){
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          });

    } on FirebaseAuthException catch (e) {
      String message = 'Something went Wrong';
     if(e.code ==FirebaseAuthCodes.WRONG_PASSWORD||
     e.code== FirebaseAuthCodes.USER_NOT_FOUND||
     e.code == FirebaseAuthCodes.INVALID_CREDENTIAL){
       message ='Wrong Email or Password';

     }
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: 'ok');
    } catch (e) {
      String message = 'Something went Wrong';
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: 'try again',
          posButtonAction: (){
            login();
          });
    }
  }
}
