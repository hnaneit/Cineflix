import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/chitietphim.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // Import dart:math

class DeXuat extends StatefulWidget {
  const DeXuat({super.key});

  @override
  State<DeXuat> createState() => _DeXuatState();
}

class _DeXuatState extends State<DeXuat> {
  late Future<List<Items>> futureFilms;

  @override
  void initState() {
    super.initState();
    futureFilms = NetworkRequest.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<List<Items>>(
          future: futureFilms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final randomFilms = _getRandomFilms(snapshot.data!, 18);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 cột
                  childAspectRatio:
                      2 / 3.5, // Tỉ lệ chiều rộng / chiều cao của mỗi item
                ),
                itemCount: randomFilms.length,
                itemBuilder: (context, index) {
                  final film = randomFilms[index];
                  return MovieItem(
                    film: film,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              thongtinphim(movieSlug: film.slug ?? ''),
                        ),
                      );
                    },
                  ); // Sử dụng widget MovieItem để hiển thị
                },
              );
            } else {
              return const Center(child: Text('Không có dữ liệu'));
            }
          },
        ),
      ),
    );
  }

  List<Items> _getRandomFilms(List<Items> films, int count) {
    final random = Random();
    final shuffledFilms = List<Items>.from(films)..shuffle(random);
    return shuffledFilms.sublist(0, min(count, shuffledFilms.length));
  }
}

class MovieItem extends StatelessWidget {
  final Items film;
  final VoidCallback onTap;

  const MovieItem({super.key, required this.film, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 115,
            height: 170,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
                // Độ dày của viền
              ),
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.phimapi.com/${film.posterUrl ?? ''}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 115,
            child: Text(
              film.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
