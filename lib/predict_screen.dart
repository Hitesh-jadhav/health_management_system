import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  String? _prediction;

  Future<void> makePrediction() async {
    if (_formKey.currentState!.validate()) {
      final String url = 'http://localhost:5000/predict'; // Replace with your API endpoint

      // Create a map with all required fields for prediction
      final inputData = {
        'age': _ageController.text,
        'bmi': _bmiController.text,
        'blood_pressure': _bloodPressureController.text,
        'cholesterol': _cholesterolController.text,
        'glucose': _glucoseController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(inputData),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _prediction = data['prediction'] != null
                ? data['prediction'].toString()
                : "No prediction found";
          });
        } else {
          print('Failed to get prediction: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predict Health Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bmiController,
                decoration: InputDecoration(labelText: "BMI"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter BMI';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bloodPressureController,
                decoration: InputDecoration(labelText: "Blood Pressure"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter blood pressure';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cholesterolController,
                decoration: InputDecoration(labelText: "Cholesterol"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cholesterol';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _glucoseController,
                decoration: InputDecoration(labelText: "Glucose"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter glucose';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: makePrediction,
                child: Text("Get Prediction"),
              ),
              SizedBox(height: 20.0),
              if (_prediction != null)
                Text(
                  "Prediction: $_prediction",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
