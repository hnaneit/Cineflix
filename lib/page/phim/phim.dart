import 'dart:async';
import 'package:app_cineflix/model/movie_detail.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/dexuatphim.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhimWidget extends StatefulWidget {
  String movieSlug;
  String tap;
  PhimWidget({super.key, required this.movieSlug, required this.tap});

  @override
  State<PhimWidget> createState() => _PhimWidgetState();
}

class _PhimWidgetState extends State<PhimWidget> {
  late Future<chiTietPhim> futureChiTietPhim;
  bool _showBackButton = true;
  Timer? _timer;
  String? session;

  @override
  void initState() {
    super.initState();
    _loadSession();
    futureChiTietPhim = NetworkRequest.fetchChiTiet(query: widget.movieSlug);
    _startTimer();
  }

  Future<void> _loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    session = prefs.getString('userId');
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
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

  @override
  void didUpdateWidget(covariant PhimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movieSlug != widget.movieSlug) {
      setState(() {
        futureChiTietPhim =
            NetworkRequest.fetchChiTiet(query: widget.movieSlug);
      });
    }
  }

  Future<void> _navigateAndSelectFilm(BuildContext context) async {
    final selectedFilmName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeXuat()),
    );

    if (selectedFilmName != null) {
      setState(() {
        widget.movieSlug = selectedFilmName;
        futureChiTietPhim =
            NetworkRequest.fetchChiTiet(query: widget.movieSlug);
      });
    }
  }

  void _updateEpisode(int index, String name, String slug, String thumburl) {
    setState(() {
      widget.tap = (index + 1).toString(); // Cập nhật tập phim
      futureChiTietPhim = NetworkRequest.fetchChiTiet(query: widget.movieSlug);
      if (session != null) {
        NetworkRequest.addWatchHistory(
          session!,
          name,
          slug,
          thumburl,
          widget.tap,
        ); // Tải lại dữ liệu
      }
    });
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
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              } else {
                int tapphim = int.parse(widget.tap) - 1;
                final movie = snapshot.data!.movie!;
                final episodes = snapshot.data!.episodes!;
                final firstEpisode = episodes.isNotEmpty ? episodes[0] : null;
                String? embedLink = firstEpisode != null &&
                        firstEpisode.serverData != null &&
                        firstEpisode.serverData!.isNotEmpty
                    ? firstEpisode.serverData![tapphim].linkEmbed
                    : null;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            child: embedLink != null
                                ? WebViewWidget(
                                    controller: WebViewController()
                                      ..setJavaScriptMode(
                                          JavaScriptMode.unrestricted)
                                      ..loadRequest(Uri.parse(embedLink)),
                                  )
                                : const Center(
                                    child: Text('Không có liên kết')),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: Text(
                              movie.name ?? '',
                              style: TextStyle(
                                fontSize: 20.0,
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
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: ReadMoreText(
                              movie.content ?? '',
                              trimLines: 3,
                              colorClickableText:
                                  Theme.of(context).colorScheme.primary,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Xem thêm',
                              trimExpandedText: 'Thu gọn',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              moreStyle: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              lessStyle: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),

                          /////////// danh sach tap phim
                          if (movie.type == 'series')
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                              child: Text(
                                'Danh sách tập phim',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          if (movie.type == 'series')
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: episodes.isNotEmpty
                                    ? episodes[0].serverData?.length ?? 0
                                    : 0,
                                itemBuilder: (context, index) {
                                  final episode =
                                      episodes[0].serverData![index];
                                  bool isCurrentEpisode = index == tapphim;
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _updateEpisode(
                                            index,
                                            movie.name ?? '',
                                            movie.slug ?? '',
                                            movie.thumbUrl ?? '');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isCurrentEpisode
                                            ? Colors.red
                                            : Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        side: BorderSide(
                                          color: isCurrentEpisode
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      child: Text(
                                        episode.name ?? "",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isCurrentEpisode
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                            child: Text(
                              'Đề xuất cho bạn',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                            child: Container(
                              height: 3,
                              width: 145,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 1450,
                            child: DeXuat(),
                          ),
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
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
