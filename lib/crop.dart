import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './dashboard.dart';

class CropScreen extends StatefulWidget {
  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  String cropName = '';
  String fieldSize = '';
  String soilType = '';
  List<String> cropList = [];
  List<String> soilList = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropname = TextEditingController();
  final TextEditingController _soilType = TextEditingController();

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
    final snapshot2 = await FirebaseFirestore.instance.collection('crop').get();
    final List<String> soilList = snapshot.docs.map((e) => e.id).toList();
    setState(() {
      this.soilList = soilList;
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
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Crop Name',
                      fillColor: Color(0xFFF0EFEF),
                      filled: true,
                    ),
                    value: cropName,
                    onChanged: (value) {
                      setState(() {
                        cropName = value.toString();
                      });
                    },
                    items: cropList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),

                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Soil Type',
                      fillColor: Color(0xFFF0EFEF),
                      filled: true,
                    ),
                    value: soilType,
                    onChanged: (value) {
                      setState(() {
                        soilType = value.toString();
                      });
                    },
                    items: soilList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
