
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/registrationScreen.dart';

import 'package:flutterthreadexample/subViews/changeUserIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/const.dart';
import 'loginScreen.dart';

class UserProfile extends StatefulWidget{
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  User user;
  UserProfile({this.myData,this.updateMyData, this.user});
  @override State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile>{

  String _myThumbnail;
  String _myName;
  User user;
  @override
  void initState() {
    _myName = widget.myData.myName;
    _myThumbnail = widget.myData.myThumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.user.isAnonymous?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as Guest"),
          SizedBox(height: 10,),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
            },
            child: Text(
                "Do not have an Account? Register here"
            ),
          ),
        ],
      ),
    )
        :Scaffold(
        body: SingleChildScrollView(

      child: Card(
        elevation:2.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        child: Image.asset('images/$_myThumbnail')
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:3.0),
                        child: Text('Change',style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold,fontSize: size.width *0.03),),
                      )
                    ],
                  )
                ),
              ),
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => ChangeUserIcon(myData: widget.myData,),
                  barrierDismissible: true,
                ).then((newMyThumbnail){
                  _updateMyData(widget.myData.myName,newMyThumbnail);
                });
              },
            ),
            GestureDetector(
              onTap: (){
                _showDialog();
              },
              child: Text('Name: $_myName',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)
            ),
            TextButton(  onPressed: () async {
              SharedPreferences prefs=await SharedPreferences.getInstance();
              prefs.remove("email");
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              });
            },
              child: Text(
                  "Sign Out"
              ),
            ),
          ],
        )

      ),),
    );

  }

  Future<void> _updateMyData(String newName, String newThumbnail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName',newName);
    prefs.setString('myThumbnail',newThumbnail);
    setState(() {
      _myThumbnail = newThumbnail;
      _myName = newName;
    });
    MyProfileData newMyData = MyProfileData(
        myName: newName,
        myThumbnail: newThumbnail
    );
    widget.updateMyData(newMyData);
  }

  void _showDialog() async {
    TextEditingController _changeNameTextController = TextEditingController();
    await showDialog(
      context: context, builder: (BuildContext context) {
        return CircularProgressIndicator();
    },



    );
  }
}
