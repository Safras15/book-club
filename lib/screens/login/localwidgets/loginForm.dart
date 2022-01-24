import 'package:book_club/screens/inGroup/inGroup.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

import 'package:book_club/screens/root/root.dart';
import 'package:provider/provider.dart';

enum LoginType {
  email,
  google,
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  void _loginUser({
        @required LoginType type,
        String email,
        String password,
        BuildContext context
  }) async {

    try{
      String _returnString;

      switch(type) {
        case LoginType.email:
          _returnString =  await Auth().loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await Auth().loginUserWithGoogle();
          break;
        default:
      }

      if (_returnString == "success"){
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => InGroup(),)
        // );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OurRoot(),
        ), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_returnString),
          duration: Duration(seconds: 2),
        ));
      }
    } catch(e) {
      print(e);
    }
  }


  //google button widget
  Widget _googleButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        //highlightElevation: 0,
        side: BorderSide(color: Colors.grey),
      ),
      onPressed: () {
        _loginUser(type: LoginType.google,
            context: context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: <Widget> [
          Padding(padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 8.0,
          ),
            child: Text("Log In", style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: "Password",
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
              height: 40.0,
            child:  ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                )
                ),
              ),
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Text("Log In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                      fontSize: 20.0))
              ),
              onPressed: () {
                _loginUser(
                    type: LoginType.email,
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context
                );
              },
            ),
          ),
          TextButton(
            child: const Text("Don't have an account? Sign up here."),
            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(),),
              );
            },
          ),
          _googleButton(),
        ],
      ),
    );
  }
}

