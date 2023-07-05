import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_actual_first_project/dashboard.dart';
import 'package:my_actual_first_project/myform.dart';
import 'package:my_actual_first_project/signup.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        runApp(MaterialApp(
          title: 'Your App Title',
          home: SignUpPage(),
        ));
      } else {
        print('User is signed in!');
        runApp(MaterialApp(
          title: 'Your App Title',
          home: DashboardPage(),
        ));
      }
    });
    return MaterialApp(
      title: 'Your App Title',
      home: DashboardPage(),
    );
  }
}



