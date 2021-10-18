import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Filters extends StatefulWidget {
  const Filters({Key key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController langTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  TextEditingController topicTextController = TextEditingController();

  var language = "";
  var country = "";
  var topic = "";
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    langTextController.dispose();
    countryTextController.dispose();
    topicTextController.dispose();
    super.dispose();
  }

  clearText() {
    langTextController.clear();
    countryTextController.clear();
    topicTextController.clear();
  }

  ///////////////////////////////////
  /*ADD LANGUAGE FILTER*/

  CollectionReference lan = FirebaseFirestore.instance.collection('filters').doc("language").collection("name");

  Future<void> addlanguage() {
    return lan.add({'name': language,})
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Added language filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Failed to add filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    )
    );
  }


  ///////////////////////////////////
  /*ADD Country FILTER*/

  CollectionReference con = FirebaseFirestore.instance.collection('filters').doc("country").collection("name");

  Future<void> addCountry() {
    return con.add({'name': country,})
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Added country filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Failed to add filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ));
  }

  ///////////////////////////////////
  /*ADD Topic FILTER*/

  CollectionReference to = FirebaseFirestore.instance.collection('filters').doc("topic").collection("name");

  Future<void> addTopic() {
    return to.add({'name': topic,})
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Added topic filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Failed to add filter',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Filters'),
        centerTitle: true,

      ),
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text("Add your desired filter. Can be all or only one."),
              Form(
                key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [


                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Language Filter';
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
                              SizedBox(height: 10,),
                              ElevatedButton(onPressed: (){
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    language = langTextController.text;
                                    addlanguage();
                                    clearText();
                                  });

                                }
                              }, child: Text("Add Language Filter")),



                            ],
                          ),
                        ),


                      ],
                    ),
                  ),

              ),
              Form(
                key: _formKey1,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Country Filter';
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
                            SizedBox(height: 10,),
                            ElevatedButton(onPressed: (){
                              if (_formKey1.currentState.validate()) {
                                setState(() {
                                  country = countryTextController.text;
                                  addCountry();
                                  clearText();
                                });

                              }
                            }, child: Text("Add Country Filter")),



                          ],
                        ),
                      ),


                    ],
                  ),
                ),

              ),
              Form(
                key: _formKey2,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [

                            SizedBox(height: 10,),
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
                            SizedBox(height: 10,),
                            ElevatedButton(onPressed: (){
                              if (_formKey2.currentState.validate()) {
                                setState(() {
                                  topic = topicTextController.text;
                                  addTopic();
                                  clearText();
                                });

                              }
                            }, child: Text("Add Topic Filter")),


                          ],
                        ),
                      ),


                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),


    );
  }
}
