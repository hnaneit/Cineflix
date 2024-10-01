import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/page/phim/chitietphim.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoiBat extends StatelessWidget {
  final Future<List<Items>> futureFilms;
  const NoiBat({
    super.key,
    required this.futureFilms,
  });

  @override
  Widget build(BuildContext context) {
    final CarouselController carouselController = CarouselController();
    return Container(
      height: 280,
      padding: const EdgeInsets.all(5),
      color: Theme.of(context).colorScheme.surface,
      child: FutureBuilder<List<Items>>(
        future: futureFilms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final items = snapshot.data!;
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount:
                    items.length, // Sử dụng số lượng item từ futureFilmMois
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 20 / 9,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index, realIndex) {
                  String? dc = items[index].slug ?? '';
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => thongtinphim(movieSlug: dc),
                            ),
                          );
                        },
                        child: Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        items[index].thumbUrl ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.001),
                                      Colors.black,
                                    ],
                                    stops: const [0.0, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: 300,
                                    child: Text(
                                      items[index].name ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
