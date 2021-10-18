import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/main.dart';
import 'category_detail.dart';
import 'commons/const.dart';
import 'commons/utils.dart';
import '../reportPost.dart';


class Categories extends StatefulWidget {
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  User user;
  Categories({Key key,this.myData,this.updateMyData, this.user}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool _isLoading = false;
  bool value1 = true;
  bool selected = false;
  bool selected1 = false;
  bool selected2 = false;

  String name = "";

  var selectedLanguage, selectedCountry, selectedTopic;
  var lang;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: 85,
          decoration: BoxDecoration(
            color: Colors.indigo,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("FILTERS", style: TextStyle(color:Colors.white),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("filters").doc("language").collection("name").snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator(),);
                          else {
                            List<DropdownMenuItem> currencyItems = [];
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap.get("name"),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "${snap.get("name")}",
                                ),
                              );
                            }
                            return DropdownButton(
                              items: currencyItems,
                              onChanged: (currencyValue) {
                                setState(() {
                                  selectedLanguage = currencyValue;
                                  selected = true;
                                });
                              },
                              value: selectedLanguage,
                              isExpanded: false,
                              hint: new Text(
                                "Language",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }),
                    SizedBox(width:20),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("filters").doc("country").collection("name").snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator(),);
                          else {
                            List<DropdownMenuItem> currencyItems = [];
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap.get("name"),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "${snap.get("name")}",
                                ),
                              );
                            }
                            return DropdownButton(
                              items: currencyItems,
                              onChanged: (currencyValue) {
                                setState(() {
                                  selectedCountry = currencyValue;
                                  selected1 = true;
                                });
                              },
                              value: selectedCountry,
                              isExpanded: false,
                              hint: new Text(
                                "Country",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }),
                    SizedBox(width:20),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("filters").doc("topic").collection("name").snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator(),);
                          else {
                            List<DropdownMenuItem> currencyItems = [];
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap.get("name"),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: "${snap.get("name")}",
                                ),
                              );
                            }
                            return  DropdownButton(

                              items: currencyItems,
                              onChanged: (currencyValue) {

                                setState(() {
                                  selectedTopic = currencyValue;
                                  selected2 = true;
                                  print(selectedTopic);
                                });
                              },
                              value: selectedTopic,

                              isExpanded: false,
                              hint: new Text(
                                "Topic",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }),
                    SizedBox(width:20),
                    IconButton(onPressed: () async{
                      setState(() {
                        selected = false;
                        selected1 =false;
                        selected2 = false;
                      });
                    }, icon: Icon(Icons.refresh, color: Colors.white,)),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height:10),
       ListCategories(size),



      ],
    );

  }
  ListCategories(size){
  if(selected == true){
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').where('catLan', isEqualTo: selectedLanguage).snapshots(),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snapshot.data.docs[index];

                  return GestureDetector(
                    onTap: (){
                      _moveToContentDetail(user);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,

                      margin: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () =>{},
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                                    child: Container(
                                        width: 48,
                                        height: 48,
                                        child: Image.asset('images/logo.png')
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user.get("userName"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(Utils.readTimestamp(user.get('catTimeStamp')),style: TextStyle(fontSize: 16,color: Colors.black87),),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right:8.0,left:8.0),
                                              child: Icon(Icons.report),
                                            ),
                                            Text("Report"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    initialValue: 1,
                                    onCanceled: () {
                                      print("You have canceled the menu.");
                                    },
                                    onSelected: (value) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => ReportPost(postUserName: user.get("userName"),postId:user.get("catID"),content:user.get("catDesc"),reporter:uid,));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Category Title",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            user.get("catTitle"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: CachedNetworkImage(
                                    width: size.width,
                                    height: size.height * 0.40,
                                    imageUrl: user.get('postImage'),
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 70,
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Category Description",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      user.get("catDesc"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
            // Handle no data
            return Center(
              child: Text("No Category found."),
            );
          } else {
            // Still loading
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
  else if (selected1 == true){
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').where('catCountry', isEqualTo: selectedCountry).snapshots(),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snapshot.data.docs[index];

                  return GestureDetector(
                    onTap: (){
                      _moveToContentDetail(user);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,

                      margin: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () =>{},
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                                    child: Container(
                                        width: 48,
                                        height: 48,
                                        child: Image.asset('images/logo.png')
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user.get("userName"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(Utils.readTimestamp(user.get('catTimeStamp')),style: TextStyle(fontSize: 16,color: Colors.black87),),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right:8.0,left:8.0),
                                              child: Icon(Icons.report),
                                            ),
                                            Text("Report"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    initialValue: 1,
                                    onCanceled: () {
                                      print("You have canceled the menu.");
                                    },
                                    onSelected: (value) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => ReportPost(postUserName: user.get("userName"),postId:user.get("catID"),content:user.get("catDesc"),reporter:uid,));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Category Title",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            user.get("catTitle"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: CachedNetworkImage(
                                    width: size.width,
                                    height: size.height * 0.40,
                                    imageUrl: user.get('postImage'),
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 70,
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Category Description",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      user.get("catDesc"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
            // Handle no data
            return Center(
              child: Text("No Category found."),
            );
          } else {
            // Still loading
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
  else if (selected2 == true){
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').where('catTopic', isEqualTo: selectedTopic).snapshots(),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snapshot.data.docs[index];

                  return GestureDetector(
                    onTap: (){
                      _moveToContentDetail(user);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,

                      margin: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () =>{},
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                                    child: Container(
                                        width: 48,
                                        height: 48,
                                        child: Image.asset('images/logo.png')
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user.get("userName"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(Utils.readTimestamp(user.get('catTimeStamp')),style: TextStyle(fontSize: 16,color: Colors.black87),),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right:8.0,left:8.0),
                                              child: Icon(Icons.report),
                                            ),
                                            Text("Report"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    initialValue: 1,
                                    onCanceled: () {
                                      print("You have canceled the menu.");
                                    },
                                    onSelected: (value) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => ReportPost(postUserName: user.get("userName"),postId:user.get("catID"),content:user.get("catDesc"),reporter:uid,));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Category Title",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            user.get("catTitle"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: CachedNetworkImage(
                                    width: size.width,
                                    height: size.height * 0.40,
                                    imageUrl: user.get('postImage'),
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 70,
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Category Description",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      user.get("catDesc"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
            // Handle no data
            return Center(
              child: Text("No Category found."),
            );
          } else {
            // Still loading
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
  else{

    return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categories').orderBy('catTimeStamp',descending: true).snapshots(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = snapshot.data.docs[index];

                      return GestureDetector(
                        onTap: (){
                          _moveToContentDetail(user);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 2,

                          margin: EdgeInsets.all(4),
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () =>{},
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                                        child: Container(
                                            width: 48,
                                            height: 48,
                                            child: Image.asset('images/logo.png')
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(user.get("userName"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(Utils.readTimestamp(user.get('catTimeStamp')),style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      PopupMenuButton<int>(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right:8.0,left:8.0),
                                                  child: Icon(Icons.report),
                                                ),
                                                Text("Report"),
                                              ],
                                            ),
                                          ),
                                        ],
                                        initialValue: 1,
                                        onCanceled: () {
                                          print("You have canceled the menu.");
                                        },
                                        onSelected: (value) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => ReportPost(postUserName: user.get("userName"),postId:user.get("catID"),content:user.get("catDesc"),reporter:uid,));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Category Title",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                user.get("catTitle"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(
                                  height: 150,
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: CachedNetworkImage(
                                        width: size.width,
                                        height: size.height * 0.40,
                                        imageUrl: user.get('postImage'),
                                        placeholder: (context, url) =>
                                            Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      )
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(
                                  height: 70,
                                  child:Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Category Description",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          user.get("catDesc"),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
                // Handle no data
                return Center(
                  child: Text("No Category found."),
                );
              } else {
                // Still loading
                return Center(child: CircularProgressIndicator());
              }
            }
        );
  }
  }


  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(id:data.get("catID"),desc:data.get("catDesc"),title:data.get("catTitle"),
        img: data.get('postImage'), time: data.get("catTimeStamp"), userName: data.get("userName"),
        lang: data.get("catLan"), top: data.get("catTopic"), cou: data.get("catCountry"), like: data.get("catLikeCount"), dislike: data.get("catDisLike"), commentCount: data.get("commentCount"),)));

  }
}

