import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'category_detail.dart';


class ReplyCategory extends StatefulWidget{
  final DocumentSnapshot data;
  final Size size;

  final String userName;
  final String id;

  ReplyCategory({this.data,this.size,this.userName, this.id});
  @override State<StatefulWidget> createState() => _ReplyCategory();
}

class _ReplyCategory extends State<ReplyCategory>{

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: widget.data['toreplyID'] == null ? EdgeInsets.all(8.0) : EdgeInsets.fromLTRB(34.0,8.0,8.0,8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                child: Container(
                    width: widget.data['toreplyID'] == null ? 48 : 40,
                    height: widget.data['toreplyID'] == null ? 48 : 40,
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
                            child: widget.data['toreplyID'] == null ? Text(widget.data['replyContent'],maxLines: null,) :
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: widget.data['toUserID'], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[800])),
                                  TextSpan(text: widget.data['replyContent'], style: TextStyle(color:Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: widget.size.width- (widget.data['toreplyID'] == null ? 90 : 110),
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
                          Text(Utils.readTimestamp(widget.data['replyTimeStamp'])),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),



        ],
      ),
    );
  }


}