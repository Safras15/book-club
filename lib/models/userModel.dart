import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;
  String groupId;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
    this.groupId,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    Map<String, dynamic> data = doc.data();
    //display
      uid = doc.id;
      email = data['email'];
      accountCreated = data['accountCreated'];
      fullName = data['fullName'];
      groupId = data['groupId'];
  }
}