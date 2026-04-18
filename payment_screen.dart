import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String service;
  final String barber;
  final String customerName;
  final String date;
  final String time;

  const PaymentScreen({
    super.key,
    required this.service,
    required this.barber,
    required this.customerName,
    required this.date,
    required this.time,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Tiền mặt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Chi tiết đặt lịch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildDetailCard(),
            const SizedBox(height: 30),
            const Text("Chọn phương thức thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPaymentOptions(),
            if (_paymentMethod == "Chuyển khoản") _buildQRCode(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  _showSuccessDialog();
                },
                child: const Text("HOÀN TẤT ĐẶT LỊCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _rowInfo("Khách hàng", widget.customerName),
            _rowInfo("Dịch vụ", widget.service),
            _rowInfo("Thời gian", "${widget.time} - ${widget.date}"),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text("Tiền mặt"),
          value: "Tiền mặt",
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
        RadioListTile<String>(
          title: const Text("Chuyển khoản QR"),
          value: "Chuyển khoản",
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v!),
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Image.network("https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=SalonPayment", width: 150),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Thành công!"),
        content: const Text("Lịch hẹn của bạn đã được gửi đến Salon. Hẹn gặp lại bạn!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("XÁC NHẬN"),
          ),
        ],
      ),
    );
  }
}
