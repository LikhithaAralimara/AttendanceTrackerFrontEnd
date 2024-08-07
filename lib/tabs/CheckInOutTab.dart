import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInOutTab extends StatefulWidget {
  final String userId;

  CheckInOutTab({required this.userId});
  @override
  _CheckInOutTabState createState() => _CheckInOutTabState();
}

class _CheckInOutTabState extends State<CheckInOutTab> {
  bool _isCheckingIn = false;
  bool _isCheckingOut = false;
  bool _checkedIn = false;
  String? _message;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadCheckInStatus();
  }

  Future<void> _loadCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkedIn = prefs.getBool('checkedIn') ?? false;
    });
  }

  Future<void> _saveCheckInStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkedIn', status);
  }

  Future<void> _checkIn() async {
    setState(() {
      _isCheckingIn = true;
      _message = null;
    });

    try {
      final response = await _dio.post(
        'https://0ec2-106-51-198-46.ngrok-free.app/attendance_api/check_in.php',
        data: {'user_id': "${widget.userId}"},
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      setState(() {
        _isCheckingIn = false;
        if (response.statusCode == 200) {
          _checkedIn = true;
          _message = 'Check-in successful';
          _saveCheckInStatus(true);
        } else {
          _message = 'Check-in failed. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _isCheckingIn = false;
        _message = 'An error occurred. Please try again.';
      });
    }
  }

  Future<void> _checkOut() async {
    setState(() {
      _isCheckingOut = true;
      _message = null;
    });

    try {
      final response = await _dio.post(
        'https://0ec2-106-51-198-46.ngrok-free.app/attendance_api/check_out.php',
        data: {'user_id': "${widget.userId}"},
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      setState(() {
        _isCheckingOut = false;
        if (response.statusCode == 200) {
          _checkedIn = false;
          _message = 'Check-out successful';
          _saveCheckInStatus(false);
        } else {
          _message = 'Check-out failed. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _isCheckingOut = false;
        _message = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: _checkedIn ? (_isCheckingOut ? null : _checkOut) : (_isCheckingIn ? null : _checkIn),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _checkedIn ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _isCheckingIn || _isCheckingOut
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text(
                  _checkedIn ? 'Check Out' : 'Check In',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          if (_message != null) ...[
            SizedBox(height: 20),
            Text(
              _message!,
              style: TextStyle(
                color: _message == 'Check-in successful' || _message == 'Check-out successful'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
