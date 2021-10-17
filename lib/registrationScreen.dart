import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginScreen.dart';



class RegistrationScreen extends StatefulWidget {

  static const String idScreen = "Register";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final _firestore = FirebaseFirestore.instance;

  DatabaseReference driversRef= FirebaseDatabase.instance.reference().child('Users');

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _obscureText = true;
  TextEditingController nameTextEditingControler = TextEditingController();

  TextEditingController emailTextEditingControler = TextEditingController();

  TextEditingController phoneTextEditingControler = TextEditingController();

  TextEditingController passwordTextEditingControler = TextEditingController();

  User _user;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailTextEditingControler.dispose();
    passwordTextEditingControler.dispose();
    phoneTextEditingControler.dispose();
    nameTextEditingControler.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,

                ),
                SizedBox(height: 1.0,),
                Text(
                  "Register as a User",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,

                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextFormField(
                        controller: nameTextEditingControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
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
                        controller: phoneTextEditingControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone no';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone",
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
                        controller: passwordTextEditingControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                        obscureText: _obscureText,

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
                           if (_formKey.currentState.validate()) {
                             if (nameTextEditingControler.text.length < 4) {
                               displayToast("Name must be at least of 3 characters",
                                   context);
                             } else
                             if (!emailTextEditingControler.text.contains(
                                 "@")) {
                               displayToast("Invalid Email", context);
                             } else
                             if (passwordTextEditingControler.text.length <
                                 7) {
                               displayToast("Password must contains at least of 5 characters",
                                   context);
                             } else {

                               var firebaseUser = (await _firebaseAuth
                                   .createUserWithEmailAndPassword(
                                   email: emailTextEditingControler.text,
                                   password: phoneTextEditingControler.text)
                               ).user;

                               await users
                                   .add({
                                 'email': emailTextEditingControler.text.trim(),
                                 // John Doe
                                 'name': nameTextEditingControler.text.trim(),
                                 // Stokes and Sons
                                 'phone': phoneTextEditingControler.text.trim(),
                                 'password': passwordTextEditingControler.text.trim(),
                                 // 42
                                 'admin': 'false',
                                 'active': 'true'

                               })
                                   .then((value) => print("User Added"))
                                   .catchError((error) =>
                                   print("Failed to add user: $error"));
                               if (firebaseUser != null) {
                                 Map userDataMap = {
                                   "name": nameTextEditingControler.text,
                                   "email": emailTextEditingControler.text,
                                   "phone": phoneTextEditingControler.text,
                                   'password': passwordTextEditingControler.text,
                                   "admin": "false",
                                   'active': "true"
                                 };
                                 driversRef.child(firebaseUser.uid).set(
                                     userDataMap).then((value) async {
                                 }
                                 );

                                 print("my user");
                                 print(driversRef);
                                 final User user = await _firebaseAuth.currentUser;
                                 user.sendEmailVerification();

                                 // displayToast("Congratulations your new account has been created", context);
                                 displayToast2("Verification Email Sent.", context);
                                 registerNewUser(context);
                               }
                               setState(() {
                                 isLoading = true;
                               });
                             }

                           }
                          },
                          child:Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Brand Bold"
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                  child: Text(
                      "Already have an Account? Login here"
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerNewUser(BuildContext context) async
  {

    try {

      setState(() {
        isLoading = false;
      });

      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingControler.text,
          password: passwordTextEditingControler.text)
          .then((signedInUser) {

        _firestore.collection("users")
            .add({
          'email': emailTextEditingControler.text,
          'password': passwordTextEditingControler.text,
          'admin': "false",
          'active': "true"


        }).then((value) {
          // Call the user's CollectionReference to add a new user
        });
      });
      }
    catch (e) {

    }

    //Navigator.pushNamedAndRemoveUntil(context, CarInfoScreen.idScreen, (route) => false);
    displayToast2("User Registered", context);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.idScreen, (route) => true);
  }
}
displayToast(String message,BuildContext context ){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
displayToast2(String message,BuildContext context ){
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
