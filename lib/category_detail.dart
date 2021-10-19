import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/post_problem.dart';
import 'commons/const.dart';


class CategoryDetail extends StatefulWidget {

  final DocumentSnapshot postData;
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyDataToMain;



  final String lang;
  final String top;
  final String cou;
  final String id;
  final String desc;
  final String title;
  final String img;
  final int time;
  final String userName;
  final int like;
  final int dislike;
  final int commentCount;

  const CategoryDetail(
      {Key key, this.id, this.desc, this.title, this.img, this.time, this.userName, this.lang, this.cou, this.top, this.like,this.dislike,this.commentCount,this.postData, this.myData, this.updateMyDataToMain})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {

  void _moveToFullImage() =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FullPhoto(
                    imageUrl: widget.postData['postImage'],
                  )));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text('Category Detail'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),

        body: Column(
    children: <Widget>[
    Expanded(
        child: SingleChildScrollView(
        child: Column(
        children: <Widget>[
    Padding(
    padding:
    const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Card(
    color: Colors.white,
    elevation: 2,
    margin: EdgeInsets.all(4),
    child: GestureDetector(
    onTap: () {},
    child: Column(
    children: [
    GestureDetector(
    onTap: () => {},
    child: Row(
    children: <Widget>[
    Padding(
    padding:
    const EdgeInsets.fromLTRB(
    6.0, 2.0, 10.0, 2.0),
    child: Container(
    width: 48,
    height: 48,
    child: Image.asset(
    'images/logo.png')),
    ),
    Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: <Widget>[
    Text(
    "Admin",
    style: TextStyle(
    fontSize: 18,
    fontWeight:
    FontWeight.bold),
    ),
    Padding(
    padding:
    const EdgeInsets.all(
    2.0),
    child: Text(
    Utils.readTimestamp(
    widget.postData["catTimeStamp"]),
    style: TextStyle(
    fontSize: 16,
    color:
    Colors.black87),
    ),
    ),
    ],
    ),
    Spacer(),
    Row(
    children: [
    Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(

    child: Row(
    children: [

    Badge(
    toAnimate: false,
    shape: BadgeShape.square,
    badgeColor:
    Colors.indigoAccent,
    borderRadius:
    BorderRadius.circular(10),
    badgeContent: Text(
    widget.postData["catLan"],
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
    widget.postData["catTopic"],
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
    widget.postData["catCountry"],
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
    SizedBox(
    height: 70,
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
    mainAxisAlignment:
    MainAxisAlignment
        .start,
    crossAxisAlignment:
    CrossAxisAlignment
        .center,
    children: [
    Text(
    "Category Title:",
    style: TextStyle(
    fontSize: 16,
    color: Colors.black,
    ),
    ),
    SizedBox(width:10),
    Text(
    widget.postData["catTitle"],
    style: TextStyle(
    fontWeight:
    FontWeight.bold,
    fontSize: 20,
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
    GestureDetector(
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FullPhoto(
                    imageUrl: widget.postData['postImage'],
                  )));

    },
    child: SizedBox(
    height: 250,
    child: Padding(
    padding:
    EdgeInsets.only(top: 5),
    child: CachedNetworkImage(
    width: size.width,
    height: size.height * 0.40,
    imageUrl:
    widget.postData["postImage"],
    placeholder: (context, url) =>
    Center(
    child:
    CircularProgressIndicator()),
    errorWidget:
    (context, url, error) =>
    Icon(
    Icons.error,
    color: Colors.red,
    ),
    )),
    ),
    ),
    Container(
    height: 1,
    color: Colors.grey[400],
    ),
    SizedBox(
    height: 70,
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
    mainAxisAlignment:
    MainAxisAlignment.start,
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    Text(
    "Category Description",
    style: TextStyle(
    fontSize: 13,
    color: Colors.black,
    ),
    ),
    Text(
    widget.postData["catDesc"],
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
    child:TextButton.icon(onPressed: (){
    _moveToContentDetail();
    }, icon:Icon(Icons.post_add,size: 30,),label:Text("Post a problem", style: TextStyle(fontSize: 20),)),
    ),

    ],
    ),
    ),
    ),

    ],
    ),
    ),
    ],
    ),
    ),
    ),

    ],
    ),
    );
  }


  void _moveToContentDetail() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) =>
        Problem(
          data: widget.postData,
          myData: widget.myData,
          updateMyDataToMain: widget.updateMyDataToMain,
          threadItemAction: _moveToFullImage,
            id:widget.id,desc:widget.desc,title:widget.title,
            img: widget.img, time: widget.time, userName: widget.userName, like: widget.like, dislike: widget.dislike,
          )
    )
    );
  }
}
