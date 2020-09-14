import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {

    Future<void> UploadNovel(novelDetail, emailValue) async {
    Firestore.instance
        .collection("Problems")
        .document(emailValue)
        .setData(novelDetail)
        .catchError((e) {
      print(e.toString());
    });
  }

getData() async {
    return  Firestore.instance.collection('Problems').document('email').collection('timeValue').snapshots();
  }
}
