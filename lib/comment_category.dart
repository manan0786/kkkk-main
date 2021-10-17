import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';

import 'package:flutterthreadexample/commons/utils.dart';

class CommentCategory extends StatefulWidget{
  final DocumentSnapshot data;

  final Size size;

  CommentCategory({this.data,this.size,});
  @override State<StatefulWidget> createState() => _CommentCategory();
}

class _CommentCategory extends State<CommentCategory>{

/*  MyProfileData _currentMyData;
  @override
  void initState() {
    _currentMyData = widget.myData;
    super.initState();
  }
  void _updateLikeCount(bool isLikePost) async{
    MyProfileData _newProfileData = await Utils.updateLikeCount(widget.data,isLikePost,widget.myData,widget.updateMyDataToMain,false);
    setState(() {
      _currentMyData = _newProfileData;
    });
  }*/

  @override
  Widget build(BuildContext context) {
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
                                 // TextSpan(text: widget.data['toUserID'], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[800])),
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
                              onTap: () => {},
                              child: Text('Like',
                                  style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
                          ),
                          GestureDetector(
                              onTap: (){},
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
        ],
      ),
    );
  }
}