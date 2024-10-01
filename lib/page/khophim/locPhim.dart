import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/phim.dart';
import 'package:app_cineflix/page/timkiem/thongtintimkiem.dart';
import 'package:flutter/material.dart';

class locPhim extends StatefulWidget {
  final String? countries;
  final String? genres;
  final String? movieTypes;

  const locPhim({
    super.key,
    required this.countries,
    required this.genres,
    required this.movieTypes,
  });

  @override
  State<locPhim> createState() => _locPhimState();
}

class _locPhimState extends State<locPhim> {
  late Future<List<Items>> futureFilms;
  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    if (widget.movieTypes == null || widget.movieTypes == 'Phim Bộ/Lẻ') {
      futureFilms = NetworkRequest.fetchFilms();
    } else if (widget.movieTypes == 'Phim Bộ') {
      futureFilms = NetworkRequest.fetchFilmBos();
    } else if (widget.movieTypes == 'Phim Lẻ') {
      futureFilms = NetworkRequest.fetchFilmLes();
    } else if (widget.movieTypes == 'Phim Hoạt Hình') {
      futureFilms = NetworkRequest.fetchFilmHoatHinhs();
    }
  }

  @override
  void didUpdateWidget(covariant locPhim oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.countries != oldWidget.countries ||
        widget.genres != oldWidget.genres ||
        widget.movieTypes != oldWidget.movieTypes) {
      _fetchFilms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  color: Theme.of(context).colorScheme.secondary,
      child: FutureBuilder<List<Items>>(
        future: futureFilms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            final filteredFilms = snapshot.data!.where((film) {
              final matchCountry = widget.countries == null ||
                  widget.countries == 'Quốc Gia' ||
                  film.country!.any((c) => c.name == widget.countries);
              final matchGenre = widget.genres == null ||
                  widget.genres == 'Thể Loại' ||
                  film.category!.any((c) => c.name == widget.genres);
              return matchCountry && matchGenre;
            }).toList();
            return ListView.builder(
              itemCount: filteredFilms.length,
              itemBuilder: (context, index) {
                String? dc = filteredFilms[index].slug ?? '';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhimWidget(
                          movieSlug: dc,
                          tap: "1",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: inforSearch(movieSlug: dc),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
