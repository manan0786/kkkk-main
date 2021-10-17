import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/controllers/FBStorage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPost();
}

class _AddPost extends State<AddPost> {

  TextEditingController writingTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController langTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  TextEditingController topicTextController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  File _postImageFile;
  void _postToFB() async {

    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if(_postImageFile != null){
      postImageURL = await FBStorage.uploadCategoryImages(catID: postID, catImageFile: _postImageFile);
      print(postImageURL);
    }
    FBCloudStore.sendCategoryInFirebase(postID,writingTextController.text,descTextController.text,langTextController.text,
        countryTextController.text,topicTextController.text,postImageURL ?? 'NONE');
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
     final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create Category'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _postToFB();
    }
          }, icon:Icon(Icons.add) )
        ],
      ),
      body: Padding(
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Language';
                            }
                            return null;
                          },
                          controller: langTextController,
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
                            labelText: 'Language',
                            suffixIcon: Icon(Icons.language),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Country';
                            }
                            return null;
                          },
                          controller: countryTextController,
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
                            labelText: 'Country',
                            suffixIcon: Icon(Icons.flag),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Topic';
                            }
                            return null;
                          },
                          controller: topicTextController,
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
                            labelText: 'Topic',
                            suffixIcon: Icon(Icons.topic),
                          ),
                          keyboardType: TextInputType.text,
                        ),


                      ],
                    ),
                  ),
                  Center(child: Utils.loadingCircle(_isLoading)),
                ],
              ),
            ),
          ),
        ),
      ),


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
