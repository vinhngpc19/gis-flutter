import 'package:gis_disaster_flutter/data/model/disaster_param.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';
import 'package:gis_disaster_flutter/data/repository_impl/mock_disaster_repository_impl.dart';

class MockDisasterUseCase {
  final _repository = MockDisasterRepositoryImpl();

  Future<void> getFloods({
    required String province,
    required Function(FeatureMarkers) onSuccess,
    // required Function(ApiError err) onFailure,
  }) async {
    try {
      final data = await _repository.getFloods(province: province);
      onSuccess(data);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getErosions({
    required String province,
    required Function(FeatureMarkers) onSuccess,
    // required Function(ApiError err) onFailure,
  }) async {
    try {
      final data = await _repository.getErosions(province: province);
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

  Future<void> getProvinceByPosition(
      {required String latlng,
      required Function(ProvinceByApi) onSuccess,
      required Function() onError}) async {
    try {
      final data = await _repository.getProvinceByPosition(latlng: latlng);
      onSuccess(data);
    } catch (err) {
      print(err);
      onError();
    }
  }

  Future<void> sendMarker(
      {required DisasterParam param,
      required Function() onSuccess,
      required Function() onError}) async {
    try {
      await _repository.sendMarker(param: param);
      onSuccess();
    } catch (err) {
      print(err);
      onError();
    }
  }

  Future<void> updateMarker(
      {required DisasterParam param,
      required Function() onSuccess,
      required Function() onError}) async {
    try {
      await _repository.updateMarker(param: param);
      onSuccess();
    } catch (err) {
      print(err);
      onError();
    }
  }
}
