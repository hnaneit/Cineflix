import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:flutter/material.dart';

class Dangky extends StatefulWidget {
  const Dangky({super.key});

  @override
  _DangkyState createState() => _DangkyState();
}

class _DangkyState extends State<Dangky> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? _password;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

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
    _password = value;
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    } else if (value != _password) {
      return 'Mật khẩu không khớp';
    }
    return null;
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
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.onSecondary,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              key: const Key('email'),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.email),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: userNameController,
                              key: const Key('userName'),
                              decoration: InputDecoration(
                                labelText: 'Tên người dùng',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập tên người dùng';
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
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
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            bool isTaken =
                                await isEmailTaken(emailController.text.trim());
                            if (isTaken) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Email đã tồn tại, vui lòng sử dụng email khác!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            int newId = await generateNewId();
                            User newUser = User(
                              id: newId.toString(),
                              username: userNameController.text.trim(),
                              password: passwordController.text.trim(),
                              email: emailController.text.trim(),
                              yeuthich: [],
                              lichsu: [],
                              timkiem: [],
                              avata: '',
                            );

                            NetworkRequest.registerUser(newUser)
                                .then((registeredUser) {
                              if (registeredUser != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.green),
                                        SizedBox(width: 10),
                                        Text('Đăng ký thành công!',
                                            style:
                                                TextStyle(color: Colors.green)),
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
                                          color: Colors.green, width: 2),
                                    ),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dangnhap()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đăng ký thất bại!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi tạo ID: $e'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 201, 65, 65),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const SizedBox(
                        width: 120,
                        child: Center(
                          child: Text(
                            'Đăng ký',
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn đã có tài khoản?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dangnhap()),
                      );
                    },
                    child: Container(
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int> generateNewId() async {
  try {
    List<int> ids = await NetworkRequest.fetchAllIds();
    if (ids.isNotEmpty) {
      return ids.reduce((curr, next) => curr > next ? curr : next) + 1;
    } else {
      return 1;
    }
  } catch (e) {
    throw Exception('Failed to generate new ID: $e');
  }
}

Future<bool> isEmailTaken(String email) async {
  try {
    List<String> emails = await NetworkRequest.fetchAllEmail();
    return emails.contains(email);
  } catch (e) {
    throw Exception('Failed to check user name: $e');
  }
}
