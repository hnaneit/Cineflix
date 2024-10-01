class User {
  String? id;
  String? username;
  String? password;
  String? email;
  String? avata;
  List<Yeuthich>? yeuthich;
  List<Lichsu>? lichsu;
  List<Timkiem>? timkiem;

  User(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.avata,
      this.yeuthich,
      this.lichsu,
      this.timkiem});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    avata = json['avata'];
    if (json['yeuthich'] != null) {
      yeuthich = <Yeuthich>[];
      json['yeuthich'].forEach((v) {
        yeuthich!.add(Yeuthich.fromJson(v));
      });
    }
    if (json['lichsu'] != null) {
      lichsu = <Lichsu>[];
      json['lichsu'].forEach((v) {
        lichsu!.add(Lichsu.fromJson(v));
      });
    }
    if (json['timkiem'] != null) {
      timkiem = <Timkiem>[];
      json['timkiem'].forEach((v) {
        timkiem!.add(Timkiem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['avata'] = avata;
    if (yeuthich != null) {
      data['yeuthich'] = yeuthich!.map((v) => v.toJson()).toList();
    }
    if (lichsu != null) {
      data['lichsu'] = lichsu!.map((v) => v.toJson()).toList();
    }
    if (timkiem != null) {
      data['timkiem'] = timkiem!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'username':
        return username;
      case 'password':
        return password;

      case 'email':
        return email;

      case 'yeuthich':
        return yeuthich;
      case 'lichsu':
        return lichsu;
      case 'timkiem':
        return timkiem;
      case 'avata':
        return avata;
      default:
        return null;
    }
  }
}

class Yeuthich {
  String? id;
  String? name;
  String? sulgname;
  String? thumbUrl;

  Yeuthich({this.id, this.name, this.sulgname, this.thumbUrl});

  Yeuthich.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sulgname = json['sulgname'];
    thumbUrl = json['thumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sulgname'] = sulgname;
    data['thumb_url'] = thumbUrl;
    return data;
  }
}

class Lichsu {
  String? id;
  String? name;
  String? sulgname;
  String? thumbUrl;
  String? tap;

  Lichsu({this.id, this.name, this.sulgname, this.thumbUrl, this.tap});

  Lichsu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sulgname = json['sulgname'];
    thumbUrl = json['thumb_url'];
    tap = json['tap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sulgname'] = sulgname;
    data['thumb_url'] = thumbUrl;
    data['tap'] = tap;
    return data;
  }
}

class Timkiem {
  String? id;
  String? noidung;

  Timkiem({this.id, this.noidung});

  Timkiem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noidung = json['noidung'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['noidung'] = noidung;
    return data;
  }
}
