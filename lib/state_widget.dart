import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/state.dart';
import '../utils/auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel? state;
  final Widget child;

  const StateWidget({
    Key? key,
    required this.child,
    this.state,
  }) : super(key: key);

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_StateDataWidget>()
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel? state;
  GoogleSignInAccount? googleAccount;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = StateModel(isLoading: true);
      initUser();
    }
  }

  Future<void> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      setState(() {
        state?.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(state?.user?.uid)
        .get();
    if (querySnapshot.exists && querySnapshot['favorites'] is List) {
      // Create a  List<String> from List<dynamic>
      return List<String>.from(querySnapshot['favorites']);
    }
    return [];
  }

  Future<void> signInWithGoogle() async {
    googleAccount ??= await googleSignIn.signIn();
    User firebaseUser = await signIntoFirebase(googleAccount);
    state?.user = firebaseUser; //
    List<String> favorites = await getFavorites(); //
    setState(() {
      state?.isLoading = false;
      state?.favorites = favorites; //
    });
  }

  Future<void> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state?.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  const _StateDataWidget({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
