import 'package:flutter/material.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';

class DoiMatKhau extends StatefulWidget {
  final String userId;

  const DoiMatKhau({super.key, required this.userId});

  @override
  _DoiMatKhauState createState() => _DoiMatKhauState();
}

class _DoiMatKhauState extends State<DoiMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureTextNewPassword = true;
  bool _obscureTextConfirmPassword = true;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự viết hoa';
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
    }
    return null;
  }

  Future<void> _submitNewPassword() async {
    if (_formKey.currentState!.validate()) {
      final newPassword = _newPasswordController.text.trim();
      try {
        bool isUpdated =
            await NetworkRequest.updateUserPassword(widget.userId, newPassword);
        if (isUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đổi mật khẩu thành công!'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Dangnhap()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đổi mật khẩu thất bại: $e'),
          ),
        );
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
                              controller: _newPasswordController,
                              obscureText: _obscureTextNewPassword,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu mới',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureTextNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextNewPassword =
                                          !_obscureTextNewPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureTextConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Nhập lại mật khẩu',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureTextConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextConfirmPassword =
                                          !_obscureTextConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập lại mật khẩu';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Mật khẩu không khớp';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: _submitNewPassword,
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
                            'Đổi mật khẩu',
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
