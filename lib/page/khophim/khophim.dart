import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/khophim/locPhim.dart';
import 'package:app_cineflix/page/timkiem/timkiem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhatHien extends StatefulWidget {
  const PhatHien({super.key});

  @override
  State<PhatHien> createState() => _PhatHienState();
}

class _PhatHienState extends State<PhatHien> {
  List<String> countries = [
    'Quốc Gia',
    'Việt Nam',
    'Trung Quốc',
    'Hàn Quốc',
    'Thái Lan',
    'Âu Mỹ'
  ];
  List<String> genres = [
    'Thể Loại',
    'Hành Động',
    'Tình Cảm',
    'Hài Hước',
    'Kinh Dị',
    'Tâm Lý',
    'Chính Kịch',
    'Giả Tượng',
    'Hoạt Hình',
    'Phiêu Lưu',
    'Gia Đình',
    'Viễn Tưởng'
  ];
  List<String> movieTypes = [
    'Phim Bộ/Lẻ',
    'Phim Bộ',
    'Phim Lẻ',
    'Hoạt Hình',
  ];
  String? selectedCountry = 'Quốc Gia';
  String? selectedGenre = 'Thể Loại';
  String? selectedMovieType = 'Phim Bộ/Lẻ';

  late Future<List<Items>> futureFilmBos;
  late Future<List<Items>> futureFilmLes;
  late Future<List<Items>> futureFilmHoatHinhs;
  late Future<List<Items>> futureFilms;
  @override
  void initState() {
    super.initState();
    futureFilmBos = NetworkRequest.fetchFilmBos();
    futureFilmLes = NetworkRequest.fetchFilmLes();
    futureFilmHoatHinhs = NetworkRequest.fetchFilmHoatHinhs();
    futureFilms = NetworkRequest.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kho phim',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              child: IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearch(),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                iconSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(width: 25),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: DropdownButton<String>(
                      isExpanded:
                          true, // Cho DropdownButton chiếm toàn bộ chiều rộng
                      value: selectedCountry,
                      items: countries.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(
                            country,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedGenre,
                      items: genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(
                            genre,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGenre = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedMovieType,
                      items: movieTypes.map((
                        type,
                      ) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedMovieType = value;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: locPhim(
                  countries: selectedCountry,
                  genres: selectedGenre,
                  movieTypes: selectedMovieType),
            )
          ],
        ),
      ),
    );
  }
}
