import 'package:app_cineflix/model/movie_detail.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:flutter/material.dart';

class inforSearch extends StatefulWidget {
  final String movieSlug;
  const inforSearch({super.key, required this.movieSlug});

  @override
  State<inforSearch> createState() => _inforSearchState();
}

class _inforSearchState extends State<inforSearch> {
  late Future<chiTietPhim> futureChiTietPhim;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureChiTietPhim = NetworkRequest.fetchChiTiet(query: widget.movieSlug);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<chiTietPhim>(
        future: futureChiTietPhim,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            final movie = snapshot.data!.movie!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 200,
              child: Row(
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
                        image: NetworkImage(movie.posterUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    height: 170,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                //height: 30,
                                child: Text(
                                  movie.name ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  '| ${movie.year ?? ''} | ${movie.country![0].name ?? ''} | ${movie.category![0].name ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Text(
                            movie.content ?? '',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
