class DSFilmLe {
  String? status;
  String? msg;
  Data? data;

  DSFilmLe({this.status, this.msg, this.data});

  DSFilmLe.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  SeoOnPage? seoOnPage;
  List<BreadCrumb>? breadCrumb;
  String? titlePage;
  List<Items>? items;
  Params? params;
  String? typeList;
  String? aPPDOMAINFRONTEND;
  String? aPPDOMAINCDNIMAGE;

  Data(
      {this.seoOnPage,
      this.breadCrumb,
      this.titlePage,
      this.items,
      this.params,
      this.typeList,
      this.aPPDOMAINFRONTEND,
      this.aPPDOMAINCDNIMAGE});

  Data.fromJson(Map<String, dynamic> json) {
    seoOnPage = json['seoOnPage'] != null
        ? SeoOnPage.fromJson(json['seoOnPage'])
        : null;
    if (json['breadCrumb'] != null) {
      breadCrumb = <BreadCrumb>[];
      json['breadCrumb'].forEach((v) {
        breadCrumb!.add(BreadCrumb.fromJson(v));
      });
    }
    titlePage = json['titlePage'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    typeList = json['type_list'];
    aPPDOMAINFRONTEND = json['APP_DOMAIN_FRONTEND'];
    aPPDOMAINCDNIMAGE = json['APP_DOMAIN_CDN_IMAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seoOnPage != null) {
      data['seoOnPage'] = seoOnPage!.toJson();
    }
    if (breadCrumb != null) {
      data['breadCrumb'] = breadCrumb!.map((v) => v.toJson()).toList();
    }
    data['titlePage'] = titlePage;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (params != null) {
      data['params'] = params!.toJson();
    }
    data['type_list'] = typeList;
    data['APP_DOMAIN_FRONTEND'] = aPPDOMAINFRONTEND;
    data['APP_DOMAIN_CDN_IMAGE'] = aPPDOMAINCDNIMAGE;
    return data;
  }
}

class SeoOnPage {
  String? ogType;
  String? titleHead;
  String? descriptionHead;
  List<String>? ogImage;
  String? ogUrl;

  SeoOnPage(
      {this.ogType,
      this.titleHead,
      this.descriptionHead,
      this.ogImage,
      this.ogUrl});

  SeoOnPage.fromJson(Map<String, dynamic> json) {
    ogType = json['og_type'];
    titleHead = json['titleHead'];
    descriptionHead = json['descriptionHead'];
    ogImage = json['og_image'].cast<String>();
    ogUrl = json['og_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['og_type'] = ogType;
    data['titleHead'] = titleHead;
    data['descriptionHead'] = descriptionHead;
    data['og_image'] = ogImage;
    data['og_url'] = ogUrl;
    return data;
  }
}

class BreadCrumb {
  String? name;
  String? slug;
  bool? isCurrent;
  int? position;

  BreadCrumb({this.name, this.slug, this.isCurrent, this.position});

  BreadCrumb.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    isCurrent = json['isCurrent'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['isCurrent'] = isCurrent;
    data['position'] = position;
    return data;
  }
}

class Items {
  Modified? modified;
  String? sId;
  String? name;
  String? slug;
  String? originName;
  String? type;
  String? posterUrl;
  String? thumbUrl;
  bool? subDocquyen;
  bool? chieurap;
  String? time;
  String? episodeCurrent;
  String? quality;
  String? lang;
  int? year;
  List<Category>? category;
  List<Country>? country;

  Items(
      {this.modified,
      this.sId,
      this.name,
      this.slug,
      this.originName,
      this.type,
      this.posterUrl,
      this.thumbUrl,
      this.subDocquyen,
      this.chieurap,
      this.time,
      this.episodeCurrent,
      this.quality,
      this.lang,
      this.year,
      this.category,
      this.country});

  Items.fromJson(Map<String, dynamic> json) {
    modified =
        json['modified'] != null ? Modified.fromJson(json['modified']) : null;
    sId = json['_id'];
    name = json['name'];
    slug = json['slug'];
    originName = json['origin_name'];
    type = json['type'];
    posterUrl = json['poster_url'];
    thumbUrl = json['thumb_url'];
    subDocquyen = json['sub_docquyen'];
    chieurap = json['chieurap'];
    time = json['time'];
    episodeCurrent = json['episode_current'];
    quality = json['quality'];
    lang = json['lang'];
    year = json['year'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (modified != null) {
      data['modified'] = modified!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['slug'] = slug;
    data['origin_name'] = originName;
    data['type'] = type;
    data['poster_url'] = posterUrl;
    data['thumb_url'] = thumbUrl;
    data['sub_docquyen'] = subDocquyen;
    data['chieurap'] = chieurap;
    data['time'] = time;
    data['episode_current'] = episodeCurrent;
    data['quality'] = quality;
    data['lang'] = lang;
    data['year'] = year;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    if (country != null) {
      data['country'] = country!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modified {
  String? time;

  Modified({this.time});

  Modified.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Country {
  String? id;
  String? name;
  String? slug;

  Country({this.id, this.name, this.slug});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Params {
  String? typeSlug;
  List<String>? filterCategory;
  List<String>? filterCountry;
  String? filterYear;
  String? filterType;
  String? sortField;
  String? sortType;
  Pagination? pagination;

  Params(
      {this.typeSlug,
      this.filterCategory,
      this.filterCountry,
      this.filterYear,
      this.filterType,
      this.sortField,
      this.sortType,
      this.pagination});

  Params.fromJson(Map<String, dynamic> json) {
    typeSlug = json['type_slug'];
    filterCategory = json['filterCategory'].cast<String>();
    filterCountry = json['filterCountry'].cast<String>();
    filterYear = json['filterYear'];
    filterType = json['filterType'];
    sortField = json['sortField'];
    sortType = json['sortType'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_slug'] = typeSlug;
    data['filterCategory'] = filterCategory;
    data['filterCountry'] = filterCountry;
    data['filterYear'] = filterYear;
    data['filterType'] = filterType;
    data['sortField'] = sortField;
    data['sortType'] = sortType;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  int? totalItemsPerPage;
  int? currentPage;
  int? totalPages;

  Pagination(
      {this.totalItems,
      this.totalItemsPerPage,
      this.currentPage,
      this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    totalItemsPerPage = json['totalItemsPerPage'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['totalItemsPerPage'] = totalItemsPerPage;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    return data;
  }
}
