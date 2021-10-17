import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ManagePosts extends StatefulWidget {
  const ManagePosts({Key key}) : super(key: key);

  @override
  _ManagePostsState createState() => _ManagePostsState();
}

class _ManagePostsState extends State<ManagePosts> {
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
