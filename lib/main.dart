import 'package:app_cineflix/config/config.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:app_cineflix/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          home: const intermediatescreen(),
          title: 'Cineflix',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class intermediatescreen extends StatefulWidget {
  const intermediatescreen({super.key});

  @override
  State<intermediatescreen> createState() => _intermediatescreenState();
}

class _intermediatescreenState extends State<intermediatescreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      if (chedotoi) {
        themeProvider.toggleTheme();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      duration: 2000,
      nextScreen: const Dangnhap(),
      splash: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo0.png'),
                          fit: BoxFit.contain)),
                ),
              ),
            ],
          ),
        ),
      ),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 1500,
    );
  }
}
