import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebassapp/ui/auth/login_with_phone_number.dart';
import 'package:firebassapp/ui/auth/signup_screen.dart';
import 'package:firebassapp/ui/posts/post_screen.dart';
import 'package:firebassapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();

  }

  void login(){

    setState(() {
      loading = true ;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text,
        password: passwordController.text.toString()).then((value){
          Utils().toastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen())
          );
          setState(() {
            loading = false ;
          });
      
    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Email';
                        }
                        return null ;
                      },


                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Password';
                        }
                        return null ;
                      },


                    ),
                  ],
                )
              ),
              const SizedBox(height: 50,),
              RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      login();

                    }
                  },
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text("Don't Have an Acccount?" ),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())
                    );
                  } ,
                      child: Text('Signup'))
                ],
              ),
              const SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> LoginWithPhoneNumber() ));

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Center(
                    child: Text('Login with Phone No'),
                  ),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
