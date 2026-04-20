import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/hair_style.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream để lắng nghe trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- AUTHENTICATION ---
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getUserRole(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return "Email chưa đăng ký.";
      if (e.code == 'wrong-password') return "Sai mật khẩu.";
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.get('role') ?? 'user';
    }
    return "error: profile-not-found";
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> register(String email, String password, String fullName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String role = email.toLowerCase().contains("admin") ? 'admin' : 'user';

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUserId == null) return null;
    DocumentSnapshot doc = await _db.collection('users').doc(currentUserId).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // --- QUẢN LÝ NGƯỜI DÙNG (NEW) ---
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _db.collection('users').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
        };
      }).toList();
    });
  }

  Future<void> updateUserRole(String uid, String newRole) async {
    await _db.collection('users').doc(uid).update({'role': newRole});
  }

  // --- DỮ LIỆU ---
  Stream<List<HairStyle>> getHairStylesStream() {
    return _db.collection('hairStyles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => HairStyle.fromMap({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    });
  }

  Stream<List<HairStyle>> getHairStylesByCategory(String category) {
    return _db.collection('hairStyles')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => HairStyle.fromMap({
          'id': doc.id,
          ...doc.data(),
        })).toList());
  }

  Stream<List<ServiceModel>> getServicesStream() {
    return _db.collection('services').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromMap({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    });
  }

  // --- BOOKING ---
  Future<void> createBooking({
    required String customerName,
    required String service,
    required String barber,
    required String date,
    required String time,
    required String paymentMethod,
  }) async {
    final uid = _auth.currentUser?.uid;
    await _db.collection('bookings').add({
      'userId': uid,
      'customerName': customerName,
      'service': service,
      'barber': barber,
      'date': date,
      'time': time,
      'paymentMethod': paymentMethod,
      'status': 'Chờ xác nhận',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<BookingModel>> getAllBookingsStream() {
    return _db.collection('bookings').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromMap({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    });
  }

  Stream<List<BookingModel>> getUserBookingsStream(String userId) {
    return _db.collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromMap({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    });
  }

  Future<void> updateBookingStatus(String id, String newStatus) async {
    await _db.collection('bookings').doc(id).update({'status': newStatus});
  }

  // --- SEED DATA ---
  Future<void> seedFullDatabase() async {
    final styles = [
      {"name": "Undercut Modern", "price": 120000, "cat": "Cắt tóc", "img": "https://images.unsplash.com/photo-1621605815971-fbc98d665033"},
      {"name": "Side Part Luxury", "price": 100000, "cat": "Cắt tóc", "img": "https://images.unsplash.com/photo-1517832606299-7ae9b720a186"},
      {"name": "Korean Layer", "price": 150000, "cat": "Cắt tóc", "img": "https://images.unsplash.com/photo-1521119989659-a83eee488004"},
      {"name": "Uốn Preppy", "price": 250000, "cat": "Uốn tóc", "img": "https://images.unsplash.com/photo-1599351474290-288d8466d7d2"},
      {"name": "Nhuộm Xám Khói", "price": 300000, "cat": "Nhuộm tóc", "img": "https://images.unsplash.com/photo-1517832606299-7ae9b720a186"},
    ];
    for (var s in styles) {
      await _db.collection('hairStyles').add({
        'name': s['name'], 'price': s['price'], 'category': s['cat'], 'imageUrl': s['img'],
      });
    }

    final services = [
      {"title": "Cắt tóc", "iconCode": Icons.cut.codePoint},
      {"title": "Uốn tóc", "iconCode": Icons.face.codePoint},
      {"title": "Nhuộm tóc", "iconCode": Icons.color_lens.codePoint},
      {"title": "Gội & Massage", "iconCode": Icons.waves.codePoint},
    ];
    for (var s in services) {
      await _db.collection('services').add({'title': s['title'], 'iconCode': s['iconCode']});
    }

    final barbers = ["Nguyễn Văn A (Senior)", "Trần Văn B (Pro)", "Lê Văn C (Junior)"];
    for (var name in barbers) {
      await _db.collection('barbers').add({'name': name});
    }
  }

  // --- ADMIN METHODS ---
  Future<void> addHairStyle(String name, int price, String imageUrl, {String category = 'Cắt tóc'}) async {
    await _db.collection('hairStyles').add({'name': name, 'price': price, 'imageUrl': imageUrl, 'category': category});
  }

  Future<void> updateHairStyle(String id, String name, int price, String imageUrl, String category) async {
    await _db.collection('hairStyles').doc(id).update({
      'name': name, 'price': price, 'imageUrl': imageUrl, 'category': category
    });
  }

  Future<void> deleteHairStyle(String id) async {
    await _db.collection('hairStyles').doc(id).delete();
  }

  Future<void> addService(String title, int iconCode) async {
    await _db.collection('services').add({'title': title, 'iconCode': iconCode});
  }

  Future<void> updateService(String id, String title, int iconCode) async {
    await _db.collection('services').doc(id).update({'title': title, 'iconCode': iconCode});
  }

  Future<void> deleteService(String id) async {
    await _db.collection('services').doc(id).delete();
  }
}
