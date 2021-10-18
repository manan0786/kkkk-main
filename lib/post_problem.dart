import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_grecaptcha/f_grecaptcha.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/comment_category.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AuthFormType { anonymous }
const String SITE_KEY = "6LdlVtgcAAAAADsdaa89qQEWX5yRctTiZC7PB3-T";
enum _VerificationStep {
  SHOWING_BUTTON, WORKING, ERROR, VERIFIED
}


class Problem extends StatefulWidget {
  final AuthFormType authFormType;
  final String id;
  final String desc;
  final String title;
  final String img;
  final int time;
  final String userName;
  final int like;
  final int dislike;
  final int commentCount;
  final ValueChanged<List<String>> replyComment;
  final String Id;
  const Problem(
      {Key key, this.id, this.desc, this.title, this.img, this.time, this.userName,this.authFormType, this.like, this.dislike, this.commentCount, this.replyComment, this.Id})
      : super(key: key);

  @override
  _ProblemState createState() => _ProblemState();
}

class _ProblemState extends State<Problem> {

  bool isDisabled;
  DocumentSnapshot postData;
  bool isLoading = false;
  bool isLoading2 = false;

  int mylikeCount;
  int _likeCount;
  int _DislikeCount;
  bool isDisabled1;

  String uid;
  bool isLikePost1 = false;
  bool isDisLikePost = false;

   Future<void> dislikeToPost2(String postID,bool isDisLikePost) async{
     await updatePostDisLikeCount2(data,isDisLikePost);
  }

  Future<void> updatePostDisLikeCount2(DocumentSnapshot postData,bool isDisLikePost) async{

    CollectionReference students =
    FirebaseFirestore.instance.collection('categories');

    students.doc(widget.id).update({'catDisLike': FieldValue.increment(isDisLikePost ? -1 : 1)});


  }

  void _updateDisLikeCount(bool isDisLikePost) async{
    setState(() {
      if(isDisLikePost){
        isDisabled1=true;
        _DislikeCount--;
      }else{
        isDisabled1=false;
        _DislikeCount++;
      }

    });
  }


  // Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;
  DocumentSnapshot data;


  void _startVerification() {
    setState(() => _step = _VerificationStep.WORKING);

    FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
      setState(() async{
        _step = _VerificationStep.VERIFIED;

        await likeToPost2(uid,isLikePost1);

        setState(() {
          isLoading = false;

        });


      });

    }, onError: (e, s) {
      print("Could not verify:\n$e at $s");
      setState(() => _step = _VerificationStep.ERROR);
    });
  }

  void _startVerification2() {
    setState(() => _step = _VerificationStep.WORKING);

    FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
      setState(() async{
        _step = _VerificationStep.VERIFIED;
 await dislikeToPost2(uid,isLikePost);
        setState(() {
          isLoading2 = false;
        });
      });


    }, onError: (e, s) {
      print("Could not verify:\n$e at $s");
      setState(() => _step = _VerificationStep.ERROR);
    });
  }


  AuthFormType authFormType;
  _ProblemState({this.authFormType});
  FocusNode _writingTextFocus = FocusNode();
  final TextEditingController _msgTextController = new TextEditingController();
  String _replyUserID;
  String _replyCommentID;

  DocumentReference likeRef;
  CollectionReference catRef;
  bool isLikePost = false;



  Future<void> likeToPost2(String postID,bool isLikePost) async{

    await updatePostLikeCount2(data,isLikePost);
  }
  Future<void> updatePostLikeCount2(DocumentSnapshot postData,bool isLikePost) async{

    CollectionReference students =
    FirebaseFirestore.instance.collection('categories');

    students.doc(widget.id).update({'catLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    _updateLikeCount(isLikePost);
  }
  void _updateLikeCount(bool isLikePost) async{
    setState(() {
      if(isLikePost){
        isDisabled=true;
        _likeCount--;
      }else{
        isDisabled=false;
        _likeCount++;
      }


    });

  }

  GetUser()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    uid= prefs.getString("uid");
    print(uid);
  }
  void _replyComment(List<String> commentData) async{//String replyTo,String replyCommentID,String replyUserToken) async {
    _replyUserID = commentData[0];
    _replyCommentID = commentData[1];
    FocusScope.of(context).requestFocus(_writingTextFocus);
    _msgTextController.text = '${commentData[0]} ';
  }
  @override
  void initState() {
    //currentMyData = widget.myData;
    likeRef = FirebaseFirestore.instance.collection('likesCategory').doc(uid);
    _msgTextController.addListener(_msgTextControllerListener);


    GetUser();
    super.initState();

    _likeCount = widget.like;
    _DislikeCount = widget.dislike;

  }

  void _msgTextControllerListener() {
    if (_msgTextController.text.length == 0 ||
        _msgTextController.text.split(" ")[0] != _replyUserID) {
      _replyUserID = null;
      _replyCommentID = null;
    }
  }

  void _moveToFullImage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullPhoto(
            imageUrl: widget.img,
          )));

