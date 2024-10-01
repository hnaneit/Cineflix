import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:app_cineflix/page/dangkydangnhap/nhapmaxacnhan.dart';
import 'package:flutter/material.dart';

class QuenMatKhau extends StatefulWidget {
  const QuenMatKhau({super.key});

  @override
  _QuenMatKhauState createState() => _QuenMatKhauState();
}

class _QuenMatKhauState extends State<QuenMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;
  String _emailError = '';
  Future<String?> getUserIdFromEmail(String email) async {
    try {
      List<User> users = await NetworkRequest.fetchUsers();
      for (var user in users) {
        if (user.email == email) {
          return user.id;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user by email: $e');
    }
  }

  Future<void> _submitEmail() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      bool isEmailValid = await isEmailTaken(email);

      if (isEmailValid) {
        try {
          final userId = await getUserIdFromEmail(email);
          if (userId != null) {
            setState(() {
              _isEmailSent = true;
              _emailError = '';
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MaXacNhan(id: userId),
              ),
            );
          } else {
            setState(() {
              _isEmailSent = false;
              _emailError = 'Không tìm thấy người dùng với email này.';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không tìm thấy người dùng với email này.'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi lấy thông tin người dùng: $e'),
            ),
          );
        }
      } else {
        setState(() {
          _isEmailSent = false;
          _emailError = 'Email không chính xác, vui lòng kiểm tra lại.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logongang.png',
                height: 100,
              ),
              const SizedBox(height: 180),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.onSecondary,
                      margin: const EdgeInsets.only(bottom: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Nhập email của bạn',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập email';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                    .hasMatch(value)) {
                                  return 'Email không hợp lệ';
                                }
                                if (_emailError.isNotEmpty) {
                                  return _emailError;
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
                                builder: (context) => const Dangnhap()),
                          );
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: _isEmailSent ? null : _submitEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 201, 65, 65),
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
                            'Xác Nhận',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> isEmailTaken(String email) async {
  try {
    List<String> emails = await NetworkRequest.fetchAllEmail();
    return emails.contains(email);
  } catch (e) {
    throw Exception('Failed to check user email: $e');
  }
}
