import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/controllers/FBStorage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'filters_add.dart';

class UpdatePost extends StatefulWidget {
  final String id;
  UpdatePost({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UpdatePostPost();
}

class _UpdatePostPost extends State<UpdatePost> {

  TextEditingController writingTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController langTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  TextEditingController topicTextController = TextEditingController();

  var selectedLanguage, selectedCountry, selectedTopic;
  final _formKey = GlobalKey<FormState>();


  // Updaing Student
  CollectionReference students =
  FirebaseFirestore.instance.collection('categories');

  Future<void> updateUser(id, catDesc, catTitle, postImage, catLng, catCountry, catTopic) {
    return students
        .doc(id)
        .update({'catDesc': catDesc, 'catTitle': catTitle, 'postImage': postImage, 'catLan': catLng, 'catCountry': catCountry, 'catTopic': catTopic})
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Updated',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ))
        .catchError((error) => print("Failed to update user: $error"));
  }

  bool _isLoading = false;
  File _postImageFile;
  void _postToFB() async {

    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if(_postImageFile != null){
      postImageURL = await FBStorage.uploadCategoryImages(catID: postID, catImageFile: _postImageFile);
      print(postImageURL);
    }
    FBCloudStore.sendCategoryInFirebase(postID,writingTextController.text,descTextController.text,selectedLanguage,
        selectedCountry,selectedTopic,postImageURL ?? 'NONE', 0, 0,0);
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Category Added Successfully',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    print(id);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Update Category'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.id)
            .get(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data.data();
          var title = data['catTitle'];
          print(title);
          var desc = data['catDesc'];
          var image = data['postImage'];

          return  Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Select Image');
                          _getImageAndCrop();
                        },
                        child: Container(
                          child: _postImageFile != null ? Image.file(_postImageFile) :Image(
                            image: AssetImage("images/icons8-add-image-64.png"),
                            width: size.width * 0.80,
                            height: 250.0,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.0,),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 1.0,),
                            TextFormField(
                              initialValue: title,
                              onChanged: (value) => title = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Title';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),

                                labelText: 'Title',
                                suffixIcon: Icon(Icons.title),
                              ),
                              controller: writingTextController,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                            //  initialValue: desc,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Description';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  gapPadding: 10,
                                ),
                                hintMaxLines: 4,
                                labelText: 'Description',
                                suffixIcon: Icon(Icons.description),
                              ),
                              controller: descTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                            SizedBox(height: 20,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("filters").doc("language").collection("name").snapshots(),
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(child: CircularProgressIndicator(),);
                                  else {
                                    List<DropdownMenuItem> currencyItems = [];
                                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                                      DocumentSnapshot snap = snapshot.data.docs[i];
                                      currencyItems.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.get("name"),
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                          value: "${snap.get("name")}",
                                        ),
                                      );
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.language,
                                            size: 25.0, color: Colors.indigo),
                                        SizedBox(width: 50.0),
                                        DropdownButton(
                                          items: currencyItems,
                                          onChanged: (currencyValue) {
                                            setState(() {
                                              selectedLanguage = currencyValue;

                                            });
                                          },
                                          value: selectedLanguage,
                                          isExpanded: false,
                                          hint: new Text(
                                            "Choose Language",
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                        ),

                                      ],
                                    );
                                  }
                                }),
                            SizedBox(height: 20,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("filters").doc("country").collection("name").snapshots(),
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(child: CircularProgressIndicator(),);
                                  else {
                                    List<DropdownMenuItem> currencyItems = [];
                                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                                      DocumentSnapshot snap = snapshot.data.docs[i];
                                      currencyItems.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.get("name"),
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                          value: "${snap.get("name")}",
                                        ),
                                      );
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.flag,
                                            size: 25.0, color: Colors.indigo),
                                        SizedBox(width: 50.0),
                                        DropdownButton(
                                          items: currencyItems,
                                          onChanged: (currencyValue) {
                                            setState(() {
                                              selectedCountry = currencyValue;

                                            });
                                          },
                                          value: selectedCountry,
                                          isExpanded: false,
                                          hint: new Text(
                                            "Choose Country",
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                        ),

                                      ],
                                    );
                                  }
                                }),
                            SizedBox(height: 20,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("filters").doc("topic").collection("name").snapshots(),
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(child: CircularProgressIndicator(),);
                                  else {
                                    List<DropdownMenuItem> currencyItems = [];
                                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                                      DocumentSnapshot snap = snapshot.data.docs[i];
                                      currencyItems.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.get("name"),
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                          value: "${snap.get("name")}",
                                        ),
                                      );
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.topic,
                                            size: 25.0, color: Colors.indigo),
                                        SizedBox(width: 50.0),
                                        DropdownButton(

                                          items: currencyItems,
                                          onChanged: (currencyValue) {

                                            setState(() {
                                              selectedTopic = currencyValue;

                                              print(selectedTopic);
                                            });
                                          },
                                          value: selectedTopic,

                                          isExpanded: false,
                                          hint: new Text(
                                            "Choose Topic",
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                        ),

                                      ],
                                    );
                                  }
                                }),

                          ],
                        ),
                      ),
                      Center(child: Utils.loadingCircle(_isLoading)),
                      ElevatedButton(onPressed: (){
                        if (_formKey.currentState.validate()) {

                          setState(() {
                            _isLoading = true;
                          });
                         // updateUser(widget.id, desc, title, image, );
                          Navigator.pop(context);
                        }
                      }, child: Text("Update Category"))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )




    );
  }

  Future<void> _getImageAndCrop() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File cropImageFile = await ImageCropper.cropImage(sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
          ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
          ]
          : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));//await cropImageFile(imageFileFromGallery);
      if (cropImageFile != null) {
        setState(() {
          _postImageFile = cropImageFile;
        });
      }
    }
  }
}
