import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../state_widget.dart';

// - StateWidget incl. state data
//    - RecipesApp
//        - All other widgets which are able to access the data
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  StateWidget stateWidget = StateWidget(child: RecipesApp());
  runApp(stateWidget);
}
