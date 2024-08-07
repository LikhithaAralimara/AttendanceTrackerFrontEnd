import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sdk/tabs/CheckInOutTab.dart';
import 'package:sdk/tabs/HistoryTab.dart';

class DashboardPage extends StatelessWidget {
  final String userId;
  final String userName;
  final String userEmail;

  DashboardPage({required this.userId,required this.userName, required this.userEmail});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: CircleAvatar(
                radius: 20, // Size of the circle
                backgroundColor: Colors.blue, // Background color of the circle
                child: Icon(
                  Icons.person, // Icon to display
                  size: 30, // Size of the icon
                  color: Colors.white, // Color of the icon
                ),
              ),
              onPressed: () {
                // Show user details in a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('User Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: $userName'),
                          Text('Email: $userEmail'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          title: Text('Attendance Tracker App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'PunchIn&Out'),
              Tab(text: 'Attendance History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CheckInOutTab(userId: userId,),
            AttendanceHistoryTab(userId: userId,),
          ],
        ),
      ),
    );
  }
}

