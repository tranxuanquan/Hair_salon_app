import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/style_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/history_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/profile_screen.dart';
import 'services/mock_api_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(HairSalonApp());
}

class HairSalonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hair Salon Premium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isLoading = false;
  final MockApiService apiService = MockApiService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    setState(() => isLoading = true);

    UserModel? user = await apiService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (user != null) {
      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email hoặc mật khẩu không đúng!")),
      );
    }
  }

  Widget buildInput(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.cut, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  isLogin ? "Đăng nhập" : "Đăng ký",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                buildInput("Email", emailController),
                buildInput("Mật khẩu", passwordController, obscure: true),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(isLogin ? "Đăng nhập" : "Đăng ký"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? "Chưa có tài khoản? Đăng ký"
                        : "Đã có tài khoản? Đăng nhập",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = [
    HomePage(),
    StylePage(),
    BookingPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.cut), label: "Kiểu tóc"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Đặt lịch"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Lịch sử"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}
