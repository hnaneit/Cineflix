import 'package:app_cineflix/page/dangkydangnhap/quenmatkhau.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/mainPage.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangky.dart';
import 'package:app_cineflix/page/dangkydangnhap/huongdansudung.dart';

class Dangnhap extends StatefulWidget {
  const Dangnhap({super.key});

  @override
  _DangnhapState createState() => _DangnhapState();
}

class _DangnhapState extends State<Dangnhap> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<User?> loginUser(String email, String password) async {
    List<User> users = await NetworkRequest.fetchUsers();
    for (User user in users) {
      if (user.email == email && user.password == password) {
        return user;
      }
    }
    return null;
  }

  Future<void> _saveUserSession(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id ?? '');
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const mainPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logongang.png',
                    height: 100,
                  ),
                  const SizedBox(height: 120),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 4,
                          //  color: Theme.of(context).colorScheme.onSecondary,
                          margin: const EdgeInsets.only(bottom: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: const OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    focusedBorder: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu',
                                    border: const OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    focusedBorder: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập mật khẩu';
                                    } else if (value.length < 8) {
                                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QuenMatKhau()),
                              );
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              User? user = await loginUser(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (user != null) {
                                await _saveUserSession(user);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const mainPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.error, color: Colors.red),
                                        SizedBox(width: 10),
                                        Text(
                                            'Tên đăng nhập hoặc mật khẩu không đúng!',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 161, 31, 49),
                                          width: 2),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 201, 65, 65),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const SizedBox(
                            width: 120,
                            child: Center(
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bạn chưa có tài khoản?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dangky()),
                                );
                              },
                              child: Text(
                                'Đăng ký',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VideoPlayerScreen()),
                              );
                            },
                            child: Text(
                              'Hướng dẫn sử dụng',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
