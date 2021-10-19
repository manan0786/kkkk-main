import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/views/admin/admin_dashboard.dart';
import 'package:flutterthreadexample/views/admin/admin_login.dart';

import 'package:flutterthreadexample/views/forget_pass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f_grecaptcha/f_grecaptcha.dart';
import 'myHomePage.dart';
import 'registrationScreen.dart';

enum AuthFormType { anonymous }
const String SITE_KEY = "6LdlVtgcAAAAADsdaa89qQEWX5yRctTiZC7PB3-T";
enum _VerificationStep {
  SHOWING_BUTTON, WORKING, ERROR, VERIFIED
}


class LoginScreen extends StatefulWidget {
  final AuthFormType authFormType;
  LoginScreen({Key key, this.authFormType}) : super(key: key);
  static const String idScreen="Login";

  @override
  State<LoginScreen> createState() => _LoginScreenState(authFormType: this.authFormType);
}

class _LoginScreenState extends State<LoginScreen> {
  AuthFormType authFormType;
  _LoginScreenState({this.authFormType});

// Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;

  User user;


  var email = "";
  var password = "";
  FirebaseAuth _auth = FirebaseAuth.instance;


  // Initially password is obscure
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingControler = TextEditingController();
  TextEditingController passwordTextEditingControler = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("Users");

  void _startVerification() {
    setState(() => _step = _VerificationStep.WORKING);

    FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
      setState(() {
        _step = _VerificationStep.VERIFIED;
        LoginGuest();
      });

    }, onError: (e, s) {
      print("Could not verify:\n$e at $s");
      setState(() => _step = _VerificationStep.ERROR);
    });
  }

  userLogin() async {

    try {
      UserCredential user =await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null && await user.user.getIdToken() != null) {
        print("AGAYA");
        final User currentUser = _auth.currentUser;
        print(currentUser);
        final userID = currentUser.uid;
        print(userID);
        if (currentUser.uid == user.user.uid) {
         /* setState(() {
            isLoading = false;
          });*/
        await checkEmailVerified(context);
        }
      }

    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        Fluttertoast.showToast(
            msg: "No user found for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailTextEditingControler.dispose();
    passwordTextEditingControler.dispose();
    super.dispose();
  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_step) {
      case _VerificationStep.SHOWING_BUTTON:
        content = new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text("This example will use the reCaptcha API to verify that you're human"),
              new RaisedButton(
                onPressed: _startVerification,
                child: const Text("VERIFY"),
              )
            ]
        );
        break;
      case _VerificationStep.WORKING:
        content = new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new CircularProgressIndicator(),
              new Text("Trying to figure out whether you're human"),
            ]
        );
        break;
      case _VerificationStep.VERIFIED:
        displayToast("Verified", context);
        break;
      case _VerificationStep.ERROR:
        content = new Text(
            "We could not verify that you're a human :( This can occur if you "
                "have no internet connection (or if you really are a a bot)."
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 15.0,),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 300.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1.0,),
                Text(
                  "Login as a User",
                  style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextFormField(
                        controller: emailTextEditingControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 1.0,),
                      TextFormField(
                        obscureText: _obscureText,
                        controller: passwordTextEditingControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 10.0,),
                      isLoading
                          ? CircularProgressIndicator(
                        strokeWidth: 5,
                      ) :ElevatedButton(
                          onPressed: () async{
                          /*  setState(() {
                              isLoading = true;
                            });*/

                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  email = emailTextEditingControler.text;
                                  password = passwordTextEditingControler.text;
                                });
                                userLogin();
                              }
                          },

                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Brand Bold"
                                ),
                              ),
                            ),
                          )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                                )
                            );
                          },
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(  onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                  child: Text(
                      "Do not have an Account? Register here"
                  ),
                ),
                Text("OR"),
                ElevatedButton(onPressed: (){
                  _startVerification();
                 }, child: Text("Login as a Guest")),
                ElevatedButton(onPressed: ()
                {adminLogin();
                }, child: Text("Login as a Admin")),
             /*   Center(
                  child: content,
                ),*/

              ],
            ),
          ),
        ),
      ),
    );
  }




  Future<void> checkEmailVerified(context) async{
    User _user = await _auth.currentUser;
    if(_user.emailVerified){

      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setString("email",emailTextEditingControler.text);
      displayToast("Login Successful", context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
    }
    else{
      Fluttertoast.showToast(
          msg: "Please verify your email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void adminLogin() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));

  }
  void LoginGuest()async{
    try {
      if (AuthFormType.anonymous != null) {
        await _auth.signInAnonymously();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", _auth.currentUser.uid);
        displayToast("Login as Guest", context);
        Navigator.pushNamedAndRemoveUntil(
            context, MyHomePage.idScreen, (route) => false);
      }
    }
    catch (e){
      print(e);
    }


  }


}

displayToast(String message,BuildContext context ){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

