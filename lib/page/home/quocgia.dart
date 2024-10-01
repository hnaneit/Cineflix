import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/page/phim/chitietphim.dart';
import 'package:flutter/material.dart';

class quocGia extends StatelessWidget {
  final String? name;
  final Future<List<Items>> futureFilms;
  const quocGia({
    super.key,
    required this.futureFilms,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(5),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 35,
            child: Text(
              '  $name',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<Items>>(
              future: futureFilms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final item = snapshot.data!;
////////////////////////////////////////////////////////////////////////////////////////////////////
                  final items = item
                      .where(
                        (film) => film.country!.any((c) => c.name == '$name'),
                      )
                      .toList();
                  return SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        String? dc = items[index].slug ?? '';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    thongtinphim(movieSlug: dc),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 115,
                                height: 170,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    // Độ dày của viền
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://img.phimapi.com/${items[index].posterUrl ?? ''}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 115,
                                child: Text(
                                  items[index].name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
