import 'package:flutter/material.dart';
import 'package:app_cineflix/model/movie_detail.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/phim.dart';
import 'package:app_cineflix/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import để sử dụng SharedPreferences

import 'dart:async';

class thongtinphim extends StatefulWidget {
  final String movieSlug;
  const thongtinphim({
    super.key,
    required this.movieSlug,
  });

  @override
  State<thongtinphim> createState() => _thongtinphimState();
}

class _thongtinphimState extends State<thongtinphim> {
  late Future<chiTietPhim> futureChiTietPhim;
  bool _showBackButton = true;
  Timer? _timer;
  bool isInFavorites = false;
  List<dynamic> favoriteFilms = [];
  String? idUser; // Khai báo biến idUser

  @override
  void initState() {
    super.initState();
    _loadSession();
    futureChiTietPhim = NetworkRequest.fetchChiTiet(query: widget.movieSlug);
    _startTimer();

    // Gọi hàm _loadSession để lấy idUser
  }

  Future<void> _loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getString('userId');
    });
    if (idUser != null) {
      checkIsFavorite();
      fetchFavoriteFilms();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showBackButton = false;
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
    setState(() {
      _showBackButton = true;
    });
  }

  Future<void> fetchFavoriteFilms() async {
    if (idUser == null) return; // Kiểm tra idUser có giá trị không

    try {
      final userData = await NetworkRequest.fetchUser(idUser!);
      final yeuThichList = userData['yeuthich'] is List
          ? userData['yeuthich'] as List<dynamic>
          : [];
      setState(() {
        favoriteFilms = yeuThichList;
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách yêu thích: $e');
    }
  }

  Future<void> checkIsFavorite() async {
    if (idUser == null) return; // Kiểm tra idUser có giá trị không

    try {
      final userData = await NetworkRequest.fetchUser(idUser!);
      final yeuThichList = userData['yeuthich'] is List
          ? userData['yeuthich'] as List<dynamic>
          : [];
      setState(() {
        isInFavorites = yeuThichList.isNotEmpty &&
            yeuThichList.any((item) {
              if (item is Yeuthich) {
                return item.sulgname == widget.movieSlug;
              } else {
                return item['sulgname'] == widget.movieSlug;
              }
            });
      });
    } catch (e) {
      print('Lỗi khi kiểm tra yêu thích: $e');
    }
  }

  void toggleFavoriteStatus(
      String name, String sulgname, String thumburl) async {
    if (idUser == null) return; // Kiểm tra idUser có giá trị không

    setState(() {
      isInFavorites = !isInFavorites;
    });

    try {
      if (isInFavorites) {
        await NetworkRequest.addFavorite(idUser!, name, sulgname, thumburl);
      } else {
        await NetworkRequest.removeFavorite(idUser!, sulgname);
      }
      fetchFavoriteFilms();
      checkIsFavorite();
    } catch (e) {
      setState(() {
        isInFavorites = !isInFavorites;
      });
      print('Lỗi khi thay đổi yêu thích: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _resetTimer,
        child: SafeArea(
          child: FutureBuilder<chiTietPhim>(
            future: futureChiTietPhim,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else {
                final movie = snapshot.data!.movie!;
                return Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 9 * 12,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(movie.posterUrl ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Text(
                            movie.name ?? '',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Text(
                            '| ${movie.year ?? ''} | ${movie.country![0].name ?? ''} | ${movie.category![0].name ?? ''}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 15, 40, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (idUser != null) {
                                    NetworkRequest.addWatchHistory(
                                      idUser!,
                                      movie.name ?? "",
                                      movie.slug ?? "",
                                      movie.thumbUrl ?? "",
                                      "1",
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhimWidget(
                                          movieSlug: movie.slug ?? '',
                                          tap: "1",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: Row(
                                  children: [
                                    const Text('Xem Ngay'),
                                    const SizedBox(width: 8.0),
                                    Icon(
                                      Icons.play_arrow,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isInFavorites
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isInFavorites ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  if (idUser != null) {
                                    toggleFavoriteStatus(movie.name ?? "",
                                        movie.slug ?? "", movie.thumbUrl ?? "");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text(
                            movie.content ?? '',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  if (_showBackButton)
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ]);
              }
            },
          ),
        ),
      ),
    );
  }
}
