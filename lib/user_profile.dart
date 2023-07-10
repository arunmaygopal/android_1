import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  DatabaseReference _userRef;
  String _userName = '';
  String _cropName = '';
  String _irrigationMethod = '';
  String _soilType = '';
  double _fieldSize = 0.0;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users').child('user_id');
    _userRef.once().then((DataSnapshot snapshot) {
      setState(() {
        _userName = snapshot.value['userName'];
        _cropName = snapshot.value['cropName'];
        _irrigationMethod = snapshot.value['irrigationMethod'];
        _soilType = snapshot.value['soilType'];
        _fieldSize = snapshot.value['fieldSize'].toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Name: $_userName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Crop Name: $_cropName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Irrigation Method: $_irrigationMethod',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Soil Type: $_soilType',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Field Size: $_fieldSize',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
