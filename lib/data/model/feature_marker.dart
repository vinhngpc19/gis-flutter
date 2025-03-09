class FeatureMarkers {
  List<FeatureMarker>? features;

  FeatureMarkers({
    this.features,
  });

  factory FeatureMarkers.fromJson(Map<String, dynamic> json) => FeatureMarkers(
        features: json['features'] == null
            ? []
            : List<FeatureMarker>.from(
                json['features']!.map((x) => FeatureMarker.fromJson(x))),
      );
}

class FeatureMarker {
  String? id;
  Properties? properties;
  Geometry? geometry;

  FeatureMarker({
    this.id,
    this.properties,
    this.geometry,
  });

  factory FeatureMarker.fromJson(Map<String, dynamic> json) => FeatureMarker(
        id: json['id'],
        properties: json['properties'] == null
            ? null
            : Properties.fromJson(json['properties']),
        geometry: json['geometry'] == null
            ? null
            : Geometry.fromJson(json['geometry']),
      );
}

class Geometry {
  String? type;
  dynamic coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] == null
        ? []
        : json['type'] == 'Point'
            ? List<double>.from(json['coordinates']!.map((x) => x?.toDouble()))
            : json['type'] == 'Polygon'
                ? List<List<List<double>>>.from(json['coordinates']!.map((x) =>
                    List<List<double>>.from(x.map((x) =>
                        List<double>.from(x.map((x) => x?.toDouble()))))))
                : List<List<List<List<double>>>>.from(json['coordinates']!.map((x) => List<List<List<double>>>.from(x.map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x?.toDouble()))))))));
    return Geometry(
      type: json['type'],
      coordinates: coordinates,
    );
  }
}

class Properties {
  String? creationDa;
  String? placeName;
  double? floodHouse;
  double? floodRoad;
  String? surveyDate;
  String? surveyer;
  String? name1;

  Properties(
      {this.creationDa,
      this.placeName,
      this.floodHouse,
      this.floodRoad,
      this.surveyDate,
      this.surveyer,
      this.name1});

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        creationDa: json['CreationDa'],
        placeName: json['Place_name'],
        floodHouse: json['FloodHouse']?.toDouble(),
        floodRoad: json['FloodRoad']?.toDouble(),
        surveyDate: json['SurveyDate'],
        surveyer: json['Surveyer'],
        name1: json['NAME_1'],
      );
}

class CustomMarker {
  final double lng;
  final double lat;

  CustomMarker({required this.lng, required this.lat});

  factory CustomMarker.fromJson(List<double> listJson) =>
      CustomMarker(lng: listJson[0], lat: listJson[1]);
}
