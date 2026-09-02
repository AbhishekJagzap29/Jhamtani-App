import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';

class ProjectDetailsController extends GetxController {
  var checkListId = Get.arguments['cId'];
  var projectId = Get.arguments['pId'];
  var projectName = Get.arguments['pName'];
  int buId = Get.arguments['buId'];
  var name = Get.arguments['name'];
  var cName = Get.arguments['cName'];

  GetHQITowersResponseModel? hqiTowerData;
  List<HQITower> hqiTowersList = [];

  String get hqiChecklistName => hqiTowerData?.data?.checklistName ?? '';
  String get hqiImageUrl => hqiTowerData?.data?.imageUrl ?? '';
  double get hqiProgress => hqiTowersList.isNotEmpty
      ? hqiTowersList.map((e) => e.progress ?? 0).reduce((a, b) => a + b) /
          hqiTowersList.length
      : 0;
  final searchController = TextEditingController();
  bool isFavorite = true;
  NetworkController networkController = Get.put(NetworkController());
  GetTowerInfoChecklistResponseModel? towerDataRes;
  bool loading = false;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    if (cName == "Home Inspection") {
      await getHQITowersController();
    } else {
      await getTowerChecklistController();
    }
    update();
  }

  favourite() {
    isFavorite = !isFavorite;
    update();
  }

  /// API
  ApiResponse _getTowerChecklistResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

  Future<dynamic> getTowerChecklistController() async {
    _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
        "checklist_id": checkListId,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });
      log('checkListId==========>>>>>$checkListId');
      log('int.parse(preferences.getString(SharedPreference.userId) ?? "0")==========>>>>>${int.parse(preferences.getString(SharedPreference.userId) ?? "0")}');
      _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);
      log("_getTowerChecklistResponse==>$towerDataRes");
    } catch (e) {
      _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
      log("_getTowerChecklistResponse=ERROR=>$e");
    }
    update();
  }

  ApiResponse _getHQITowersResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getHQITowersResponse => _getHQITowersResponse;

  Future<void> getHQITowersController() async {
    _getHQITowersResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      var body = {
        "project_id": projectId,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
      };
      final response = await ProjectRepo().getHQITowersRepo(body: body);
      hqiTowerData = response;
      hqiTowersList = hqiTowerData?.data?.towerData ?? [];

      _getHQITowersResponse = ApiResponse.complete(hqiTowerData);
      log("HQI Towers fetched: ${hqiTowerData?.data?.towerData?.length}");

    } catch (e) {
      _getHQITowersResponse = ApiResponse.error(message: e.toString());
      log("Error fetching HQI towers: $e");
    }
    update();
  }
}
