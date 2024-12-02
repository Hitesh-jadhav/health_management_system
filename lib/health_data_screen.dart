import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'predict_screen.dart';

class HealthDataScreen extends StatefulWidget {
  final String token;

  HealthDataScreen({required this.token});

  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  Map<String, dynamic>? healthData;

  Future<void> fetchHealthData() async {
    final String url = 'http://localhost:5000/health_data';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          healthData = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch health data: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Data"),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              // Navigate to the PredictScreen when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PredictScreen()),
              );
            },
          ),
        ],
      ),
      body: healthData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: healthData!.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value.toString()),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
