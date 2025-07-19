import 'package:gis_disaster_flutter/data/model/luquetsatlo_model.dart';

enum TimePoint {
  time00('00:00'),
  time01('01:00'),
  time02('02:00'),
  time03('03:00'),
  time04('04:00'),
  time05('05:00'),
  time06('06:00'),
  time07('07:00'),
  time08('08:00'),
  time09('09:00'),
  time10('10:00'),
  time11('11:00'),
  time12('12:00'),
  time13('13:00'),
  time14('14:00'),
  time15('15:00'),
  time16('16:00'),
  time17('17:00'),
  time18('18:00'),
  time19('19:00'),
  time20('20:00'),
  time21('21:00'),
  time22('22:00'),
  time23('23:00');

  const TimePoint(this.value);
  final String value;

  static List<String> get allTimePoints =>
      TimePoint.values.map((e) => e.value).toList();
}

extension TemperatureX on Temperatures {
  RiskLevel get satLoRisk => RiskLevel.fromString(nguycosatlo);
  RiskLevel get luQuetRisk => RiskLevel.fromString(nguycoluquet);
}
