import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  String leader;
  List<String> members;
  Timestamp groupCreated;
  String currentBookId;
  int indexPickingBook;
  String nextBookId;
  Timestamp currentBookDue;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
    this.currentBookId,
    this.indexPickingBook,
    this.nextBookId,
    this.currentBookDue,
  });

  GroupModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    Map<String, dynamic> data = doc.data();
    id = doc.id;
    name = data['name'];
    leader = data['leader'];
    members = List<String>.from(data['members']);
    groupCreated = data['groupCreated'];
    currentBookId = data['currentBookId'];
    currentBookDue = data['currentBookDue'];
    indexPickingBook = data['indexPickingBook'];
    nextBookId = data['nextBookId'];
  }

}