import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';
import 'package:gis_disaster_flutter/data/repository_impl/mock_disaster_repository_impl.dart';

class MockDisasterUseCase {
  final _repository = MockDisasterRepositoryImpl();

  Future<void> getMockFloods({
    required Function(FeatureMarkers) onSuccess,
    // required Function(ApiError err) onFailure,
  }) async {
    try {
      final data = await _repository.getMockFloods();
      onSuccess(data);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getPolygon({
    required Function(FeaturePolygon) onSuccess,
    required String provinces,
    // required Function(ApiError err) onFailure,
  }) async {
    try {
      final data = await _repository.getPolygon(province: provinces);
      onSuccess(data);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getAllProvinces({
    required Function(Provinces) onSuccess,
  }) async {
    try {
      final data = await _repository.getAllProvinces();
      onSuccess(data);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getCoordinateProvince(
      {required String address,
      required Function(ProvinceByApi) onSuccess}) async {
    try {
      final data = await _repository.getCoordinateProvince(address: address);
      onSuccess(data);
    } catch (err) {
      print(err);
    }
  }
}
