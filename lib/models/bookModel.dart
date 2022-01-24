import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String id;
  String name;
  String author;
  int length;
  Timestamp dateCompleted;

  BookModel({
    this.id,
    this.name,
    this.length,
    this.dateCompleted,
  });

  BookModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    Map<String, dynamic> data = doc.data();
    //display

    id = doc.id;
    name = data["name"];
    author = data["author"];
    length = data["length"];
    dateCompleted = data['dateCompleted'];
  }
}