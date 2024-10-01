import 'package:app_cineflix/model/usermodel.dart';
import 'package:app_cineflix/network/network.dart';
import 'package:app_cineflix/page/phim/phim.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LichSuWidget extends StatefulWidget {
  const LichSuWidget({super.key});

  @override
  State<LichSuWidget> createState() => LichSuWidgetState();
}

class LichSuWidgetState extends State<LichSuWidget> {
  late Future<User> futureUser = Future.value(User(lichsu: []));
  String? idUser;

  @override
  void initState() {
    super.initState();
    _loadIdUser();
  }

  Future<void> _loadIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('userId');
    if (idUser != null) {
      futureUser = NetworkRequest.fetchUser(idUser!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            List<Lichsu> lichSuReversed = user.lichsu?.reversed.toList() ?? [];

            return ListView.builder(
              itemCount: lichSuReversed.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhimWidget(
                          movieSlug: lichSuReversed[index].sulgname ?? "",
                          tap: lichSuReversed[index].tap ?? "",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 90,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  lichSuReversed[index].thumbUrl ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                lichSuReversed[index].name ?? "",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                            if (lichSuReversed[index].tap != '1')
                              SizedBox(
                                width: 180,
                                child: Text(
                                  "Tập ${lichSuReversed[index].tap ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No data',
              ),
            );
          }
        },
      ),
    );
  }
}
