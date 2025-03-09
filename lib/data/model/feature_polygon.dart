import 'package:gis_disaster_flutter/data/model/feature_marker.dart';

class FeaturePolygon {
  Properties? properties;
  Geometry? geometry;

  FeaturePolygon({
    this.properties,
    this.geometry,
  });

  factory FeaturePolygon.fromJson(Map<String, dynamic> json) => FeaturePolygon(
        properties: json['properties'] == null
            ? null
            : Properties.fromJson(json['properties']),
        geometry: json['geometry'] == null
            ? null
            : Geometry.fromJson(json['geometry']),
      );
}

