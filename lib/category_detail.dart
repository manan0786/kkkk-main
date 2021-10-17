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
const String SITE_KEY = "6LcxU9UcAAAAAFU4gt02_I-y_1k8k97g99QKfgFq";
enum _VerificationStep {
  SHOWING_BUTTON, WORKING, ERROR, VERIFIED
}


class CategoryDetail extends StatefulWidget {
  final AuthFormType authFormType;

  final String id;
  final String desc;
  final String title;
  final String img;
  final int time;
  final String userName;


  const CategoryDetail(
      {Key key, this.id, this.desc, this.title, this.img, this.time, this.userName,this.authFormType})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  int like = 0;
  int dislike =0;
  // Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;

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

  void _moveToFullImage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullPhoto(
                imageUrl: widget.img,
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
                                              PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Icon(
                                                              Icons.report),
                                                        ),
                                                        Text("Report"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                initialValue: 1,
                                                onCanceled: () {
                                                  print(
                                                      "You have canceled the menu.");
                                                },
                                                onSelected: (value) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Category Title",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.title.toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        GestureDetector(
                                          onTap: () => _moveToFullImage,
                                          child: SizedBox(
                                            height: 150,
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
                                                  CrossAxisAlignment.center,
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
                                        Divider(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:6.0,bottom: 2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              GestureDetector(

                                                onTap: () {
                                                  _startVerification();

                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    //   Icon(Icons.thumb_up,size: 18,color:  widget.myData.myLikeList.contains(widget.data['postID'])==true &&isDisabled==false? Colors.blue[900] : Colors.black),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Text('Like ($like)',
                                                        style: TextStyle(fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blue[900]),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {

                                                },


                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.thumb_down,size: 18,color:Colors.black),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Text('Dislike ($dislike)',
                                                        style: TextStyle(fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color:Colors.black),),

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
                                                      child: Text('Comment (1)',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                                         return CommentCategory(data: document,size: size);
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
     }
     else{
       await FBCloudStore.commentToPost(_replyUserID == null ? "User" : _replyUserID,_replyCommentID == null ? widget.id.toString() : _replyCommentID,widget.id.toString(), _msgTextController.text);
     }
    //  await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }
}
