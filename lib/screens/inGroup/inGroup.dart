import 'dart:async';

import 'package:book_club/models/authModel.dart';
import 'package:book_club/models/bookModel.dart';
import 'package:book_club/models/groupModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:book_club/screens/addBook/addBook.dart';
import 'package:book_club/screens/bookHistory/bookHistory.dart';
import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/services/dbFuture.dart';
import 'package:book_club/services/dbStream.dart';
import 'package:book_club/utils/timeLeft.dart';
import 'package:book_club/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'localWidgets/secondCard.dart';
import 'localWidgets/topCard.dart';

class InGroup extends StatefulWidget {
  @override
  State<InGroup> createState() => _InGroupState();
}

class _InGroupState extends State<InGroup> {
  final key = new GlobalKey<ScaffoldState>();

  GroupModel _groupModel;
  UserModel _userModel;
  //List <String> _timeUntil = ['', ''];
  //_timeUntil = List.filled(0,1);
  //[0] - Time until book is due
  //[1] - Time until next book is revealed

  // Timer _timer;
  // void _startTimer(CurrentGroup currentGroup) {
  //
  //   _timer = Timer.periodic(const Duration(seconds: 1),(timer) {
  //     setState(() {
  //       _timeUntil = OurTimeLeft().timeLeft(currentGroup.getCurrentGroup.currentBookDue.toDate());
  //     });
  //   });
  // }

  String _timeUntil = "loading...";
  AuthModel _authModel;
  bool _doneWithBook = true;
  Timer _timer;
  BookModel _currentBook;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _timeUntil = TimeLeft().timeLeft(_groupModel.currentBookDue.toDate());
        });
      }
    });
  }



  @override
  void didChangeDependencies() {
    _userModel = Provider.of<UserModel>(context);
    _groupModel = Provider.of<GroupModel>(context);
    super.didChangeDependencies();

    // CurrentGroup _currentGroup =
    // Provider.of<CurrentGroup>(context, listen: false);
    // _currentGroup.updateStateFromDatabase(_currentUser.getCurrentUser.groupId, _currentUser.getCurrentUser.uid);
    // _startTimer(_currentGroup);
  }

  @override
  void dispose() {
    //_timer.cancel();
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  // void _goToAddBook(BuildContext context) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => AddBook(
  //           onGroupCreation: false,
  //           currentUser: _userModel,
  //         ),
  //       ));
  // }

  // void _gotToReview() {
  //   CurrentGroup _currentGroup = Provider.of<CurrentGroup>(context, listen: false);
  //
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Review(currentGroup: _currentGroup),
  //       ));
  // }

  void _signOut(BuildContext context) async {
    String _returnString = await Auth().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
              (route) => false);
    }
  }

  void _leaveGroup(BuildContext context) async {
    GroupModel groupModel = Provider.of<GroupModel>(context, listen: false);
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String _returnString = await DBFuture().leaveGroup(groupModel.id, userModel);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
              (route) => false);
    }
  }

  void _copyGroupId(BuildContext) {
    GroupModel groupModel = Provider.of<GroupModel>(context, listen: false);
    Clipboard.setData(ClipboardData(text: groupModel.id));

    // key.currentState.showSnackBar(snackBar {
    //   content: Text('Copied!'),
    // });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar
      (content: Text("Copied!")));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
          const SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TopCard(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SecondCard(),
          ),
          Padding(
              padding: const EdgeInsets.all(35.0),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookHistory(groupId: _groupModel.id,),
                        ),
                            (route) => false);
                  },
                  child: Text("View Book Club History"),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 150, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    child:
                    const Text("Copy Group Id", style: TextStyle(color: Colors.white)),
                    onPressed: () => _copyGroupId(context)),
              )),
          SizedBox(
            height: 20,
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 150, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    child:
                    const Text("Sign Out", style: TextStyle(color: Colors.white)),
                    onPressed: () => _signOut(context)),
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 150, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    child:
                    const Text("Leave Group", style: TextStyle(color: Colors.white60)),
                    onPressed: () => _leaveGroup(context)),
              )),

          SizedBox(
            height: 20,
          ),
        ]
        )
    );
  }
}