// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MaterialApp(
//     home: RegisterScreen(),
//   ));
// }

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _username = '';
//   String _password = '';
//   String _email = '';

//   void _register() {
//     if (_formKey.currentState!.validate()) {
//       registerUser(
//           _username, _password, _email); // Call the registerUser function
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Username'),
//                 onChanged: (value) => _username = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter a username' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 onChanged: (value) => _email = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter an email' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 onChanged: (value) => _password = value,
//                 validator: (value) =>
//                     value!.length < 6 ? 'Password too short' : null,
//               ),
//               ElevatedButton(
//                 onPressed: _register,
//                 child: Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<void> registerUser(String username, String password, String email) async {
//   // The URL of the backend API endpoint
//   final String url =
//       'http://localhost:5000/register'; // Use your actual backend URL

//   // Prepare the data to send in the body of the request
//   final Map<String, String> data = {
//     'username': username,
//     'password': password,
//     'email': email,
//   };

//   try {
//     // Make the POST request
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type':
//             'application/json; charset=UTF-8', // Specify content type
//       },
//       body: jsonEncode(data), // Encode the data to JSON
//     );

//     // Check the response status code
//     if (response.statusCode == 201) {
//       // If the server returns a 201 Created response, the registration was successful
//       print('User registered successfully!');
//     } else {
//       // If the server did not return a 201 response, throw an exception
//       throw Exception('Failed to register user: ${response.body}');
//     }
//   } catch (error) {
//     print('Error: $error'); // Handle error
//   }
// }

// Future<void> getHealthData(String userId) async {
//   // The URL of the backend API endpoint
//   final String url =
//       'http://localhost:5000/health_data/$userId'; // Use your actual backend URL

//   try {
//     // Make the GET request
//     final response = await http.get(Uri.parse(url));

//     // Check the response status code
//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the JSON
//       final Map<String, dynamic> healthData = jsonDecode(response.body);
//       print('Health Data: $healthData'); // Use the health data as needed
//     } else {
//       throw Exception('Failed to load health data: ${response.body}');
//     }
//   } catch (error) {
//     print('Error: $error'); // Handle error
//   }
// }


import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),  // Start with the LoginScreen
    );
  }
}
