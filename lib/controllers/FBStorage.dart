import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FBStorage {
  static Future<String> uploadPostImages({@required String postID,@required File postImageFile}) async {
    try {

      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage
          .ref()
          .child("images/posts/$postID/postImages")
          .putFile(postImageFile);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl =
        await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }

    }
    catch(e) {
      return null;
    }
  }

  static Future<String> uploadCategoryImages({@required String catID,@required File catImageFile}) async {
    try {

      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage
          .ref()
          .child("images/categories/$catID/categoryImages")
          .putFile(catImageFile);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl =
        await snapshot.ref.getDownloadURL();
        return downloadUrl;
    }

    }catch(e) {
      return null;
    }
  }
}