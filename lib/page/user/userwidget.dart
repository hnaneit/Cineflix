import 'package:flutter/material.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:app_cineflix/page/user/caidat.dart';
import 'package:app_cineflix/page/user/thongtintaikhoan.dart';
import 'package:app_cineflix/page/user/yeuthich.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User?> futureUser = Future.value(null);

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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dangnhap()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user == null) {
              return const Center(child: Text('No data'));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              user.avata != null && user.avata!.isNotEmpty
                                  ? NetworkImage(user.avata!)
                                  : const AssetImage('assets/images/user.jpg')
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          user.username ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ProfileMenuItem(
                    icon: Icons.person,
                    title: 'Thông tin tài khoản',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Thongtintaikhoan(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: 'Yêu thích',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YeuThichWidget(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    title: 'Cài đặt',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Caidat(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.help,
                    title: 'Đóng góp ý kiến',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.info,
                    title: 'Thông tin',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: _logout,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const ProfileStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
