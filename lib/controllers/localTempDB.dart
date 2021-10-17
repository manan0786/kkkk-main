
import 'package:shared_preferences/shared_preferences.dart';

class LocalTempDB{
  static Future<List<String>> saveLikeList(String postID,List<String> myLikeList,bool isLikePost,String updateType) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newLikeList = myLikeList;
    if(myLikeList == null) {
      newLikeList = List<String>();
      newLikeList.add(postID);
    }else {
      if (isLikePost) {
        myLikeList.remove(postID);
      }else {
        myLikeList.add(postID);
      }
    }
    prefs.setStringList(updateType, newLikeList);
    return newLikeList;
  }
  static Future<List<String>> saveDisLikeList(String postID,List<String> myDisLikeList,bool isDisLikePost,String updateType) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newDisLikeList = myDisLikeList;
    if(myDisLikeList == null) {
      newDisLikeList = List<String>();
      newDisLikeList.add(postID);
    }else {
      if (isDisLikePost) {
        myDisLikeList.remove(postID);
      }else {
        myDisLikeList.add(postID);
      }
    }
    prefs.setStringList(updateType, newDisLikeList);
    return newDisLikeList;
  }

}