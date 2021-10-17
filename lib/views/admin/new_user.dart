import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class NewUser extends StatefulWidget {
  const NewUser({Key key}) : super(key: key);

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final _firestore = FirebaseFirestore.instance;

  DatabaseReference driversRef= FirebaseDatabase.instance.reference().child('Users');
  var type = "user";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _obscureText = true;
  TextEditingController nameTextEditingControler = TextEditingController();

  TextEditingController emailTextEditingControler = TextEditingController();

  TextEditingController phoneTextEditingControler = TextEditingController();

  TextEditingController passwordTextEditingControler = TextEditingController();
  String dropdownValue = 'user';
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
      appBar: AppBar(
        title: Text('Register User'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height:10.0,),
                Image(
                  image: AssetImage("images/user_icon.png"),
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,

                ),
                SizedBox(height: 1.0,),
                Text(
                  "Register a User",
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
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.indigoAccent),
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            type = newValue;
                          });
                        },
                        items: <String>['user', 'admin']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 10.0,),
                      if (isLoading) CircularProgressIndicator(
                        strokeWidth: 5,
                      ) else ElevatedButton(
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
                                  // 42
                                  'admin': type != null ? false : true,
                                  'active': true
                                })
                                    .then((value) => print("User Added"))
                                    .catchError((error) =>
                                    print("Failed to add user: $error"));
                                if (firebaseUser != null) {
                                  Map userDataMap = {
                                    "name": nameTextEditingControler.text,
                                    "email": emailTextEditingControler.text,
                                    "phone": phoneTextEditingControler.text,
                                    "admin": false,
                                    'active': true
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
          'email': emailTextEditingControler,
          'password': passwordTextEditingControler,
          'admin': false,
         'active': true


        }).then((value) {
          // Call the user's CollectionReference to add a new user
        });
      });
    }
    catch (e) {

    }
    displayToast2("User Registered", context);
    Navigator.pop(context);
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
