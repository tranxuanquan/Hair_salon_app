import 'package:flutter/material.dart';
import '../models/hair_style.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';

class MockDatabase {
  // 1. Danh sách Người dùng
  static List<UserModel> users = [
    UserModel(
      id: "u1",
      email: "admin@gmail.com",
      password: "123456",
      fullName: "Quản trị viên",
      role: "admin",
    ),
    UserModel(
      id: "u2",
      email: "user1@gmail.com",
      password: "123456",
      fullName: "Nguyễn Văn A",
      role: "user",
    ),
    UserModel(
      id: "u3",
      email: "user2@gmail.com",
      password: "123456",
      fullName: "Trần Thị B",
      role: "user",
    ),
    UserModel(
      id: "u4",
      email: "vip@gmail.com",
      password: "123456",
      fullName: "Lê Văn C (VIP)",
      role: "user",
    ),
  ];

  // 2. Danh sách Kiểu tóc
  static List<HairStyle> hairStyles = [
    HairStyle(
      id: "h1",
      name: "Undercut Classic",
      price: "120.000đ",
      imageUrl: "https://images.unsplash.com/photo-1621605815971-fbc98d665033",
    ),
    HairStyle(
      id: "h2",
      name: "Side Part 7/3",
      price: "100.000đ",
      imageUrl: "https://images.unsplash.com/photo-1517832606299-7ae9b720a186",
    ),
    HairStyle(
      id: "h3",
      name: "Korean Layer",
      price: "150.000đ",
      imageUrl: "https://images.unsplash.com/photo-1521119989659-a83eee488004",
    ),
    HairStyle(
      id: "h4",
      name: "Mohican",
      price: "130.000đ",
      imageUrl: "https://images.unsplash.com/photo-1599351474290-288d8466d7d2",
    ),
  ];

  // 3. Danh sách Dịch vụ
  static List<ServiceModel> services = [
    ServiceModel(id: "s1", title: "Cắt tóc", icon: Icons.cut),
    ServiceModel(id: "s2", title: "Nhuộm tóc", icon: Icons.color_lens),
    ServiceModel(id: "s3", title: "Uốn tóc", icon: Icons.face),
    ServiceModel(id: "s4", title: "Gội đầu & Massage", icon: Icons.waves),
  ];

  // 4. Danh sách Lịch đặt (Booking)
  static List<BookingModel> bookings = [
    BookingModel(
      id: "b1",
      customerName: "Nguyễn Văn A",
      date: "12/03/2026",
      time: "10:00",
      status: "Đã hoàn thành",
    ),
    BookingModel(
      id: "b2",
      customerName: "Trần Thị B",
      date: "01/03/2026",
      time: "14:00",
      status: "Đã hoàn thành",
    ),
  ];
}
