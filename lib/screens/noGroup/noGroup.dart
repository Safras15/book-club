import 'package:book_club/models/userModel.dart';
import 'package:book_club/screens/createGroup/createGroup.dart';
import 'package:book_club/screens/joinGroup/joinGroup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoGroup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context);
    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinGroup(
            userModel: _currentUser,
          ),
        ),
      );
    }

    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroup(),
        ),
      );
    }
    return Scaffold(
      body: Column(children: <Widget> [
        //Spacer(flex: 1),
        const SizedBox(
          height:40.0
        ),
        Padding(padding: EdgeInsets.all(60.0),
        child: Image.asset("assets/logo.png"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text("Welcome To 'The Well Read' Book Club! 💡",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.yellow[100],
            fontWeight: FontWeight.bold
          )),
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text("Since you are not in a book club yet, you can either choose to" +
          " join a club or create a new club of your own!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white60,
          )),
        ),

        Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              SizedBox(
                width: 150, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                  ),
                  child: const Text("Create",
                      style: TextStyle(
                          color: Colors.grey
                      )),
                  onPressed: () => _goToCreate(context),
                ),
              ),
              SizedBox(
                width: 150, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                    )
                    ),
                  ),
                  onPressed: () => _goToJoin(context), child: Text("Join"),
                ),
              )

            ],)
        ),
      ],)
    );
  }
}
