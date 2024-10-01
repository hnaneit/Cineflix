import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/home/danhMuc.dart';
import 'package:app_cineflix/page/home/noibat.dart';
import 'package:app_cineflix/page/home/quocgia.dart';
import 'package:app_cineflix/page/timkiem/timkiem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Items>> futureFilmMois;
  late Future<List<Items>> futureFilmBos;
  late Future<List<Items>> futureFilmLes;
  late Future<List<Items>> futureFilmHoatHinhs;
  late Future<List<Items>> futureFilms;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureFilmMois = NetworkRequest.fetchFilmMois();
    futureFilmBos = NetworkRequest.fetchFilmBos();
    futureFilmLes = NetworkRequest.fetchFilmLes();
    futureFilmHoatHinhs = NetworkRequest.fetchFilmHoatHinhs();
    futureFilms = NetworkRequest.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 35,
              child: Image.asset(
                'assets/images/logongang.png',
                height: kToolbarHeight - 10,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            alignment: Alignment.centerRight,
            width: 200,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Tìm kiếm phim'),
                const SizedBox(width: 38),
                IconButton(
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
                  iconSize: 15,
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 220, child: NoiBat(futureFilms: futureFilmMois)),
            Container(
              height: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  danhMuc(futureFilms: futureFilmBos, name: 'Phim Bộ'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  danhMuc(futureFilms: futureFilmLes, name: 'Phim Lẻ'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  danhMuc(
                      futureFilms: futureFilmHoatHinhs, name: 'Phim Hoạt Hình'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  quocGia(futureFilms: futureFilms, name: 'Âu Mỹ'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  quocGia(futureFilms: futureFilms, name: 'Hàn Quốc'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  quocGia(futureFilms: futureFilms, name: 'Thái Lan'),
                  Container(
                    height: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  quocGia(futureFilms: futureFilms, name: 'Trung Quốc'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
