import 'package:book_club/models/authModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dbFuture.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {

  FirebaseAuth _auth = FirebaseAuth.instance;
//FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //getting data from firebase
  Stream<AuthModel> get user {
    return _auth.authStateChanges().map(
          (User user) =>
      (user != null)
          ? AuthModel.fromFirebaseUser(user: user,)
          : null,
    );
  }

    //signOut
    Future<String> signOut() async {
      String retVal = "error";
      try {
        await _auth.signOut();
        retVal = "success";
        print("Sign Out Success!");
      } catch (e) {
        print(e);
      }
      return retVal;
    }


    //sign up user
    Future<String> signUpUser(String email, String password,
        String fullName) async {
      String retVal = "error";
      try {
        UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        UserModel _user = UserModel(
          uid: userCredential.user.uid,
          email: userCredential.user.email,
          fullName: fullName,
          accountCreated: Timestamp.now(),
        );
        String _returnString = await DBFuture().createUser(_user);
        if (_returnString == "success") {
          print("USER SIGNED UP INFO: " + _user.fullName + "," + _user.email );
          retVal = "success";
        }
      } on PlatformException catch (e) {
        retVal = e.message;
      } catch (e) {
        print(e);
      }
      return retVal;
    }

    //log in with User Email and Password
    Future<String> loginUserWithEmail(String email, String password) async {
      String retVal = "error";
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
          // _currentUser = await OurDatabase().getUserInfo(_userCredential.user.uid);
          // if (_currentUser != null) {
            retVal = "success";
          // }
      } on PlatformException catch (e) {
        retVal = e.message;
      } catch (e) {
        print(e);
      }
      return retVal;
    }


    //log in with google
    Future<String> loginUserWithGoogle() async {
      String retVal = "error";

      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      try {
        // Trigger the authentication flow
        GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
        // Obtain the auth details from the request
        GoogleSignInAuthentication _googleAuth = await _googleUser
            .authentication;
        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

        // Once signed in, return the UserCredential
        UserCredential _userCredential =
        await _auth.signInWithCredential(credential);

        if (_userCredential.additionalUserInfo.isNewUser) {
          //OurDatabase().createUser(_userModel);
          UserModel _user = UserModel(
            uid: _userCredential.user.uid,
            email: _userCredential.user.email,
            fullName: _userCredential.user.displayName,
            accountCreated: Timestamp.now(),
          );
          String _returnString = await DBFuture().createUser(_user);
          if (_returnString == "success") {
            print("USER GOOGLE SIGNED IN INFO: " + _user.fullName + "," + _user.email );
            retVal = "success";
          }
        }
        retVal = 'success';

      } on PlatformException catch (e) {
        retVal = e.message;
      } catch (e) {
        print(e);
      }
      return retVal;
    }

}