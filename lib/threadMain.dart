import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/contentDetail.dart';
import 'package:flutterthreadexample/subViews/threadItem.dart';

import 'package:flutterthreadexample/writePost.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'commons/utils.dart';


class ThreadMain extends StatefulWidget{
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  User user;
  ThreadMain({this.myData,this.updateMyData, this.user});
  @override State<StatefulWidget> createState() => _ThreadMain();
}

class _ThreadMain extends State<ThreadMain>{
  bool _isLoading = false;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> GetUser() async{
    user = await FirebaseAuth.instance.currentUser;
    print(user);
  }

  void _writePost() {
  /*  if(widget.user.isAnonymous){
      displayToast("Register yourself before posting anything", context);
    }
    else{

    }*/
    Navigator.push(context, MaterialPageRoute(builder: (context) => WritePost(myData: widget.myData,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('thread').orderBy('postTimeStamp',descending: true).snapshots(),
        builder: (context,snapshot) {

          if (!snapshot.hasData) return LinearProgressIndicator();
          return Stack(
            children: <Widget>[
              snapshot.data.docs.length > 0 ?
              ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot data){
                  return ThreadItem(data: data,myData: widget.myData,updateMyDataToMain: widget.updateMyData,threadItemAction: _moveToContentDetail,isFromThread:true,commentCount: data['postCommentCount'],parentContext: context,);
                }).toList(),
              ) : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error,color: Colors.grey[700],
                        size: 64,),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('There is no post',
                          style: TextStyle(fontSize: 16,color: Colors.grey[700]),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  )
                ),
              ),

              Utils.loadingCircle(_isLoading),
            ],
          );
        }
      ),





      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.

    );
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContentDetail(postData: data,myData: widget.myData,updateMyData: widget.updateMyData,)));
  }
}
displayToast(String message,BuildContext context ){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.amber,
      textColor: Colors.white,
      fontSize: 16.0
  );
}