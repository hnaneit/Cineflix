import 'package:app_cineflix/page/home/home.dart';
import 'package:app_cineflix/page/lichsu/lichsu.dart';
import 'package:app_cineflix/page/khophim/khophim.dart';
import 'package:app_cineflix/page/user/userwidget.dart';
import 'package:app_cineflix/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    PhatHien(),
    LichSuWidget(),
    UserPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Kho phim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tôi',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
