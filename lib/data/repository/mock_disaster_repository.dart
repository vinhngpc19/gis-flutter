import 'package:gis_disaster_flutter/data/model/disaster_param.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';

abstract class MockDisasterRepository {
  Future<FeatureMarkers> getFloods({required String province});
  Future<FeaturePolygon> getPolygon({required String province});
  Future<Provinces> getAllProvinces();
  Future<ProvinceByApi> getCoordinateProvince({required String address});

  Future<ProvinceByApi> getProvinceByPosition({required String latlng});

  Future<FeatureMarkers> getErosions({required String province});

  // Future<void> updateProvincePosition({required ProvincePositionParam param});

  Future<void> sendMarker({required DisasterParam param});
}
