import 'package:gis_disaster_flutter/api_manager/rest_client.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';
import 'package:gis_disaster_flutter/data/repository/mock_disaster_repository.dart';
import 'package:gis_disaster_flutter/global/app_url.dart';

class MockDisasterRepositoryImpl extends MockDisasterRepository {
  final RestClient _client = RestClient();

  @override
  Future<FeatureMarkers> getMockFloods() async {
    final response = await _client.get(AppUrl.flood);
    return FeatureMarkers.fromJson(response);
  }

  @override
  Future<FeaturePolygon> getPolygon({required String province}) async {
    final response =
        await _client.get(AppUrl.polygon, queryParameters: {'name': province});
    return FeaturePolygon.fromJson(response);
  }

  @override
  Future<Provinces> getAllProvinces() async {
    final response = await _client.get(AppUrl.allProvinces);
    return Provinces.fromJson(response);
  }

  // @override
  // Future<void> updateProvincePosition(
  //     {required ProvincePositionParam param}) async {
  //   await _client.post(AppUrl.updateProvincePosition, data: param.toJson());
  // }

  @override
  Future<ProvinceByApi> getProvinceByPosition({required String latlng}) async {
    final response = await _client.get('https://rsapi.goong.io/geocode',
        queryParameters: {'latlng': latlng, 'api_key': '*'});
    return ProvinceByApi.fromJson(response);
  }

  @override
  Future<ProvinceByApi> getCoordinateProvince({required String address}) async {
    final response = await _client.get('https://rsapi.goong.io/geocode',
        queryParameters: {'address': address, 'api_key': '*'});
    return ProvinceByApi.fromJson(response);
  }
}
