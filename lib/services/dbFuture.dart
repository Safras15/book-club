import 'package:book_club/models/bookModel.dart';
import 'package:book_club/models/reviewModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DBFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //creating a group
  Future<String> createGroup(String groupName, String userUid, BookModel initialBook) async {
    String retVal = "error";
    List<String> members = [userUid];
    try{
      DocumentReference _docRef = await _firestore.collection("groups").add({
        'name' : groupName,
        'leader' : userUid,
        'members' : members,
        'groupCreate': Timestamp.now(),
        'nextBookId' : 'waiting',
        'indexPickingBook': 0
      });

      await _firestore.collection("users").doc(userUid).update({
        'groupId': _docRef.id,
      });
      //add a book
      addBook(_docRef.id, initialBook);
      print("GROUP CREATED INFO:" + groupName + ", " + userUid );
      retVal = "success";
    } catch(e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = "error";
    List<String> members = [userUid];

    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members)
      });

      await _firestore.collection("users").doc(userUid).update({
        'groupId': groupId,
      });
      print("GROUP JOIN INFO: " + 'Group Id =>' + groupId + ", User Id =>" + userUid);
      retVal = "success";

    }
    on PlatformException catch (e) {
      retVal = "Make sure you have the right group ID!";
      print(e);
    }
    catch(e) {
      print(e);
    }
    return retVal;
  }

  //add book
  Future<String> addBook(String groupId, BookModel bookModel) async {
    String retVal = "error";

    try{
      //adding book details to firestore db
      DocumentReference _docRef = await _firestore.collection("groups").doc(groupId).collection('books').add({
        'name' : bookModel.name,
        'author' : bookModel.author,
        'length': bookModel.length,
        'dateCompleted' : bookModel.dateCompleted,
      }
      );

      //add current book to group schedule
      await _firestore.collection('groups').doc(groupId).update({
        'currentBookId': _docRef.id,
        'currentBookDue': bookModel.dateCompleted,
      });
      print("ADDED BOOK INFO:" + bookModel.name + ", " + bookModel.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> addNextBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef =
      await _firestore.collection("groups").doc(groupId).collection("books").add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await _firestore.collection("groups").doc(groupId).update({
        "nextBookId": _docRef.id,
      });
      retVal = "success";
    } catch(e) {
      print(e);
    }

    return retVal;
  }


  Future<String> finishedBook(
      String groupId,
      String bookId,
      String uid,
      int rating,
      String review,
      ) async {
    String retVal = "error";
    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .set({
        'rating': rating,
        'review': review,
      });
      print("FINISHED BOOK RATING AND REVIEW INFO: Rating => " + rating.toString() + ", Review =>" + review + ', Book Id =>' + bookId);
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //get current book details
  Future<BookModel> getCurrentBook(String groupId, String bookId) async {
    BookModel retVal;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .get();
      retVal = BookModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  //checking if user is done reading the book
  Future<bool> isUserDoneWithBook(
      String groupId, String bookId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }


  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<UserModel> getUser(String uid) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<BookModel>> getBookHistory(String groupId) async {
    List<BookModel> retVal = [];

    try{
      QuerySnapshot query = await _firestore.collection("groups")
          .doc(groupId).collection("books").
      orderBy("dateCompleted", descending: true).get();

      query.docs.forEach((element) {
        retVal.add(BookModel.fromDocumentSnapshot(doc: element));
        print(retVal);
        //print("VIEW BOOK CLUB HISTORY: Group Id => " + groupId);

      });
    }
    catch(e) {
      print(e);
    }
    return retVal;
  }


  Future<List<ReviewModel>> getReviewHistory(
      String groupId, String bookId) async {
    List<ReviewModel> retVal = [];
    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .get();

      query.docs.forEach((element) {
        retVal.add(ReviewModel.fromDocumentSnapshot(doc: element));
      });
      print("VIEW REVIEW HISTORY: Group Id => " + groupId + "Book Id => " + bookId);
    } catch (e) {
      print(e);
    }
    return retVal;
  }


  Future<String> leaveGroup(String groupId, UserModel userModel) async{
    String retVal = "error";
    List<String> members = [];

    try{
      members.add(userModel.uid);

      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayRemove(members),
      });

      await _firestore.collection("users").doc(userModel.uid).update({
        'groupId': null,
      });

      print("USER REMOVED FROM GROUP: Group Id =>" + groupId);
    }
    catch(e) {
      print(e);
    }
    return retVal;
  }

}