class DisasterParam {
  final String province;
  final String? placeName;
  final String? surveyer;
  final String? creationDa;
  final String? surveyDate;
  final List<double> position;
  final String? image;
  final bool isFlood;
  DisasterParam(
      {required this.province,
      this.placeName,
      this.surveyer,
      this.creationDa,
      this.surveyDate,
      this.image,
      required this.isFlood,
      required this.position});
  Map<String, dynamic> toJson() => {
        'province': province,
        'Place_name': placeName,
        'Surveyer': surveyer,
        'CreationDa': creationDa,
        'SurveyDate': surveyDate,
        'lat': position[1],
        'lng': position[0],
        'image': image,
        'is_flood': isFlood
      };
}
