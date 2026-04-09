import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/mock_api_service.dart';
import 'profile_screen.dart';

class HomePage extends StatelessWidget {
  final MockApiService apiService = MockApiService();

  Widget serviceCard(ServiceModel service) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(service.icon, size: 36, color: Colors.blue),
          SizedBox(height: 10),
          Text(service.title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hair Salon"),
        actions: [
          IconButton(
            icon: CircleAvatar(child: Icon(Icons.person)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Dịch vụ nổi bật", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          FutureBuilder<List<ServiceModel>>(
            future: apiService.getServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Lỗi tải dữ liệu"));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!.map((s) => serviceCard(s)).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
