import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/chitietphim.dart';
import 'package:app_cineflix/page/timkiem/thongtintimkiem.dart';
import 'package:app_cineflix/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSearch extends SearchDelegate {
  late Future<List<Items>> futureFilms = NetworkRequest.fetchFilms();
  String? userId;

  CustomSearch() {
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return currentTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode
            ? darkMode.colorScheme.surface
            : lightMode.colorScheme.surface,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: isDarkMode
              ? darkMode.colorScheme.onPrimary
              : lightMode.colorScheme.onPrimary,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () async {
          if (query.isNotEmpty && userId != null) {
            await NetworkRequest.addSearch(userId!, query);
            showResults(context);
          }
        },
        icon: const Icon(Icons.search),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: FutureBuilder<List<Items>>(
        future: futureFilms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            final normalizedQuery = removeDiacritics(query).toLowerCase();
            final results = snapshot.data!.where((film) {
              final normalizedFilmName =
                  removeDiacritics(film.name ?? '').toLowerCase();
              return normalizedFilmName.contains(normalizedQuery);
            }).toList();

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                String? dc = results[index].slug ?? '';
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<User>(
      future: userId != null
          ? NetworkRequest.fetchUser(userId!)
          : Future.value(null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.timkiem == null) {
          return const Center(
            child: Text(
              'Không có dữ liệu',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else {
          final suggestions = snapshot.data!.timkiem!
              .where((film) {
                final matchQuery = removeDiacritics(film.noidung ?? '')
                    .toLowerCase()
                    .contains(removeDiacritics(query).toLowerCase());
                return matchQuery;
              })
              .map((e) => e.noidung ?? '')
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }

  String removeDiacritics(String str) {
    var withDiacritics =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    var withoutDiacritics =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }
}
