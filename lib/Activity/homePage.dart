import 'package:ActionApp/Activity/ListNovel.dart';
import 'package:ActionApp/Activity/addNovel.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class HomePage extends StatefulWidget {
  final String emailID;

  const HomePage({Key key, this.emailID}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  String emailValue;
  @override
  void initState(){
    super.initState();
    emailValue = this.widget.emailID;
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget>[
            GradientText("My Novel Collection",
                gradient: LinearGradient(colors: [
                  Colors.deepPurpleAccent[200],
                  Colors.redAccent[200]
                ]),
                style: TextStyle(fontSize: 22, fontFamily: "GentiumBasic"),
                textAlign: TextAlign.center)
          
          ],
        ),
      bottom: new TabBar(
        controller: _tabController,
        indicatorColor: Colors.white ,
        tabs: [
          new Tab(text: 'Novel List'),
          new Tab(text: 'Add Novel'),
          ]        
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: [
          new ListNovel(),
          new NovelAdd(),
        ]
      ),
    );
  }
}