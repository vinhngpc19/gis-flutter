import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';

abstract class MockDisasterRepository {
  Future<FeatureMarkers> getMockFloods();
  Future<FeaturePolygon> getPolygon({required String province});
  Future<Provinces> getAllProvinces();
  Future<ProvinceByApi> getCoordinateProvince({required String address});

  Future<ProvinceByApi> getProvinceByPosition({required String latlng});

  // Future<void> updateProvincePosition({required ProvincePositionParam param});
}
