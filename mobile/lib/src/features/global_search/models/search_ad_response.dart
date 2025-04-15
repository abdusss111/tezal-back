class SearchAdResponse {
  final int id;
  final String? name;
  final List<dynamic>? urlFoto;
  final int? cityId; // ✅ Добавляем поле cityId

  SearchAdResponse({
    required this.id,
    required this.name,
    required this.urlFoto,
    this.cityId, // ✅ Добавляем в конструктор
  });

  factory SearchAdResponse.fromJsonNameIsTitle(Map<String, dynamic> json) {
    return SearchAdResponse(
      id: json['id'],
      name: json['title'],
      urlFoto: json['url_foto'],
      cityId: json['city_id'], // ✅ Берем city_id из JSON
    );
  }

  factory SearchAdResponse.fromJsonNameIsName(Map<String, dynamic> json) {
    return SearchAdResponse(
      id: json['id'],
      name: json['name'],
      urlFoto: json['url_foto'],
      cityId: json['city_id'], // ✅ Берем city_id из JSON
    );
  }

  factory SearchAdResponse.fromJsonNameIsHeadline(Map<String, dynamic> json) {
    return SearchAdResponse(
      id: json['id'],
      name: json['headline'],
      urlFoto: json['url_foto'],
      cityId: json['city_id'], // ✅ Берем city_id из JSON
    );
  }
}
