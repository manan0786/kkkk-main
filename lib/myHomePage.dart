

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterthreadexample/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categories_tab.dart';

import 'commons/const.dart';
import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'loginScreen.dart';

class MyHomePage extends StatefulWidget {

  static const String idScreen="MainScreen";
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with TickerProviderStateMixin{
  TabController _tabController;
 MyProfileData myData;
  User _user;
  bool _isLoading = false;

  @override
  void initState() {

    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
   _takeMyData();
    GetUser();
    super.initState();

  }
  Future<void> GetUser() async{
    _user = await FirebaseAuth.instance.currentUser;
    print(_user);
  }
  Future<void> _takeMyData() async{
    _user = await FirebaseAuth.instance.currentUser;
    print(_user);
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;
    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = iconImageList[Random().nextInt(50)];
      prefs.setString('myThumbnail',tempThumbnail);
      myThumbnail = tempThumbnail;
    }else{
      myThumbnail = prefs.get('myThumbnail');
    }

    if (prefs.get('myName') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('myName',tempName);
      myName = tempName;
    }else{
      myName = prefs.get('myName');
    }

    setState(() {
      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: myName,
        myLikeList: prefs.getStringList('likeList'),
        myDisLikeList: prefs.getStringList('dislikeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manitoba Moose'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async{
            SharedPreferences prefs=await SharedPreferences.getInstance();
            prefs.remove("uid");
            prefs.remove("email");
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
            });

          }, icon: Icon(Icons.logout))
        ],

      ),

      body: Stack(
        children: <Widget>[
          TabBarView(
              controller: _tabController,
              children: [
                Categories(myData: myData,updateMyData: updateMyData, user: _user),
                UserProfile(myData: myData,updateMyData: updateMyData,user: _user),
              ]
          ),
          Utils.loadingCircle(_isLoading),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey[800],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.category_outlined
            ),
            title: new Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text('Profile'),
          ),
        ],
      ),
    );
  }

}




