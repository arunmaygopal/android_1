import 'package:flutter/material.dart';
import './dashboard.dart';
import './dashboard.dart';

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  String cropName = '';
  String fieldSize = '';
  String soilType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white, // Set app bar color
        title: Text(
          'I N S E R T N A M E',
          style: TextStyle(color: Colors.green), // Set app bar text color
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              height: 370,
              width: 350,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white, // Set container color
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Crop Name',
                      fillColor: Color(0xFFF0EFEF), // Set text box color
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        cropName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Field Size',
                      fillColor: Color(0xFFF0EFEF), // Set text box color
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        fieldSize = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Soil Type',
                      fillColor: Color(0xFFF0EFEF), // Set text box color
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        soilType = value;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(),
                        ),
                      );
                      // Handle submit button press
                      print('Crop Name: $cropName');
                      print('Field Size: $fieldSize');
                      print('Soil Type: $soilType');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(double.infinity, 50.0),
                    ),
                    child: Text(
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
}

