import 'package:gis_disaster_flutter/api_manager/rest_client.dart';
import 'package:gis_disaster_flutter/data/model/disaster_param.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/model/province_by_api.dart';
import 'package:gis_disaster_flutter/data/repository/mock_disaster_repository.dart';
import 'package:gis_disaster_flutter/global/app_url.dart';

const goongApiKey = 'vXwzyfs5RAxWR4iG4KjDRbsJuYbowLzMFVuphp7l';

class MockDisasterRepositoryImpl extends MockDisasterRepository {
  final RestClient _client = RestClient();

  @override
  Future<FeatureMarkers> getFloods({required String province}) async {
    final response = await _client
        .get(AppUrl.flood, queryParameters: {'province': province});
    return FeatureMarkers.fromJson(response);
  }

  @override
  Future<FeatureMarkers> getErosions({required String province}) async {
    final response = await _client
        .get(AppUrl.erosion, queryParameters: {'province': province});
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
        queryParameters: {'latlng': latlng, 'api_key': goongApiKey});
    return ProvinceByApi.fromJson(response['results'][0]);
  }

  @override
  Future<ProvinceByApi> getCoordinateProvince({required String address}) async {
    final response = await _client.get('https://rsapi.goong.io/geocode',
        queryParameters: {'address': address, 'api_key': goongApiKey});
    return ProvinceByApi.fromJson(response['results'[0]]);
  }

  @override
  Future<void> sendMarker({required DisasterParam param}) async {
    await _client.post(AppUrl.addDisasterData, data: param.toJson());
  }

  @override
  Future<void> updateMarker({required DisasterParam param}) async {
    await _client.post(AppUrl.updateDisaster, data: param.toJson());
  }
}
