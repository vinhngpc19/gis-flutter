import 'package:gis_disaster_flutter/data/model/disaster_param.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/luquetsatlo_model.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';

abstract class MockDisasterRepository {
  Future<FeatureMarkers> getFloods({required String province});
  Future<FeaturePolygon> getPolygon({required String province});
  Future<Provinces> getAllProvinces();
  Future<ProvinceByApi> getCoordinateProvince({required String address});
  Future<ProvinceByApi> getProvinceByPosition({required String latlng});
  Future<FeatureMarkers> getErosions({required String province});
  Future<List<Temperatures>> getForecast({
    required int sogiodubao,
    required String date,
  });

  // Future<void> updateProvincePosition({required ProvincePositionParam param});
  Future<void> sendMarker({required DisasterParam param});
  Future<void> updateMarker({required DisasterParam param});
}
