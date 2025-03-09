class ProvinceByApi {
  Compound? compound;

  ProvinceByApi({this.compound});

  factory ProvinceByApi.fromJson(Map<String, dynamic> json) => ProvinceByApi(
      compound: json["compound"] == null
          ? null
          : Compound.fromJson(json["compound"]));
}

class Compound {
  String? district;
  String? commune;
  String? province;

  Compound({
    this.district,
    this.commune,
    this.province,
  });

  factory Compound.fromJson(Map<String, dynamic> json) => Compound(
        district: json["district"],
        commune: json["commune"],
        province: json["province"],
      );
}
