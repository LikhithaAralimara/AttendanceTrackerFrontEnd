import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sdk/Dashboard.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final Dio _dio = Dio(); // Create a Dio instance

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // try {
      final response = await _dio.post(
        'https://0ec2-106-51-198-46.ngrok-free.app/attendance_api/login.php',
        // 'http://localhost/attendance_api/attendance_history.php?user_id=1',
        // 'http://localhost/attendance_api/login.php', // Update with your deployed API URL
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'email': email,
          'password': password,
        },
      );

      print(response);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['error'] != null) {
          setState(() {
            _errorMessage = data['error'];
          });
        } else {
          // Navigate to another page on successful login
          final user = data['user'];
          final userName = user['name'];
          final userEmail = user['email'];
          final userId = user['id'];
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => DashboardPage(userEmail: userEmail,userName: userName,userId: userId,)));
        }
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    // } catch (e) {
    //   print(e);
    //   setState(() {
    //     _isLoading = false;
    //     _errorMessage = 'An error occurred. Please try again.';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: false,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
