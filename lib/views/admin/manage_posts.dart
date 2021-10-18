import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/views/admin/updatepost.dart';


class ManagePosts extends StatefulWidget {
  const ManagePosts({Key key}) : super(key: key);

  @override
  _ManagePostsState createState() => _ManagePostsState();
}

class _ManagePostsState extends State<ManagePosts> {
  // For Deleting User
  CollectionReference posts =
  FirebaseFirestore.instance.collection('categories');
  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return posts
        .doc(id)
        .delete()
        .then((value) => print('Post Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('View Categories'),
          centerTitle: true,
        ),
        body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot user = snapshot.data.docs[index];

            return Card(
              color: Colors.white,
              elevation: 6,
              margin: EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: [
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
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(

                                  child: Row(
                                    children: [
                                      Text(
                                        "Filters",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Badge(
                                        toAnimate: false,
                                        shape: BadgeShape.square,
                                        badgeColor:
                                        Colors.indigoAccent,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        badgeContent: Text(
                                            user.get("catLan"),
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                      SizedBox(width: 3,),
                                      Badge(
                                        toAnimate: false,
                                        shape: BadgeShape.square,
                                        badgeColor:
                                        Colors.indigoAccent,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        badgeContent: Text(
                                            user.get("catTopic"),
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                      SizedBox(width: 3,),
                                      Badge(

                                        toAnimate: false,
                                        shape: BadgeShape.square,
                                        badgeColor:
                                        Colors.indigoAccent,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        badgeContent: Text(
                                            user.get("catCountry"),
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                      IconButton(
                                        onPressed: () async{
                                          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                            await myTransaction.delete(snapshot.data.docs[index].reference);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
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
                            height: size.height * 0.20,
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
                    Container(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    /*SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePost(
                                      id: snapshot.data.docs[index].id),
                                ),
                              )
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.orange,
                              size: 30,
                            ),
                          ),

                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            );
          },
        );
      }
      else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
      // Handle no data
      return Center(
      child: Text("No Data found."),
      );
      } else {
      // Still loading
      return CircularProgressIndicator();
      }
    }
    ),
    );
    }
  }
