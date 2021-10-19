import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/comment_category.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/subViews/categoryItem.dart';

import 'commons/const.dart';


class Problem extends StatefulWidget {
  final MyProfileData myData;
  final DocumentSnapshot data;
  final ValueChanged<MyProfileData> updateMyDataToMain;
  final Function threadItemAction;

  final String id;
  final String desc;
  final String title;
  final String img;
  final int time;
  final String userName;
  final int like;
  final int dislike;


  const Problem(
      {Key key,this.data,this.myData, this.updateMyDataToMain,this.threadItemAction, this.id, this.desc, this.title, this.img, this.time, this.userName, this.like, this.dislike,})
      : super(key: key);

  @override
  _ProblemState createState() => _ProblemState();
}

class _ProblemState extends State<Problem> {
  final TextEditingController _msgTextController = new TextEditingController();
  MyProfileData currentMyData;
  String _replyUserID;
  String _replyCommentID;
  FocusNode _writingTextFocus = FocusNode();

  @override
  void initState() {
    currentMyData = widget.myData;
    _msgTextController.addListener(_msgTextControllerListener);
    super.initState();
  }

  void _msgTextControllerListener(){
    if(_msgTextController.text.length == 0 || _msgTextController.text.split(" ")[0] != _replyUserID) {
      _replyUserID = null;
      _replyCommentID = null;
    }
  }

  void _replyComment(List<String> commentData) async{//String replyTo,String replyCommentID,String replyUserToken) async {
    _replyUserID = commentData[0];
    _replyCommentID = commentData[1];
    FocusScope.of(context).requestFocus(_writingTextFocus);
    _msgTextController.text = '${commentData[0]} ';
  }

  void _moveToFullImage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullPhoto(
            imageUrl: widget.data['postImage'],
          )));



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
                .collection('comment')
                .orderBy('commentTimeStamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

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

                                CategoryItem(data: widget.data,myData: widget.myData,updateMyDataToMain: widget.updateMyDataToMain,threadItemAction: _moveToFullImage,isFromThread:false,commentCount: snapshot.data.docs.length,parentContext: context,),
                                snapshot.data.docs.length > 0
                                    ? ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                 /* children: Utils.sortDocumentsByComment(snapshot.data.docs).map((document) {
                                    return CommentCategory(data: document,myData: widget.myData,size: size,updateMyDataToMain: widget.updateMyDataToMain,replyComment: _replyComment);
                                  }).toList(),*/
                                  children: (snapshot.data.docs).map((document) {
                                    return CommentCategory(data: document,myData: widget.myData,size: size,updateMyDataToMain: widget.updateMyDataToMain,replyComment: _replyComment);
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
        await FBCloudStore.updatePostCommentCount(widget.data);

      }
      else{
        await FBCloudStore.commentToPost(_replyUserID == null ? widget.myData.myName : _replyUserID,_replyCommentID == null ? widget.id.toString() : _replyCommentID,widget.id.toString(), _msgTextController.text);
        await FBCloudStore.updatePostCommentCount(widget.data);
      }

      //  await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }
/*  Future<void> _handleSubmitted(String text) async {

    try{
    if(AuthFormType.anonymous != null){
      String id = "Guest";
      await FBCloudStore.commentToPost(_replyUserID == null ? id : _replyUserID,_replyCommentID == null ?  widget.data['commentID'].toString() : _replyCommentID, widget.data['catID'].toString(), _msgTextController.text);
     await FBCloudStore.updatePostCommentCount(widget.data);

    }
    else{
      await FBCloudStore.commentToPost(_replyUserID == null ? widget.myData.myName: _replyUserID,_replyCommentID == null ?  widget.data['commentID'].toString(): _replyCommentID, widget.data['catID'].toString(), _msgTextController.text);
      await FBCloudStore.updatePostCommentCount(widget.data);

    }
    FocusScope.of(context).requestFocus(FocusNode());
    _msgTextController.text = '';
  }catch(e){
  print('error to submit comment');
  }


  }*/

}
