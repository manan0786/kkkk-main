import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/views/admin/postadmin.dart';
import 'package:flutterthreadexample/widgets/category_card.dart';
import 'package:flutterthreadexample/widgets/search_bar.dart';

import '../../loginScreen.dart';
import 'manage_posts.dart';
import 'manage_users.dart';
class Admin extends StatefulWidget {
  final MyProfileData myData;
  const Admin({Key key,this.myData}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Colors.indigo,

            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("images/menu.svg",width: 20,height: 20,),
                    ),
                  ),
                  Text(
                    "Welcome \nadmin",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w700,color: Colors.white),
                  ),
                  SearchBar(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Create Category",
                          svgSrc: "images/add.png",
                          press: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPost(),
                              ),
                            );

                          },
                        ),
                        CategoryCard(
                          title: "View Categories",
                          svgSrc: "images/view.png",
                          press: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => ManagePosts(),
                            ),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Manage Users",
                          svgSrc: "images/users.png",
                          press: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => ManageUsers(),
                            ),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Logout",
                          svgSrc: "images/logout.png",
                          press: () => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                    (route) => false)
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
