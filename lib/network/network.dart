import 'dart:convert';
import 'package:app_cineflix/model/dsphimle.dart';
import 'package:app_cineflix/model/movie_detail.dart';
import 'package:app_cineflix/model/usermodel.dart';
import 'package:http/http.dart' as http;

class NetworkRequest {
  static const String urlFilmLe =
      'https://phimapi.com/v1/api/danh-sach/phim-le?limit=64';
  static const String urlFilmBo =
      'https://phimapi.com/v1/api/danh-sach/phim-bo?limit=64';
  static const String urlFilmHoatHinh =
      'https://phimapi.com/v1/api/danh-sach/hoat-hinh?limit=64';
  static const String urlFilmMoi =
      'https://phimapi.com/danh-sach/phim-moi-cap-nhat?page=2';
  static const String urlChiTiet = 'https://phimapi.com/phim/';
  static const String urlUser = 'http://10.0.2.2:3000/user';
  /////////////
  static Future<List<User>> fetchUsers({int page = 1}) async {
    final response = await http.get(Uri.parse(urlUser));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = jsonDecode(responseBody);
      return jsonData.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  static Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('$urlUser/$userId'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(responseBody);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  static Future<bool> updateUserPassword(
      String userId, String newPassword) async {
    final url = Uri.parse('$urlUser/$userId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update password: ${response.reasonPhrase}');
    }
  }

  static Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$urlUser/$userId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<User?> registerUser(User user) async {
    final response = await http.post(
      Uri.parse(urlUser),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      print('Đăng ký thất bại: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print('Thông tin lỗi: ${response.body}');
      }
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }

  static Future<List<int>> fetchAllIds() async {
    final response = await http.get(Uri.parse(urlUser));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<int>((item) => int.parse(item['id'] as String)).toList();
    } else {
      throw Exception('Failed to load IDs');
    }
  }

  static Future<List<String>> fetchAllEmail() async {
    final response = await http.get(Uri.parse(urlUser));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<String>((item) => item['email'] as String).toList();
    } else {
      throw Exception('Failed to load user names');
    }
  }

