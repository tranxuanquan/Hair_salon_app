import '../models/hair_style.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import 'mock_database.dart';

class MockApiService {
  // Giả lập độ trễ mạng
  Future<void> _networkDelay() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  // 1. Xác thực đăng nhập
  Future<UserModel?> login(String email, String password) async {
    await _networkDelay();
    try {
      return MockDatabase.users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // 2. Lấy danh sách kiểu tóc từ DB
  Future<List<HairStyle>> getHairStyles() async {
    await _networkDelay();
    return MockDatabase.hairStyles;
  }

  // 3. Lấy danh sách dịch vụ từ DB
  Future<List<ServiceModel>> getServices() async {
    await _networkDelay();
    return MockDatabase.services;
  }

  // 4. Lấy lịch sử đặt lịch từ DB
  Future<List<BookingModel>> getBookingHistory() async {
    await _networkDelay();
    return MockDatabase.bookings;
  }

  // 5. Thêm lịch đặt mới vào DB
  Future<bool> createBooking(String name, String date, String time) async {
    await _networkDelay();
    final newBooking = BookingModel(
      id: "b${MockDatabase.bookings.length + 1}",
      customerName: name,
      date: date,
      time: time,
      status: "Chờ xác nhận",
    );
    MockDatabase.bookings.add(newBooking);
    return true;
  }
}
