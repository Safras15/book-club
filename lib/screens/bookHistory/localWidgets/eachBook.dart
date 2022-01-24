

import 'package:book_club/models/bookModel.dart';
import 'package:book_club/screens/review/review.dart';
import 'package:book_club/screens/reviewHistory/reviewHistory.dart';
import 'package:book_club/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachBook extends StatelessWidget {
  final BookModel book;
  final String groupId;

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          bookId: book.id,
        ),
      ),
    );
  }

  EachBook({this.book, this.groupId});
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            book.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            book.author,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 38,
              width: 150,
              child: ElevatedButton(
              style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      )),
    ),
    child: Text("View Reviews", style: TextStyle(color: Colors.white, fontSize: 16)),
    onPressed: () => _goToReviewHistory(context),
    )
          )

        ],
      ),
    );
  }
}
