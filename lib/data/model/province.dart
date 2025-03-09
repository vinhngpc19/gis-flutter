class Provinces {
  List<Province>? data;

  Provinces({
    this.data,
  });

  factory Provinces.fromJson(Map<String, dynamic> json) => Provinces(
        data: json['data'] == null
            ? []
            : List<Province>.from(
                json['data']!.map((x) => Province.fromJson(x))),
      );
}

class Province {
  String? id;
  String? name1;
  List<double>? position;

  Province({
    this.id,
    this.name1,
    this.position,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json['id'],
        name1: json['name_1'],
        position: json['position'] == null
            ? []
            : List<double>.from(json['position']!.map((x) => x?.toDouble())),
      );
}
