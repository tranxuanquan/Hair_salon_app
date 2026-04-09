import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/mock_api_service.dart';

class HistoryPage extends StatelessWidget {
  final MockApiService apiService = MockApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử")),
      body: FutureBuilder<List<BookingModel>>(
        future: apiService.getBookingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải lịch sử"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text("${booking.date} - ${booking.time}"),
                    subtitle: Text("Khách hàng: ${booking.customerName}"),
                    trailing: Text(booking.status, style: TextStyle(color: Colors.green)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
