import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/dangkydangnhap/dangnhap.dart';
import 'package:app_cineflix/page/phim/chitietphim.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YeuThichWidget extends StatefulWidget {
  const YeuThichWidget({super.key});

  @override
  State<YeuThichWidget> createState() => _YeuThichState();
}

class _YeuThichState extends State<YeuThichWidget> {
  late Future<User> futureUser;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phim yêu thích',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            if (user.yeuthich == null || user.yeuthich!.isEmpty) {
              return const Center(child: Text('Chưa có phim yêu thích'));
            }
            return ListView.builder(
              itemCount: user.yeuthich!.length,
              itemBuilder: (context, index) {
                var movie = user.yeuthich![index];
                String? movieSlug = movie.sulgname ?? "";
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => thongtinphim(
                          movieSlug: movieSlug,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 90,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(movie.thumbUrl ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          width: 180,
                          child: Text(
                            movie.name ?? "",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
}