var userName;
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
          title: Text('Post Problem'),
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

                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(
                                          height: 70,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:   Text(
                                              widget.desc.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(height: 2,color: Colors.black,),
                                        Padding(
                                          padding: const EdgeInsets.only(top:6.0,bottom: 2.0),
                                          child:Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                GestureDetector(

                                                  onTap: () async{
                                           if (AuthFormType.anonymous != null) {
                                             _startVerification();
                                             if(isDisabled1==true||isDisabled1==null){
                                               _updateLikeCount(widget.id != null
                                                   ? true
                                                   : false);
                                               print(isDisabled);}
                                             setState(() {
                                               isLoading = true;
                                             });
                                           }
                                           else{
                                             await likeToPost2(uid,isLikePost);
                                             if(isDisabled1==true||isDisabled1==null){
                                               _updateLikeCount(widget.id != null
                                                   ? true
                                                   : false);
                                               print(isDisabled);}
                                           }

                                                  },

                                                 child: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.thumb_up,size: 18,color:  widget.id != null &&isDisabled==false? Colors.blue[900] : Colors.black),
                                                      isLoading? CircularProgressIndicator():Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Text('Like ( ${widget.like != null? widget.like : _likeCount} )',
                                                          style: TextStyle(fontSize: 16,
                                                              fontWeight: FontWeight.bold,

                                                              color: widget.id != null&&isDisabled==false? Colors.blue[900] : Colors.black),),
                                                      ),
                                                    ]
                                                  )
                                                ),


                                                GestureDetector(
                                                  onTap: () async{
                                                    if (AuthFormType.anonymous != null) {
                                                      _startVerification2();
                                                      if(isDisabled==true||isDisabled==null) {
                                                        _updateDisLikeCount(widget.id != null
                                                            ? true
                                                            : false);
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                      }
                                                    }
                                                    else{
                                                      await dislikeToPost2(uid,isDisLikePost);
                                                      if(isDisabled==true||isDisabled==null) {
                                                        _updateDisLikeCount(widget.id != null
                                                            ? true
                                                            : false);
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                      }
                                                    }
                                                  },


                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.thumb_down,size: 18,color: widget.id != null &&isDisabled1==false? Colors.blue[900] : Colors.black),
                                                      isLoading2? CircularProgressIndicator():Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Text('Dislike (${widget.id !=null ? widget.dislike : _DislikeCount})',
                                                          style: TextStyle(fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color:widget.id != null&&isDisabled1==false? Colors.blue[900] : Colors.black),),

                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => {},
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.mode_comment,size: 18),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Text('Comment (${widget.commentCount})',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                snapshot.data.docs.length > 0
                                    ? ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  children: Utils.sortDocumentsByComment(
                                      snapshot.data.docs)
                                      .map((document) {
                                    return CommentCategory(data: document,size: size,userName:userName, id: widget.id, id2: Id, replyComment: widget.replyComment, writingTextFocus: _writingTextFocus);
                                  }).toList(),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildTextComposer()
                ],
              );
            }));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                focusNode: _writingTextFocus,
                controller: _msgTextController,
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Write a comment"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    _handleSubmitted(_msgTextController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _handleSubmitted(String text) async {
    try {
      if(AuthFormType.anonymous != null){
        String id = "Guest";
        await FBCloudStore.commentToPost(_replyUserID == null ? id : _replyUserID,_replyCommentID == null ? widget.id.toString() : _replyCommentID,widget.id.toString(), _msgTextController.text);
        // Updaing Count
        CollectionReference students =
        FirebaseFirestore.instance.collection('categories');

        students.doc(widget.id).update({'commentCount': FieldValue.increment(1)});
        setState(() {

        });

      }
      else{
        await FBCloudStore.commentToPost(_replyUserID == null ? uid.trim() : _replyUserID,_replyCommentID == null ? widget.id.toString() : _replyCommentID,widget.id.toString(), _msgTextController.text);
        // Updaing Count
        CollectionReference students =
        FirebaseFirestore.instance.collection('categories');
        students.doc(widget.id).update({'commentCount': FieldValue.increment(1)});
        setState(() {

        });
      }

      //  await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }

}
