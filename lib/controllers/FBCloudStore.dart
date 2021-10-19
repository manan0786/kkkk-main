import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudMessaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore{
  static Future<void> sendPostInFirebase(String postID,String postContent,MyProfileData userProfile,String postImageURL) async{

    FirebaseFirestore.instance.collection('thread').doc(postID).set({
      'postID':postID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'postTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'postContent':postContent,
      'postImage':postImageURL,
      'postDisLikeCount':0,
      'postLikeCount':0,
      'postCommentCount':0,
    });
  }

  static Future<void> sendCategoryInFirebase(String catID,String catTitle,String catDesc,String catLang,String catCountry,String catTopic,String catImageURL, int catDisLike, int catLikeCount, int commentCount) async{

    FirebaseFirestore.instance.collection('categories').doc(catID).set({
      'catID':catID,
      'userName':"Admin",
      'catTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'catTitle':catTitle,
      'catDesc' :catDesc,
      'catLan':catLang,
      'catCountry':catCountry,
      'catTopic':catTopic,
      'postImage':catImageURL,
      'catDisLike': 0,
      'catLikeCount': 0,
      'commentCount': 0

    });
  }

  static Future<void> sendReportUserToFB(context,String reason, String userName,String postId,String content,String reporter) async{
    try {
      FirebaseFirestore.instance.collection('report').doc().set({
        'reason': reason,
        'author': userName,
        'postId':postId,
        'content':content,
        'reporter':reporter
      });
    }catch(e) {
      print('Report post error');
    }
  }

  static Future<void> likeToPost(String postID,MyProfileData userProfile,bool isLikePost) async{
    if (isLikePost) {
      DocumentReference likeReference = FirebaseFirestore.instance.collection('categories').doc(postID).collection('like').doc(userProfile.myName);
      await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(likeReference);
      });
    }else {
      await FirebaseFirestore.instance.collection('categories').doc(postID).collection('like').doc(userProfile.myName).set({
        'userName':userProfile.myName,
        'userThumbnail':userProfile.myThumbnail,
      });
    }
  }
  static Future<void> dislikeToPost(String postID,MyProfileData userProfile,bool isDisLikePost) async{
    if (isDisLikePost) {
      DocumentReference dislikeReference = FirebaseFirestore.instance.collection('thread').doc(postID).collection('dislike').doc(userProfile.myName);
      await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(dislikeReference);
      });
    }else {
      await FirebaseFirestore.instance.collection('thread').doc(postID).collection('dislike').doc(userProfile.myName).set({
        'userName':userProfile.myName,
        'userThumbnail':userProfile.myThumbnail,
      });
    }
  }

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,bool isLikePost,MyProfileData myProfileData) async{
    postData.reference.update({'catLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});

  }
  static Future<void> updatePostDisLikeCount(DocumentSnapshot postData,bool isDisLikePost,MyProfileData myProfileData) async{
    postData.reference.update({'catDisLike': FieldValue.increment(isDisLikePost ? -1 : 1)});
    if(!isDisLikePost){
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser('${myProfileData.myName} dislikes your post','${myProfileData.myName}',postData['FCMToken']);
    }
  }

  static Future<void> updatePostCommentCount(DocumentSnapshot postData,) async{
    postData.reference.update({'commentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,bool isLikePost,MyProfileData myProfileData) async{
    postData.reference.update({'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});

  }
  static Future<void> updateCommentdisLikeCount(DocumentSnapshot postData,bool isLikePost,MyProfileData myProfileData) async{
    postData.reference.update({'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if(!isLikePost){
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser('${myProfileData.myName} likes your comment','${myProfileData.myName}',postData['FCMToken']);
    }
  }

  static Future<void> commentToPost(String toUserID,String toCommentID,String catID,String commentContent) async{
    String commentID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    FirebaseFirestore.instance.collection('categories').doc(catID).collection('comment').doc(commentID).set({
      'toUserID':toUserID,
      'commentID':commentID,
      'toCommentID':toCommentID,
      'commentTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'commentContent':commentContent,
      'commentLikeCount':0,
    });

  }
}