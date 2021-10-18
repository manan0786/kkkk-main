import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/reply_category.dart';
import 'category_detail.dart';


class CommentCategory extends StatefulWidget{
  final DocumentSnapshot data;
  final Size size;

  final String userName;
  final String id;
  final String id2;
  final ValueChanged<List<String>> replyComment;
  final FocusNode writingTextFocus;

  CommentCategory({this.data,this.size,this.userName, this.id, this.id2, this.replyComment, this.writingTextFocus});
  @override State<StatefulWidget> createState() => _CommentCategory();
}

class _CommentCategory extends State<CommentCategory>{

  bool isLikeComment= false;



   Future<void> likeToComments(bool isLikePost) async{
     await updateCommentLikeCount(isLikePost);
  }

  final TextEditingController _msgTextController = new TextEditingController();



  Future<void> updateCommentLikeCount(bool isLikePost) async{
    CollectionReference students =
    FirebaseFirestore.instance.collection('categories').doc(widget.id).collection("collection");
    students.doc(widget.data["commentLikeCount"]).update({'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});


  }

var i;
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.id)
            .collection('collection').doc("reply").collection(widget.data["commentID"])
            .orderBy('replyTimeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return LinearProgressIndicator();

          return Padding(
            padding: widget.data['toCommentID'] == null ? EdgeInsets.all(8.0) : EdgeInsets.fromLTRB(34.0,8.0,8.0,8.0),
            child: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                      child: Container(
                          width: widget.data['toCommentID'] == null ? 48 : 40,
                          height: widget.data['toCommentID'] == null ? 48 : 40,
                          child: Image.asset('images/user_icon.png')
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(widget.data['toUserID'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:4.0),
                                  child: widget.data['toCommentID'] == null ? Text(widget.data['commentContent'],maxLines: null,) :
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: widget.data['toUserID'], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[800])),
                                        TextSpan(text: widget.data['commentContent'], style: TextStyle(color:Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          width: widget.size.width- (widget.data['toCommentID'] == null ? 90 : 110),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(
                                Radius.circular(15.0)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,top: 4.0),
                          child: Container(
                            width: widget.size.width * 0.38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(Utils.readTimestamp(widget.data['commentTimeStamp'])),
                                GestureDetector(
                                    onTap: () async{
                                      likeToComments(isLikeComment);
                                      print('LIKED');
                                    },
                                    child: Text('Like',
                                        style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
                                ),
                                GestureDetector(
                                    onTap: () async{
                                      widget.writingTextFocus.requestFocus();

                                      _handleSubmitted2();

                                    },
                                    child: Text('Reply',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                widget.data['commentLikeCount'] > 0 ? Positioned(
                  bottom: 10,
                  right:0,
                  child: Card(
                      elevation:2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.thumb_up,size: 14,color: Colors.blue[900],),
                            Text('${widget.data['commentLikeCount']}',style:TextStyle(fontSize: 14)),
                          ],
                        ),
                      )
                  ),
                ) : Container(),
                snapshot.data.docs.length > 0
                    ? ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: Utils.sortDocumentsByComment(
                      snapshot.data.docs)
                      .map((document) {
                    return ReplyCategory(data: document,size: widget.size,userName:widget.userName, id: widget.id,);
                  }).toList(),
                )
                    : Container(),

              ],
            ),
          );
        });

  }
  /*Widget _buildTextComposer() {
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
                onSubmitted: _handleSubmitted2,
                decoration:
                new InputDecoration.collapsed(hintText: "Write a comment"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    _handleSubmitted2(_msgTextController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }*/


   Future<void> commentToPost2(String toUserID,String toCommentID,String catID,String commentContent, String replyID) async{
    String commentID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    FirebaseFirestore.instance.collection('categories').doc(catID).collection('collection').doc(commentID).collection("reply").doc(replyID).set({
      'toUserID':toUserID,
      'replyID':commentID,
      'toreplyID':toCommentID,
      'replyTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'replyContent':commentContent,
    });

  }

  Future<void> _handleSubmitted2() async {
    try {
      if(AuthFormType.anonymous != null){
        String id = "Guest";
        await commentToPost2(id != null ? id : id,widget.data['replyID'] == null ? widget.id.toString() : widget.data['toreplyID'],widget.id.toString(), _msgTextController.text, widget.data["replyID"]);

      }
      else{

        await commentToPost2(widget.id != null ? widget : "User",widget.data['replyID'] == null ? widget.id.toString() : widget.data['toreplyID'],widget.id.toString(), _msgTextController.text,widget.data["replyID"]);

      }



      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }

}