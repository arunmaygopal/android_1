import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_actual_first_project/myform.dart';
import 'package:my_actual_first_project/services/otp.dart';

final TextEditingController otpController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECE6),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Farmer Sign-Up',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          height: 370,
          width: 350,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white, // Set container color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  TextFormField(
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      register(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MyFormPage(),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size(double.infinity, 50.0),
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

  void register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      log('Name: ${nameController.text}');
      log('Address: ${addressController.text}');
      log('Phone Number: ${phoneNumberController.text}');

      FirebaseServices().verifyPhoneNumber(phoneNumberController.text);
      showDialog(
          context: context,
          builder: (
            BuildContext context,
          ) {
            return CustomModal(phoneNumberController.text);
          });
    }
  }
}

class CustomModal extends StatelessWidget {
  final String phoneNumber;

  CustomModal(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter OTP'),
      content: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: const InputDecoration(
          labelText: 'OTP',
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            String otp = otpController.text;
            if (otp.length == 6) {
              //verify phone number with OTP function call
              FirebaseServices().verifyOTP(otp);
              addUserToFirestore();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFormPage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid OTP'),
                ),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  //adding user to firestore

  void addUserToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      log('User: ${user.phoneNumber}');
      //add user to firestore
      FirebaseFirestore.instance
          .collection('user')
          .doc(phoneNumberController.text)
          .set({
        'name': nameController.text,
        'address': addressController.text,
        'mobile': phoneNumberController.text,
        'id': user.uid,
        'fieldsize': 0,
        'mode ': "manual"
      });
    }
  }

  //  Function to initiate OTP verification
}
