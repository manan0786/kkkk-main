import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/registrationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginScreen.dart';
import 'myHomePage.dart';
var email,uid;

Future<void> main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs=await SharedPreferences.getInstance();
  email=prefs.getString("email");
  uid= prefs.getString("uid");
  runApp(MyApp());
}
class MyApp extends StatelessWidget  {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // CHeck for Errors
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Internal Server Error',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
        // once Completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),

            initialRoute: uid == null ? LoginScreen.idScreen : MyHomePage.idScreen,
            debugShowCheckedModeBanner: false,
            routes: {
              RegistrationScreen.idScreen: (context) => RegistrationScreen(),
              LoginScreen.idScreen: (context) => LoginScreen(),
              MyHomePage.idScreen: (context) => MyHomePage(),


              '/login': (_) => LoginScreen(),
              '/register': (_) => RegistrationScreen(),


            },


          );
        }
        return CircularProgressIndicator();
      },
    );


  }
}





