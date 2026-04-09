import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final bookings = [
    "Nguyễn Văn A - 10:00",
    "Trần Văn B - 14:00",
    "Lê Văn C - 16:00"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(bookings[index]),
          );
        },
      ),
    );
  }
}
