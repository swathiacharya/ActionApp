
import 'dart:core';
import 'dart:io';
import 'package:ActionApp/Activity/database/crude.dart';
import 'package:ActionApp/helper/helperfunctions.dart';
import 'package:ActionApp/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';


class NovelAdd extends StatefulWidget {
  @override
  _NovelAddState createState() => _NovelAddState();
}

class _NovelAddState extends State<NovelAdd> {

TextEditingController _textFieldController =TextEditingController();
  CrudMethods crudMethods = new CrudMethods();

  //TextEditingController _textFieldController =TextEditingController();
  File _image;
  String _url;
  String _novelName;
  String _description;
  var _authorName;
  String _startDate;
  String _endDate;
  bool _isLoading = false;

  bool userIsLoggedIn;
  String userEmail;

  getEmailId() async{
    if (userIsLoggedIn){
      await HelperFunctions.getUserEmailSharedPreference().then((value) => {
        setState((){
          userEmail = value;
        })
      });
    }
  }
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }
    @override
  void initState() {
    getLoggedInState();
    getEmailId();
    super.initState();
    
  }


  final formKey = new GlobalKey<FormState>();
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  uploadStatus() async {
    print("Its uploaded");
    if (_image != null  && _image.existsSync()){
      setState(() {
        _isLoading = true;
      });
      StorageReference postImageRef = FirebaseStorage.instance
          .ref()
          .child("Post Image")
          .child("${randomAlphaNumeric(9)}.jpg");
    final StorageUploadTask task = postImageRef.putFile(_image);
        var downloadurl = await (await task.onComplete).ref.getDownloadURL();
        print("************************");
      print("This is url $downloadurl");
      print("this is the url of image");
      print("-------------------------------");
      Map<String, dynamic> NovelDetail = {
        "NovelName": _novelName,
        "AuthorName": _authorName,
        "Description":_description,
        "ImageUrl":  downloadurl,
        "StartDate": _startDate,
        "EndDate": _endDate,

      };
      print("crude operation");
  


      crudMethods.UploadNovel(NovelDetail, userEmail).then((result) {
        print("********operation is done*****");
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Saved in Database')));
        print("after the snackbar");
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(
              vertical: 8,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 90.0,
                      backgroundColor: Colors.deepPurpleAccent[200],
                      child: _image != null
                          ? ClipOval(
                              child: SizedBox(
                                height: 160,
                                width: 160,
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : ClipOval(
                              child: SizedBox(
                              width: 160,
                              height: 160,
                              child: Image(
                                image: AssetImage(
                                  'assets/backgnd.jpg',
                                ),
                                fit: BoxFit.fill,
                              ),
                            )),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
            height: 20,
          ),
            Padding(
              padding: EdgeInsets.all(9),
              child: TextFormField(
                    onSaved: (value){
                      return _novelName=value;
                    },
                    validator:(val){
                    return  _novelName = val;
                    },
                    onChanged: (value){
                    return  _novelName=value;

                    },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Novel Name *",
                  hintStyle: inputTextStyle(),
                  fillColor: Colors.blue,
                  enabledBorder: borderStyle(),
                  focusedBorder: borderStyle(),
                )),
          ),
            Padding(
              padding: EdgeInsets.all(9),
              child: TextFormField(
                onSaved: (value){
                      return _authorName=value;
                    },
                    onChanged: (value){
                    return  _authorName=value;
                    },
                    validator: (value){
                    return  _authorName=value;
                    },
                
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Author Name *",
                  hintStyle: inputTextStyle(),
                  fillColor: Colors.blue,
                  enabledBorder: borderStyle(),
                  focusedBorder: borderStyle(),
                )),
          ),
            Padding(
            padding: EdgeInsets.all(9),
            child: TextFormField(
                onSaved: (value){
                      return _description=value;
                    },
                    onChanged: (value){
                      return _description=value;

                    },
                    validator: (value){
                      return _description=value;
                    },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Description *",
                  hintStyle: inputTextStyle(),
                  fillColor: Colors.blue,
                  enabledBorder: borderStyle(),
                  focusedBorder: borderStyle(),
                )),
          ),
            Padding(
            padding: EdgeInsets.all(9),
            child: TextFormField(
                onSaved: (value){
                      return _startDate=value;
                    },
                    onChanged: (value){
                      return _startDate=value;

                    },
                    validator: (value){
                      return _startDate=value;

                    },
                    
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "StartDate *",
                  hintStyle: inputTextStyle(),
                  fillColor: Colors.blue,
                  enabledBorder: borderStyle(),
                  focusedBorder: borderStyle(),
                )),
          ),
            Padding(
            padding: EdgeInsets.all(9),
            child: TextFormField(
                onSaved: (value){
                      return _endDate=value;
                    },
                    onChanged: (value){
                      return _endDate=value;

                    },
                    validator: (value){
                      return _endDate=value;

                    },
                    
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "EndDate *",
                  hintStyle: inputTextStyle(),
                  fillColor: Colors.blue,
                  enabledBorder: borderStyle(),
                  focusedBorder: borderStyle(),
                )),
          ),
            SizedBox(height: 15),
            GestureDetector(
            onTap: () {
             uploadStatus();
            },
            child: Container(
              width: 120,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple,
                    Colors.redAccent[200],
                  ],
                ),
              ),
                child: Center(
                  child: Text(
                    'Send',
                    style: appbarStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ]),
        ),
      ),
    );
  }
}