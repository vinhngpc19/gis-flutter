import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/use_case/mock_disaster_use_case.dart';

class LocationsController extends BaseController {
  final _useCase = MockDisasterUseCase();
  RxList<Province> listProvinces = <Province>[].obs;
  @override
  void onInit() {
    _getAllProvinces();
    super.onInit();
  }

  Future<void> _getAllProvinces() async {
    await showLoading();
    await _useCase.getAllProvinces(onSuccess: (data) {
      listProvinces.addAll(data.data ?? []);
    }).whenComplete(() => hideLoading());
  }
}
