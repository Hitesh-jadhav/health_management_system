import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart'; 

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Define _formKey correctly as a GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _email = '';

  Future<void> registerUser(String username, String password, String email) async {
    final String url = 'http://localhost:5000/register';
    final Map<String, String> data = {
      'username': username,
      'password': password,
      'email': email,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('User registered successfully!');
        Navigator.pop(context);  // Navigate back after successful registration
      } else {
        print('Failed to register user: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _register() {
    // Use _formKey to validate form inputs
    if (_formKey.currentState!.validate()) {
      registerUser(_username, _password, _email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Assign _formKey to the Form widget
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) => _username = value,
                validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => _email = value,
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) => value!.length < 6 ? 'Password too short' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
              onPressed: () {
                // Navigate to LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Already have an account? Login"),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
