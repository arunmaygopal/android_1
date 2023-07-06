import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_actual_first_project/dashboard.dart';
import 'package:my_actual_first_project/manual.dart';
import 'package:my_actual_first_project/myform.dart';
import 'package:my_actual_first_project/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: SignUpPage(),
    );
  }
}
