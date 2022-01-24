import 'package:flutter/material.dart';
import 'localwidgets/signupForm.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                     BackButton(
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                SignUpForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}