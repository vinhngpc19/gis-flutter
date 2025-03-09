import 'package:gis_disaster_flutter/api_manager/rest_client_base.dart';
import 'package:gis_disaster_flutter/config/dev_config.dart';

class RestClient extends RestClientBase {
  factory RestClient() {
    _singleton ??= RestClient._internal(baseUrl: DevConfig.baseUrl);
    return _singleton!;
  }

  RestClient._internal({required super.baseUrl});

  static RestClient? _singleton;
}
