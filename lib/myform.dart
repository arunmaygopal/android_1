import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './dashboard.dart';

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  String cropName = '';
  String? crop = "";
  String fieldSize = '';
  String soilType = '';
  List<String> cropList = [];
  List<String> soilList = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fieldSizeController = TextEditingController();
  final TextEditingController _irriModeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCropList();
    fetchSoilList();
  }

  Future<void> fetchCropList() async {
    List<String> cropNames = [];

    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to the collection
      CollectionReference collectionRef = firestore.collection('crop');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        // Get the value of the 'name' field
        String cropName = doc.get('cropname');

        // Add the cropName to the list
        cropNames.add(cropName);
      });
      setState(() {
        cropList = cropNames;
      });
    } catch (e) {
      print('Error fetching crop names: $e');
    }
  }

  Future<void> fetchSoilList() async {
    List<String> soilNames = [];

    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to the collection
      CollectionReference collectionRef = firestore.collection('soil');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        // Get the value of the 'name' field
        String soilName = doc.get('soilname');

        // Add the cropName to the list
        soilNames.add(soilName);
      });
      setState(() {
        soilList = soilNames;
      });
    } catch (e) {
      print('Error fetching soil names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [
      for (int i = 0; i < cropList.length; i++)
        DropdownMenuItem(
          child: Text(cropList[i]),
          value: cropList[i],
        ),

      // Add more items as needed
    ];
    List<DropdownMenuItem<String>> items2 = [
      for (int i = 0; i < soilList.length; i++)
        DropdownMenuItem(
          child: Text(soilList[i]),
          value: soilList[i],
        ),

      // Add more items as needed
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'A I S C R',
          style: TextStyle(color: Colors.green),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _irriModeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'irriMode',
                      fillColor: Color(0xFFF0EFEF),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        cropName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _fieldSizeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'field Size',
                      fillColor: Color(0xFFF0EFEF),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        fieldSize = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    items: items,
                    onTap: () {
                      setState(() {
                        crop = "asdf";
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        crop = value;
                      });
                    },
                    dropdownColor: Colors.grey,
                    decoration:
                        InputDecoration(labelText: 'Select Crop', filled: true),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    items: items2,
                    onTap: () {
                      setState(() {});
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    dropdownColor: Colors.grey,
                    decoration:
                        InputDecoration(labelText: 'Select Soil', filled: true),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        log('irriMode: $soilType');
                        updateData();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50.0),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateData() {
    final auth = FirebaseAuth.instance;
    final phone = auth.currentUser!.phoneNumber.toString();
    int fieldSize = int.parse(_fieldSizeController.text);
    log('phone: $phone');
    log('irriMode: ${_irriModeController.text}');
    log('fieldSize: ${_fieldSizeController.text}');
    try {
      FirebaseFirestore.instance
          .collection('user')
          .doc(phone)
          .update({'mode': _irriModeController.text, 'fieldsize': fieldSize});
    } catch (e) {
      log(e.toString());
    }
  }
}
