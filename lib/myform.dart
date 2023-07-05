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
  String fieldSize = '';
  String soilType = '';
  List<String> cropList = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fieldSizeController = TextEditingController();
  final TextEditingController _irriModeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCropList();
  }

  Future<void> fetchCropList() async {
    final snapshot = await FirebaseFirestore.instance.collection('crop').get();
    final List<String> cropList = snapshot.docs.map((e) => e.id).toList();
    setState(() {
      this.cropList = cropList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'INSERT NAME',
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
              height: 370,
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
