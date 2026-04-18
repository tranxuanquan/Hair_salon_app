import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Khách hàng thân thiết",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            _buildInfoTile(Icons.badge, "Họ và tên", user.fullName),
            _buildInfoTile(Icons.person_outline, "Tên đăng nhập", user.username),
            _buildInfoTile(Icons.security, "Vai trò", user.role == 'admin' ? 'Quản trị viên' : 'Khách hàng'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("QUAY LẠI"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
