// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Future createAccount(String name, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      debugPrint('Account Created Successfully');

      user.updateProfile(displayName: name);

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set({'name': name, 'email': email, 'status': 'umavailable'});

      return user;
    } else {
      debugPrint('Account Not Created');
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future login(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      debugPrint('Login Successfully');
      return user;
    } else {
      debugPrint('Login Failed');
      return user;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future logout() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
  } catch (e) {
    debugPrint('Failed to logout');
  }
}
