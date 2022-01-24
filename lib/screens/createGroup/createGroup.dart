import 'package:flutter/material.dart';
import 'package:book_club/screens/addBook/addBook.dart';
import 'package:book_club/widgets/shadowContainer.dart';


class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  void _goToAddBook(BuildContext context, String groupName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: true,
          //onError: false,
          groupName: groupName,
        ),
      ),
    );
  }

  // void _createGroup(BuildContext context, String groupName) async {
  //   CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
  //   String _returnString = await OurDatabase().createGroup(groupName, _currentUser.getCurrentUser.uid);
  //   if(_returnString == "success"){
  //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OurRoot(),), (route) => false);
  //   }
  // }

  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[const BackButton(
                color: Colors.white70,
              )],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                        )
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          "Create Group",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () => _goToAddBook(context, _groupNameController.text)
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
          const Spacer(),
        ],
      ),
    );
  }
}