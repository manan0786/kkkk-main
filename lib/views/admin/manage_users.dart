import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'new_user.dart';
class ManageUsers extends StatefulWidget {
  const ManageUsers({Key key}) : super(key: key);

  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  /*    DECLARE  VARIABLES    */
  final Stream<QuerySnapshot> user=FirebaseFirestore.instance.collection('users').snapshots();
  bool isactive = true;
////////////////////////////////////////////////////
  /*     REFERENCES TO FIRESTORE DB      */
  CollectionReference users = FirebaseFirestore.instance.collection('users');

////////////////////////////////////////////////////
/*     USERS      */
  //Add User
  Future<void> addUser() {

  }

  //Updating User
  Future<void> updateUser(id, name) {
    return users
        .doc(id)
        .update({'name': name})
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'User Data Updated',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Failed to update user data',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        centerTitle: true,
        actions: [
        IconButton(onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => NewUser(),
          ),
          );
        }, icon:Icon(Icons.add) )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Users",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: user,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Internal Server Error',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List storedocs = [];
                    snapshot.data.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      storedocs.add(a);
                      a['id'] = document.id;
                    }).toList();

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            3: FixedColumnWidth(100),
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    color: Colors.indigoAccent,
                                    child: Center(
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    color: Colors.indigoAccent,
                                    child: Center(
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    color: Colors.indigoAccent,
                                    child: Center(
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    color: Colors.indigoAccent,
                                    child: Center(
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var i = 0; i < storedocs.length; i++) ...[
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                        child: Text(storedocs[i]['name'],
                                            style: TextStyle(fontSize: 16.0))),
                                  ),
                                  TableCell(
                                    child: Center(
                                        child: Text(storedocs[i]['email'],
                                            style: TextStyle(fontSize: 14.0))),
                                  ),
                                  TableCell(
                                    child: Center(

                                      child: Badge(
                                        toAnimate: false,
                                        shape: BadgeShape.square,
                                        badgeColor: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                        badgeContent: Text(storedocs[i]['active'].toString() , style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () => {

                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => {


                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}


