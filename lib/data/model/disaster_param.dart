class DisasterParam {
  final String province;
  final String? placeName;
  final String? surveyer;
  final String? creationDa;
  final String? surveyDate;
  final List<double>? position;
  final String? image;
  final bool isFlood;
  final String? id;
  final double? floodRoad;
  final double? floodHouse;
  DisasterParam(
      {required this.province,
      this.placeName,
      this.id,
      this.surveyer,
      this.creationDa,
      this.surveyDate,
      this.image,
      this.floodRoad,
      this.floodHouse,
      required this.isFlood,
      this.position});
  Map<String, dynamic> toJson() => {
        'id': id,
        'province': province,
        'Place_name': placeName,
        'Surveyer': surveyer,
        'CreationDa': creationDa,
        'SurveyDate': surveyDate,
        'FloodHouse': floodHouse,
        'FloodRoad': floodRoad,
        'lat': position?[1],
        'lng': position?[0],
        'image': image,
        'is_flood': isFlood
      };
}
