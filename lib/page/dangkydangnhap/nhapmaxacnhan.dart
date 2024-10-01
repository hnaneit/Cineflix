import 'package:app_cineflix/page/dangkydangnhap/taomkmoi.dart';
import 'package:flutter/material.dart';

class MaXacNhan extends StatefulWidget {
  final String id;
  const MaXacNhan({super.key, required this.id});

  @override
  _MaXacNhanState createState() => _MaXacNhanState();
}

class _MaXacNhanState extends State<MaXacNhan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _isCodeValid = false;

  static const String defaultVerificationCode = '240724';

  Future<void> _submitCode() async {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim();

      if (code == defaultVerificationCode) {
        setState(() {
          _isCodeValid = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoiMatKhau(userId: widget.id)),
        );
      } else {
        setState(() {
          _isCodeValid = false;
        });
        _formKey.currentState!.validate();
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
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Nhập mã xác nhận',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                focusedBorder: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mã xác nhận';
                                }
                                if (value != defaultVerificationCode) {
                                  return 'Mã xác nhận không chính xác, vui lòng kiểm tra lại.';
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
                      onPressed: _submitCode,
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
