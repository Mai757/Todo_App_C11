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
import 'package:todo_app/ui/login/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController passwordConfirmation = TextEditingController();

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
                  title: "Full Name",
                  hint: "enter your full name",
                  keyboardType: TextInputType.name,
                  validator: (text){
                    if(text?.trim().isEmpty ==true){
                      return "Please enter full name";
                    }
                    if((text?.length?? 0) < 6){
                      return "Full Name at least 6 chars";

                    }
                    return null;
                  },
                  controller: fullName,
                ),
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
                AppFormFiled(
                  title: "Password Confirmation",
                  hint: "enter your password confirmation",
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text){
                    if(text?.trim().isEmpty ==true){
                      return "Please enter your password";
                    }
                    if(password.text != text){
                      return "Password Doesn't Match";
                    }
                    return null;
                  },
                  controller: passwordConfirmation,
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
                      register();

                    }, child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.routeMainColor,
                  ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white
                      ),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacementNamed(context,LoginScreen.routeName);
                    }, child: Text("Sign in",
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

  void register(){

    if
    (formKey.currentState?.validate()== false){
      return;
    }
    createAccount();
  }

  void createAccount()async {
    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
    try {
      showLoadingDialog(context, message: 'please wait.....');
      final appUser = await authProvider.createUserWithEmailAndPassword(email.text,
          password.text,
      fullName.text);
      hideLoading(context);
     if(appUser==null){
       showMessageDialog(context, message: "Something went wrong",
           posButtonTitle: 'try again',
           posButtonAction: (){
             createAccount();
           });
       return;
     }
       showMessageDialog(context, message: "User created successfully",
           posButtonTitle: 'ok',
           posButtonAction: (){
             Navigator.pushReplacementNamed(context, HomeScreen.routeName);
           });

    } on FirebaseAuthException catch (e) {
      String message = 'Something went Wrong';
      if (e.code == FirebaseAuthCodes.WEAK_PASSWORD) {
        message = 'The password provided is too weak.';
      } else if (e.code == FirebaseAuthCodes.EMAIL_IN_USE) {
        message = 'The account already exists for that email.';
      }
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: 'ok');
    } catch (e) {
      String message = 'Something went Wrong';
      hideLoading(context);
      showMessageDialog(context, message: message, posButtonTitle: 'try again',
      posButtonAction: (){
        register();
      });
    }
  }
}
