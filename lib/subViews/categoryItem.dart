
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_grecaptcha/f_grecaptcha.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';

enum AuthFormType { anonymous }

const String SITE_KEY = "6LdlVtgcAAAAADsdaa89qQEWX5yRctTiZC7PB3-T";
enum _VerificationStep {
  SHOWING_BUTTON,
  WORKING,
  ERROR,
  VERIFIED
}

class CategoryItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyDataToMain;
  final bool isFromThread;
  final Function threadItemAction;
  final int commentCount;
  const CategoryItem({Key key,this.data,this.myData,this.updateMyDataToMain,this.threadItemAction,this.isFromThread,this.commentCount,this.parentContext}) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
// Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;
  AuthFormType authFormType;
  _CategoryItemState({this.authFormType});

  void _startVerification() {
    setState(() => _step = _VerificationStep.WORKING);

    FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
      setState(() {
        _step = _VerificationStep.VERIFIED;
        _updateLikeCount(_currentMyData.myLikeList != null && _currentMyData.myLikeList.contains(widget.data['catID']) ? true : false);
        setState(() {
          isLoading = false;

        });
      });
    }, onError: (e, s) {
      print("Could not verify:\n$e at $s");
      setState(() => _step = _VerificationStep.ERROR);
    });
  }
  bool isLoading = false;

  MyProfileData _currentMyData;
  int _likeCount;
  @override
  void initState() {
    _currentMyData = widget.myData;
    _likeCount = widget.data['catLikeCount'];
    super.initState();
  }

  void _updateLikeCount(bool isLikePost) async{
    MyProfileData _newProfileData = await Utils.updateLikeCount(widget.data,widget.myData.myLikeList != null && widget.myData.myLikeList.contains(widget.data['catID']) ? true : false,widget.myData,widget.updateMyDataToMain,true);
    setState(() {
      _currentMyData = _newProfileData;
    });
    setState(() {
      isLikePost ? _likeCount-- : _likeCount++;
    });
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return  Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>  widget.isFromThread ? widget.threadItemAction(widget.data) : widget.threadItemAction(),
              child: SizedBox(
                height: 250,
                child: Padding(
                    padding:
                    EdgeInsets.only(top: 5),
                    child: CachedNetworkImage(
                      width: size.width,
                      height: size.height * 0.40,
                      imageUrl:
                      widget.data["postImage"],
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
                      widget.data["catTitle"],
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
                  widget.data["catDesc"],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (AuthFormType.anonymous != null) {
                        _startVerification();
                        setState(() {
                          isLoading = true;
                        });
                      }
                      else{
                        _updateLikeCount(_currentMyData.myLikeList != null && _currentMyData.myLikeList.contains(widget.data['catID']) ? true : false);
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.thumb_up,size: 18,color: widget.myData.myLikeList != null && widget.myData.myLikeList.contains(widget.data['catID']) ? Colors.blue[900] : Colors.black),
                        isLoading? CircularProgressIndicator(): Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text('Like ( ${widget.isFromThread ? widget.data['catLikeCount'] : _likeCount} )',
                            style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.myData.myLikeList != null && widget.myData.myLikeList.contains(widget.data['catID']) ? Colors.blue[900] : Colors.black),),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.isFromThread ? widget.threadItemAction(widget.data) : null,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.mode_comment,size: 18),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text('Comment ( ${widget.commentCount} )',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
    );
  }
}
