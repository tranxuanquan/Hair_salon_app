import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  Widget buildField(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: TextField(
        decoration: InputDecoration(
          labelText: text,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt lịch"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildField("Tên khách hàng"),
            buildField("Ngày đặt lịch"),
            buildField("Giờ đặt lịch"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Xác nhận đặt lịch"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
