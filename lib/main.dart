import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pdf_viewer.dart';
import 'AddPdfViewer.dart';
import 'Profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data == true) {
              return SecondScreen();
            } else {
              return MyHomePage();
            }
          },
        ),
        '/second': (context) => SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _postData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String apiUrl = 'https://haiton26062.pythonanywhere.com/user/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      prefs.setString('phone', responseData['phone'].toString());
      prefs.setString('address', responseData['address'].toString());
      prefs.setString('email', responseData['email'].toString());
      prefs.setString('username', responseData['username'].toString());
      prefs.setString('id', responseData['id'].toString());
      prefs.setString('token', responseData['access_token'].toString());

      Navigator.pushNamed(context, '/second');
    } else {
      print('Failed to post data. Error code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter POST API Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _postData();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPdfViewer()), // Điều hướng đến màn hình PDF
                );
              },
              child: Text('PDF'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPdfViewer()), // Điều hướng đến màn hình PDF
                );
              },
              child: Text('Add pdf'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()), // Điều hướng đến màn hình PDF
                );
              },
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }


  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('username');
    prefs.remove('address');
    prefs.remove('phone');
    prefs.remove('id');
    prefs.remove('token');


    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
