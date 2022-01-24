import 'package:book_club/models/authModel.dart';
import 'package:book_club/models/bookModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:book_club/screens/inGroup/inGroup.dart';
import 'package:book_club/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/widgets/shadowContainer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBook extends StatefulWidget {
  final bool onGroupCreation;
  final String groupName;
  final UserModel currentUser;

  //constructor
  AddBook({
    this.onGroupCreation, this.groupName, this.currentUser,
  });
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await DatePicker.showDateTimePicker(
        context,
        showTitleActions: true);

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

      });
    }
  }

  void _addBook(BuildContext context, String groupName, BookModel bookModel) async {
    AuthModel _auth = Provider.of<AuthModel>(context, listen: false);
    String _returnString;

    if (widget.onGroupCreation) {
      _returnString =
      await DBFuture().createGroup(groupName, _auth.uid, bookModel);
    } else {
      //_returnString = await  DBFuture().addBook(widget.currentUser.groupId, bookModel);
      _returnString = await DBFuture().addNextBook(widget.currentUser.groupId, bookModel);
    }

    if(_returnString == "success"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OurRoot(),), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                BackButton(
                  color: Colors.white70,
              ),],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.book),
                      hintText: "Book Name",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Author",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.format_list_numbered),
                      hintText: "Length",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  //datepicker
                  Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("H:00").format(_selectedDate)),
                  TextButton(
                    child: Text('Change Date'),
                    onPressed: () => _selectDate(context),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                        )
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Add Book",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        //getting BookModel instantiated
                        BookModel bookModel = BookModel();
                        bookModel.name = _bookNameController.text;
                        bookModel.author = _authorController.text;
                        bookModel.length = int.parse(_lengthController.text);
                        bookModel.dateCompleted = Timestamp.fromDate(_selectedDate);

                        _addBook(context, widget.groupName, bookModel);



                      }
                  ),
                  // ElevatedButton(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 80),
                  //     child: Text(
                  //       "Add Book",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 20.0,
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () =>
                  //       _goToAddBook(context, _groupNameController.text),
                  // ),
                ],
              ),
            ),
          ),
          //Spacer(),
        ],
      ),
    );
  }
}