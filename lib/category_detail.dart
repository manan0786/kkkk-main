import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_grecaptcha/f_grecaptcha.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/comment_category.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/post_problem.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AuthFormType { anonymous }
const String SITE_KEY = "6LcxU9UcAAAAAFU4gt02_I-y_1k8k97g99QKfgFq";
enum _VerificationStep {
  SHOWING_BUTTON, WORKING, ERROR, VERIFIED
}


class CategoryDetail extends StatefulWidget {
  final AuthFormType authFormType;
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
      {Key key, this.id, this.desc, this.title, this.img, this.time, this.userName,this.authFormType, this.lang, this.cou, this.top, this.like,this.dislike,this.commentCount})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  int like = 0;
  int dislike =0;

  // Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;
  DocumentSnapshot data;
  void _startVerification() {
    setState(() => _step = _VerificationStep.WORKING);

    FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
      setState(() {
        _step = _VerificationStep.VERIFIED;

      });

    }, onError: (e, s) {
      print("Could not verify:\n$e at $s");
      setState(() => _step = _VerificationStep.ERROR);
    });
  }
  AuthFormType authFormType;
  _CategoryDetailState({this.authFormType});
  FocusNode _writingTextFocus = FocusNode();
  final TextEditingController _msgTextController = new TextEditingController();
  String _replyUserID;
  String _replyCommentID;
  String uid;

  GetUser()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    uid= prefs.getString("uid");
    print(uid);
  }
  @override
  void initState() {
    //currentMyData = widget.myData;
    _msgTextController.addListener(_msgTextControllerListener);
    GetUser();
    super.initState();
  }

  void _msgTextControllerListener() {
    if (_msgTextController.text.length == 0 ||
        _msgTextController.text.split(" ")[0] != _replyUserID) {
      _replyUserID = null;
      _replyCommentID = null;
    }
  }

  void _replyComment(List<String> commentData) async{
    _replyUserID = commentData[0];
    _replyCommentID = commentData[1];
    FocusScope.of(context).requestFocus(_writingTextFocus);
    _msgTextController.text = '${commentData[0]} ';
  }

  void _moveToFullImage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullPhoto(
                imageUrl: widget.img,
              )));
var Id;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
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
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc(widget.id)
                .collection('collection')
                .orderBy('commentTimeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) return LinearProgressIndicator();
              QuerySnapshot documents = snapshot.data;
              List<DocumentSnapshot> docs = documents.docs;
              docs.forEach((data) {
               Id = data.id;
               print(Id);
              });
              return Column(
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
                                                          widget.time),
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
                                                                widget.lang,
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
                                                                widget.top,
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
                                                                widget.cou,
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
                                                  widget.title.toString(),
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
                                          onTap: () => _moveToFullImage,
                                          child: SizedBox(
                                            height: 250,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: CachedNetworkImage(
                                                  width: size.width,
                                                  height: size.height * 0.40,
                                                  imageUrl:
                                                      widget.img.toString(),
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
                                                  widget.desc.toString(),
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
              );
            }));
  }


  void _moveToContentDetail() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => Problem(id:widget.id,desc:widget.desc,title:widget.title,
      img: widget.img, time: widget.time, userName: widget.userName, like: widget.like, dislike: widget.dislike, commentCount: widget.commentCount, Id: Id, replyComment:_replyComment)));

  }
}
