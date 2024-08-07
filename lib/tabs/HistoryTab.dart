import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AttendanceHistoryTab extends StatefulWidget {
  final String userId;

  AttendanceHistoryTab({required this.userId});

  @override
  _AttendanceHistoryTabState createState() => _AttendanceHistoryTabState();
}

class _AttendanceHistoryTabState extends State<AttendanceHistoryTab> {
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _attendanceList = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceHistory();
  }

  Future<void> _fetchAttendanceHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dio.get(
        'https://0ec2-106-51-198-46.ngrok-free.app/attendance_api/attendance_history.php',
        queryParameters: {'user_id': "${widget.userId}"},
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          _attendanceList = response.data;
        } else {
          _errorMessage =
              'Failed to fetch attendance history. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : _errorMessage != null
              ? Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                )
              : _attendanceList.isEmpty
                  ? Text('No attendance records found.')
                  : ListView.builder(
                      itemCount: _attendanceList.length,
                      itemBuilder: (context, index) {
                        final record = _attendanceList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              CheckInItem(checkInTime: record['check_in_time']),
                              if (record['check_out_time'] != null)
                                CheckOutItem(
                                    checkOutTime: record['check_out_time'])
                              else
                                StillCheckedInItem(),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}

class CheckInItem extends StatelessWidget {
  final String checkInTime;

  CheckInItem({required this.checkInTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      color: Colors.green[50],
      child: ListTile(
        leading: Icon(
          Icons.login,
          color: Colors.green,
          size: 40,
        ),
        title: Text(
          'Check-in: $checkInTime',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ),
    );
  }
}

class CheckOutItem extends StatelessWidget {
  final String checkOutTime;

  CheckOutItem({required this.checkOutTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      color: Colors.red[50],
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red,
          size: 40,
        ),
        title: Text(
          'Check-out: $checkOutTime',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
      ),
    );
  }
}

class StillCheckedInItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      color: Colors.orange[50],
      child: ListTile(
        leading: Icon(
          Icons.timer,
          color: Colors.orange,
          size: 40,
        ),
        title: Text(
          'Still Checked In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
      ),
    );
  }
}
