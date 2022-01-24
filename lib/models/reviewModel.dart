import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String userId;
  int rating;
  String review;

  ReviewModel({
    this.userId,
    this.rating,
    this.review,
});

  ReviewModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    Map<String, dynamic> data = doc.data();
    //display
    userId = doc.id;
    rating = data["rating"];
    review = data["review"];
  }

}