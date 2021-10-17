import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'category_detail.dart';
import 'commons/const.dart';
import 'commons/utils.dart';




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
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
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

                    Checkbox(
                      value: this.value1,
                      onChanged: (bool value) {
                        setState(() {
                          this.value1 = value;
                        });
                      },
                    ),
                    Text("All",style: TextStyle(color:Colors.white),),
                    Checkbox(
                      value: this.value2,
                      onChanged: (bool value) {
                        setState(() {
                          this.value2 = value;
                        });
                      },
                    ),
                    Text("Language",style: TextStyle(color:Colors.white),),
                    Checkbox(
                      value: this.value3,
                      onChanged: (bool value) {
                        setState(() {
                          this.value3 = value;
                        });
                      },
                    ),
                    Text("Country",style: TextStyle(color:Colors.white),),
                    Checkbox(
                      value: this.value4,
                      onChanged: (bool value) {
                        setState(() {
                          this.value4 = value;
                        });
                      },
                    ),
                    Text("Topic",style: TextStyle(color:Colors.white),),

                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height:10),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categories').orderBy('catTimeStamp',descending: true).snapshots(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = snapshot.data.docs[index];

                      return Card(
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
                              Divider(height: 2,color: Colors.black,),
                              Padding(
                                padding: const EdgeInsets.only(top:6.0,bottom: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                  TextButton.icon(onPressed: (){
                                    _moveToContentDetail(user);
                                  }, icon:Icon(Icons.post_add),label:Text("Post a problem")),
                                  TextButton.icon(onPressed: (){}, icon:Icon(Icons.question_answer),label: Text("Post a solution"))
                                  ],
                                ),
                              ),
                            ],
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
        ),
      ],
    );

  }
  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(id:data.get("catID"),desc:data.get("catDesc"),title:data.get("catTitle"),
        img: data.get('postImage'), time: data.get("catTimeStamp"), userName: data.get("userName"),)));

  }
}
