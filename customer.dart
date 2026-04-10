class Customer {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String service;
  final String barber;
  final String date;
  final String time;
  final String createdAt;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.email,
    required this.service,
    required this.barber,
    required this.date,
    required this.time,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'service': service,
      'barber': barber,
      'date': date,
      'time': time,
      'created_at': createdAt,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      service: map['service'] ?? '',
      barber: map['barber'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