  /// YEU THICH //////////
  static Future<void> addFavorite(
      String userId, String name, String sulgname, String thumbUrl) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> yeuThichList = userData['yeuthich'] ?? [];
        int maxId = 0;
        for (var item in yeuThichList) {
          int? itemId = int.tryParse(item['id']);
          if (itemId != null && itemId > maxId) {
            maxId = itemId;
          }
        }
        String newId = (maxId + 1).toString();
        final yeuThichItem = Yeuthich(
            id: newId, name: name, sulgname: sulgname, thumbUrl: thumbUrl);
        yeuThichList.add(yeuThichItem.toJson());
        userData['yeuThich'] = yeuThichList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );
        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  static Future<void> removeFavorite(String userId, String sulgname) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> yeuThichList = userData['yeuthich'] ?? [];
        yeuThichList.removeWhere((item) => item['sulgname'] == sulgname);
        userData['yeuthich'] = yeuThichList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(userData),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  /////// LỊCH SỬ ////
  static Future<void> addLichSu(
      String userId, String name, String sulgname, String thumbUrl) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> yeuThichList = userData['lichsu'] ?? [];
        int maxId = 0;
        for (var item in yeuThichList) {
          int? itemId = int.tryParse(item['id']);
          if (itemId != null && itemId > maxId) {
            maxId = itemId;
          }
        }
        String newId = (maxId + 1).toString();
        final yeuThichItem = Yeuthich(
            id: newId, name: name, sulgname: sulgname, thumbUrl: thumbUrl);
        yeuThichList.add(yeuThichItem.toJson());
        userData['lichsu '] = yeuThichList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );
        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  static Future<void> removeLichSu(String userId, String sulgname) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> yeuThichList = userData['yeuthich'] ?? [];
        yeuThichList.removeWhere((item) => item['sulgname'] == sulgname);
        userData['yeuthich'] = yeuThichList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(userData),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  //////////TIMKIEM
  static Future<void> addSearch(String userId, String noiDung) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> searchList = userData['timkiem'] ?? [];
        int existingIndex =
            searchList.indexWhere((item) => item['noidung'] == noiDung);
        if (existingIndex != -1) {
          int maxId = 0;
          for (var item in searchList) {
            int? itemId = int.tryParse(item['id']);
            if (itemId != null && itemId > maxId) {
              maxId = itemId;
            }
          }
          searchList[existingIndex]['id'] = (maxId + 1).toString();
          searchList
              .sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));
        } else {
          int maxId = 0;
          for (var item in searchList) {
            int? itemId = int.tryParse(item['id']);
            if (itemId != null && itemId > maxId) {
              maxId = itemId;
            }
          }
          String newId = (maxId + 1).toString();
          final searchItem = Timkiem(id: newId, noidung: noiDung);
          searchList.add(searchItem.toJson());
        }
        userData['timkiem'] = searchList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );
        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add search: $e');
    }
  }

  ///
  static Future<void> clearSearchHistory(String userId) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        userData['timkiem'] = [];
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

  /////////LICH SU XEM
  static Future<void> addWatchHistory(String userId, String name,
      String sulgname, String thumburl, String tap) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> searchList = userData['lichsu'] ?? [];
        int existingIndex =
            searchList.indexWhere((item) => item['sulgname'] == sulgname);
        if (existingIndex != -1) {
          int maxId = 0;
          for (var item in searchList) {
            int? itemId = int.tryParse(item['id']);
            if (itemId != null && itemId > maxId) {
              maxId = itemId;
            }
          }
          searchList[existingIndex]['id'] = (maxId + 1).toString();
          searchList[existingIndex]['tap'] = tap;
          searchList
              .sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));
        } else {
          int maxId = 0;
          for (var item in searchList) {
            int? itemId = int.tryParse(item['id']);
            if (itemId != null && itemId > maxId) {
              maxId = itemId;
            }
          }
          String newId = (maxId + 1).toString();
          final searchItem = Lichsu(
              id: newId,
              name: name,
              sulgname: sulgname,
              thumbUrl: thumburl,
              tap: tap);
          searchList.add(searchItem.toJson());
        }
        userData['lichsu'] = searchList;
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );
        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add search: $e');
    }
  }

  //
  static Future<void> clearWatchHistory(String userId) async {
    try {
      final response = await http.get(Uri.parse('$urlUser/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData =
            jsonDecode(utf8.decode(response.bodyBytes));
        userData['lichsu'] = [];
        final updateResponse = await http.put(
          Uri.parse('$urlUser/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: utf8.encode(jsonEncode(userData)),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception(
              'Failed to update user data: ${updateResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to clear watch history: $e');
    }
  }

  ///////////////
  static Future<List<Items>> fetchFilmLes({int page = 1}) async {
    final response = await http.get(Uri.parse(urlFilmLe));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> itemsData = jsonData['data']['items'];
      return itemsData.map((item) => Items.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<List<Items>> fetchFilmBos({int page = 1}) async {
    final response = await http.get(Uri.parse(urlFilmBo));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> itemsData = jsonData['data']['items'];
      return itemsData.map((item) => Items.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<List<Items>> fetchFilms({int page = 1}) async {
    final responseBo = await http.get(Uri.parse(urlFilmBo));
    final responseLe = await http.get(Uri.parse(urlFilmLe));
    final responseHoatHinh = await http.get(Uri.parse(urlFilmHoatHinh));

    if (responseBo.statusCode == 200 &&
        responseLe.statusCode == 200 &&
        responseHoatHinh.statusCode == 200) {
      final Map<String, dynamic> jsonDataBo = jsonDecode(responseBo.body);
      final Map<String, dynamic> jsonDataLe = jsonDecode(responseLe.body);
      final Map<String, dynamic> jsonDataHoatHinh =
          jsonDecode(responseHoatHinh.body);
      //lấy data
      final List<dynamic> itemsDataBo = jsonDataBo['data']['items'];
      final List<dynamic> itemsDataLe = jsonDataLe['data']['items'];
      final List<dynamic> itemsDataHoatHinh = jsonDataHoatHinh['data']['items'];
      //
      final List<Items> allItems = [];
      allItems.addAll(itemsDataBo.map((item) => Items.fromJson(item)).toList());
      allItems.addAll(itemsDataLe.map((item) => Items.fromJson(item)).toList());
      allItems.addAll(
          itemsDataHoatHinh.map((item) => Items.fromJson(item)).toList());

      return allItems;
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<List<Items>> fetchFilmHoatHinhs({int page = 1}) async {
    final response = await http.get(Uri.parse(urlFilmHoatHinh));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> itemsData = jsonData['data']['items'];
      return itemsData.map((item) => Items.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<List<Items>> fetchFilmMois({int page = 1}) async {
    final response = await http.get(Uri.parse(urlFilmMoi));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> itemsData = jsonData['items'];
      return itemsData.map((item) => Items.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<chiTietPhim> fetchChiTiet(
      {int page = 1, required String query}) async {
    try {
      final response = await http.get(Uri.parse('$urlChiTiet$query'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return chiTietPhim.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load film. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      rethrow;
    }
  }
}
