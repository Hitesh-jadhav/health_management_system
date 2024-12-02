import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'health_data_screen.dart';
import 'register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  // Create an instance of FlutterSecureStorage
  final storage = FlutterSecureStorage();

  Future<void> loginUser(String username, String password) async {
    final String url = 'http://localhost:5000/login';
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Assuming the response contains the JWT token
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String token =
            responseData['token']; // Extract the token from the response

        // Store the token securely
        await storage.write(key: 'jwt_token', value: token);

        // Navigate to the health data screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthDataScreen(token: token),
          ),
        );
      } else {
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      loginUser(_username, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) => _username = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to RegisterScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
