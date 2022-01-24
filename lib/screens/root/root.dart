import 'package:book_club/models/authModel.dart';
import 'package:book_club/models/groupModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:book_club/screens/inGroup/inGroup.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/screens/splashScreen/splashScreen.dart';
import 'package:book_club/services/dbStream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  unknown,
  notLoggedIn,
  loggedIn,
}

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String currentUid = null;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context, listen: false);

    if (_authStream != null) {
        setState(() {
          _authStatus = AuthStatus.loggedIn;
          currentUid = _authStream.uid;
        });
    }  else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        //retVal = Scaffold(body: Center(child: Text("not logged in"),),);
        retVal = Login();
        break;
      case AuthStatus.loggedIn:
        retVal = StreamProvider<UserModel>.value(value: DBStream().getCurrentUser(currentUid),
        child: LoggedIn());
        //retVal = Scaffold(body: Center(child: Text("not in group"),),);
        //retVal = InGroup();
        break;
      default:
    }
    return retVal;
  }

}

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userStream = Provider.of<UserModel>(context);
    Widget retVal;

    if (_userStream != null) {
      if (_userStream.groupId != null) {
        retVal = StreamProvider<GroupModel>.value(
            value: DBStream().getCurrentGroup(_userStream.groupId),
            child:InGroup());
      } else {
        retVal = NoGroup();
      }
    } else {
      retVal = SplashScreen();
      //retVal = NoGroup();
    }

    return retVal;
  }
}