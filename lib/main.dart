import 'package:ActionApp/Activity/homePage.dart';
import 'package:ActionApp/helper/authenticate.dart';
import 'package:ActionApp/helper/helperfunctions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn;
  String userEmail;

  @override
  void initState() {
    getLoggedInState();
    getEmailId();
    super.initState();
    
  }
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        accentColor: Color(0xff007EF4),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn ? HomePage() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}








