import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/theme/theme.dart';
import 'package:app_cineflix/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Caidat extends StatefulWidget {
  const Caidat({super.key});

  @override
  State<Caidat> createState() => _CaidatState();
}

class _CaidatState extends State<Caidat> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Chế độ tối',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.themeData == darkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Xóa lịch sử tìm kiếm',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (userId != null) {
                    try {
                      NetworkRequest.clearSearchHistory(userId!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lịch sử tìm kiếm đã được xóa')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Không thể xóa lịch sử tìm kiếm')),
                      );
                    }
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Xóa lịch sử xem',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (userId != null) {
                    try {
                      NetworkRequest.clearWatchHistory(userId!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lịch sử xem đã được xóa')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Không thể xóa lịch sử xem')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
