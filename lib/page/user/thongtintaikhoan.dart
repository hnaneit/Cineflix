import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Thongtintaikhoan extends StatefulWidget {
  const Thongtintaikhoan({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<Thongtintaikhoan> {
  Future<User>? futureUser;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      setState(() {
        futureUser = NetworkRequest.fetchUser(userId);
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dangnhap()),
      );
    }
  }

  Future<void> _deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      await NetworkRequest.deleteUser(userId);
      await prefs.remove('userId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dangnhap()),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tài khoản'),
        content: const Text('Bạn có chắc chắn muốn xóa tài khoản không?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser();
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông tin tài khoản',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: futureUser == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  User user = snapshot.data!;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileItem(
                            'Tên người dùng',
                            Text(user.username ?? ""),
                          ),
                          _buildProfileItem(
                            'Email',
                            Text(user.email ?? ""),
                          ),
                          ListTile(
                            title: const Text(
                              'Xóa tài khoản',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _confirmDelete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
    );
  }

  Widget _buildProfileItem(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
