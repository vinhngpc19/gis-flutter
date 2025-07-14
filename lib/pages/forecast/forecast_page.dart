import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/pages/forecast/forecast_controller.dart';

class ForecastPage extends BaseScreen<ForecastController> {
  ForecastPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      backgroundColor: color.white,
      body: Center(
        child: Text('Nội dung dự báo sẽ được hiển thị ở đây.'),
      ),
    );
  }

  @override
  ForecastController? putController() => ForecastController();
}
