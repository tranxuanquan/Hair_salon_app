import 'package:flutter/material.dart';
import '../database/firebase_service.dart';
import '../models/user_model.dart';
import '../main.dart';
import 'register_screen.dart';
import 'admin_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ thông tin!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await FirebaseService.login(email, password);
      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => user.role == 'admin' 
                ? const AdminHomeScreen() 
                : MainScreen(user: user),
          ),
        );
      } else {
        _showSnackBar("Sai email hoặc mật khẩu!");
      }
    } catch (e) {
      _showSnackBar("Lỗi đăng nhập: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Icon(Icons.cut_rounded, size: 80, color: Colors.blue),
              const SizedBox(height: 10),
              const Text("HAIR SALON", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _buildTextField(_emailController, "Email", Icons.email_outlined),
              const SizedBox(height: 15),
              _buildTextField(_passwordController, "Mật khẩu", Icons.lock_outline, isPassword: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ĐĂNG NHẬP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                child: const Text("Chưa có tài khoản? Đăng ký ngay"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
