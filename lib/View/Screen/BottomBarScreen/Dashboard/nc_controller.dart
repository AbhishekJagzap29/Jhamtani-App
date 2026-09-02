import 'dart:developer';

import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/nc_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_flat_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_project_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_tower_res_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class NcController extends GetxController {
  ApiResponse _getProjectNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getTowerNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFloorNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFloorAcNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFloorAcTypeNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFloorChecklistNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFlatNcApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFlatAcNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFlatAcTypeNCApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse _getFlatChecklistNcApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getProjectNCApiResponse => _getProjectNCApiResponse;
  ApiResponse get getTowerNCApiResponse => _getTowerNCApiResponse;
  ApiResponse get getFloorNCApiResponse => _getFloorNCApiResponse;
  ApiResponse get getFloorAcNCApiResponse => _getFloorAcNCApiResponse;
  ApiResponse get getFloorAcTypeNCApiResponse => _getFloorAcTypeNCApiResponse;
  ApiResponse get getFloorChecklistNCApiResponse =>
      _getFloorChecklistNCApiResponse;
  ApiResponse get getFlatNcApiResponse => _getFlatNcApiResponse;
  ApiResponse get getFlatAcNCApiResponse => _getFlatAcNCApiResponse;
  ApiResponse get getFlatAcTypeNCApiResponse => _getFlatAcTypeNCApiResponse;
  ApiResponse get getFlatChecklistNcApiResponse =>
      _getFlatChecklistNcApiResponse;

  ///0
  ProjectNcResponseModel? projectNcResponseModel;

  ///1
  TowerNcResponseModel? towerNcResponseModel;

  ///2
  FlatNcResponseModel? flatNcResponseModel;

  ///3
  ActivityNcResponseModel? flatActivityNcResponseModel;

  ///4
  ActivityTypeNcResponseModel? flatActivityTypeNcResponseModel;

  ///5
  ChecklistNcResponseModel? flatChecklistNcResponseModel;

  ///6
  FloorNcResponseModel? floorNcResponseModel;

  ///7
  ActivityNcResponseModel? activityNcResponseModel;

  ///8
  ActivityTypeNcResponseModel? activityTypeNcResponseModel;

  ///9
  ChecklistNcResponseModel? checklistNcResponseModel;

  String projectId = Get.arguments["id"];
  String projectName = Get.arguments["name"];
  String projectImage = Get.arguments["image"];
  NcModel ncModel = NcModel();
  int select = 0;
  int filterIndex = 0;
  TextEditingController searchController = TextEditingController();

  List<NCTowerDataList> towerList = [];
  NCTowerDataList? selectedTower;

  List<NcFloorData> floorList = [];
  NcFloorData? selectedFloorData;

  List<NcFlatData> flatList = [];
  NcFlatData? selectedFlatData;

  List<FloorActivityNcData> floorActivityList = [];
  FloorActivityNcData? selectedFloorActivity;

  List<FlatActivityNcData> flatActivityList = [];
  FlatActivityNcData? selectedFlatActivity;

  List<NcActivityTypeList> floorActivityTypeList = [];
  NcActivityTypeList? selectedFloorActivityType;

  List<NcActivityTypeList> flatActivityTypeList = [];
  NcActivityTypeList? selectedFlatActivityType;

  List<NcChecklist> floorChecklistList = [];
  NcChecklist? selectedFloorChecklist;

  List<NcChecklist> flatChecklistList = [];
  NcChecklist? selectedFlatChecklist;

  @override
  void onInit() {
    getProjectNcController(body: {"project_id": int.parse(projectId)});
    super.onInit();
  }

  /// SELECTION

  selectFlatFloor(int index) {
    select = index;
    update();
  }

  selectTower(int id) async {
    for (var element in towerList) {
      if (element.towerId == id) {
        selectedTower = element;
      }
    }
    filterIndex = 1;

    floorList = [];
    selectedFloorData = null;
    flatList = [];
    selectedFlatData = null;
    floorActivityList = [];
    selectedFloorActivity = null;
    flatActivityList = [];
    selectedFlatActivity = null;
    floorActivityTypeList = [];
    selectedFloorActivityType = null;
    flatActivityTypeList = [];
    selectedFlatActivityType = null;
    floorChecklistList = [];
    selectedFloorChecklist = null;
    flatChecklistList = [];
    selectedFlatChecklist = null;
    update();

    await getTowerNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId
    });
  }

  selectFlat(int id) async {
    for (var element in flatList) {
      if (element.flatId == id) {
        selectedFlatData = element;
      }
    }
    filterIndex = 2;
    flatActivityList = [];
    selectedFlatActivity = null;
    flatActivityTypeList = [];
    selectedFlatActivityType = null;
    flatChecklistList = [];
    selectedFlatChecklist = null;

    update();
    await getFlatNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "flat_id": selectedFlatData?.flatId,
    });
  }

  selectFlatActivity(int id) async {
    for (var element in flatActivityList) {
      if (element.activityId == id) {
        selectedFlatActivity = element;
      }
    }
    filterIndex = 3;
    flatActivityTypeList = [];
    selectedFlatActivityType = null;
    flatChecklistList = [];
    selectedFlatChecklist = null;

    update();
    await getFlatAcNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "flat_id": selectedFlatData?.flatId,
      "activity_id": selectedFlatActivity?.activityId
    });
  }

  selectFlatActivityType(int id) async {
    for (var element in flatActivityTypeList) {
      if (element.activityTypeId == id) {
        selectedFlatActivityType = element;
      }
    }
    filterIndex = 4;
    flatChecklistList = [];
    selectedFlatChecklist = null;

    update();
    await getFlatAcTypeNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "flat_id": selectedFlatData?.flatId,
      "activity_id": selectedFlatActivity?.activityId,
      "type_id": selectedFlatActivityType?.activityTypeId
    });
  }

  selectFlatChecklist(int id) async {
    for (var element in flatChecklistList) {
      if (element.checklistId == id) {
        selectedFlatChecklist = element;
      }
    }
    filterIndex = 5;
    update();
    await getFlatChecklistNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "flat_id": selectedFlatData?.flatId,
      "activity_id": selectedFlatActivity?.activityId,
      "type_id": selectedFlatActivityType?.activityTypeId,
      "checklist_id": selectedFlatChecklist?.checklistId
    });
  }

  selectFloor(int id) async {
    for (var element in floorList) {
      if (element.floorId == id) {
        selectedFloorData = element;
      }
    }
    filterIndex = 6;
    floorActivityList = [];
    selectedFloorActivity = null;
    floorActivityTypeList = [];
    selectedFloorActivityType = null;
    floorChecklistList = [];
    selectedFloorChecklist = null;

    update();
    await getFloorNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "floor_id": selectedFloorData?.floorId,
    });
  }

  selectFloorActivity(int id) async {
    for (var element in floorActivityList) {
      if (element.activityId == id) {
        selectedFloorActivity = element;
      }
    }
    filterIndex = 7;
    floorActivityTypeList = [];
    selectedFloorActivityType = null;
    floorChecklistList = [];
    selectedFloorChecklist = null;

    update();
    await getFloorAcNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "floor_id": selectedFloorData?.floorId,
      "activity_id": selectedFloorActivity?.activityId
    });
  }

  selectFloorActivityType(int id) async {
    for (var element in floorActivityTypeList) {
      if (element.activityTypeId == id) {
        selectedFloorActivityType = element;
      }
    }
    filterIndex = 8;
    floorChecklistList = [];
    selectedFloorChecklist = null;

    update();
    await getFloorAcTypeNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "floor_id": selectedFloorData?.floorId,
      "activity_id": selectedFloorActivity?.activityId,
      "type_id": selectedFloorActivityType?.activityTypeId
    });
  }

  selectFloorChecklist(int id) async {
    for (var element in floorChecklistList) {
      if (element.checklistId == id) {
        selectedFloorChecklist = element;
      }
    }
    filterIndex = 9;
    update();
    await getFloorChecklistNcController(body: {
      "project_id": int.parse(projectId),
      "tower_id": selectedTower?.towerId,
      "floor_id": selectedFloorData?.floorId,
      "activity_id": selectedFloorActivity?.activityId,
      "type_id": selectedFloorActivityType?.activityTypeId,
      "checklist_id": selectedFloorChecklist?.checklistId
    });
  }

  /// PROJECT NC

  Future<dynamic> getProjectNcController({Map<String, dynamic>? body}) async {
    _getProjectNCApiResponse = ApiResponse.loading(message: 'Loading');
    towerList = [];
    update();
    try {
      projectNcResponseModel = await NcRepo().ncProjectRepo(body: body);

      _getProjectNCApiResponse = ApiResponse.complete(projectNcResponseModel);

      ncModel = NcModel(
          totalNc: projectNcResponseModel?.projectData?.ncCount ?? 0,
          yellow: projectNcResponseModel?.projectData?.yellowFlagCount ?? 0,
          orange: projectNcResponseModel?.projectData?.orangeFlagCount ?? 0,
          red: projectNcResponseModel?.projectData?.redFlagCount ?? 0,
          green: projectNcResponseModel?.projectData?.greenFlagCount ?? 0);

      towerList = projectNcResponseModel?.projectData?.towerData ?? [];
    } catch (e) {
      _getProjectNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getProjectNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// TOWER NC

  Future<dynamic> getTowerNcController({Map<String, dynamic>? body}) async {
    _getTowerNCApiResponse = ApiResponse.loading(message: 'Loading');
    flatList = [];
    floorList = [];
    update();
    try {
      towerNcResponseModel = await NcRepo().ncTowerRepo(body: body);
      _getTowerNCApiResponse = ApiResponse.complete(towerNcResponseModel);
      flatList = towerNcResponseModel?.projectData?.flatData ?? [];
      floorList = towerNcResponseModel?.projectData?.floorData ?? [];
    } catch (e) {
      _getTowerNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getTowerNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLAT NC

  Future<dynamic> getFlatNcController({Map<String, dynamic>? body}) async {
    _getFlatNcApiResponse = ApiResponse.loading(message: 'Loading');
    flatActivityList = [];

    update();
    try {
      flatNcResponseModel = await NcRepo().ncFlatRepo(body: body);
      _getFlatNcApiResponse = ApiResponse.complete(flatNcResponseModel);
      flatActivityList = flatNcResponseModel?.projectData?.activityData ?? [];
    } catch (e) {
      _getFlatNcApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatNcApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLAT AC NC

  Future<dynamic> getFlatAcNcController({Map<String, dynamic>? body}) async {
    _getFlatAcNCApiResponse = ApiResponse.loading(message: 'Loading');
    flatActivityTypeList = [];
    update();
    try {
      flatActivityNcResponseModel = await NcRepo().ncFlatAcRepo(body: body);
      _getFlatAcNCApiResponse =
          ApiResponse.complete(flatActivityNcResponseModel);
      flatActivityTypeList =
          flatActivityNcResponseModel?.projectData?.activityType ?? [];
    } catch (e) {
      _getFlatAcNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatAcNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLAT AC TYPE NC

  Future<dynamic> getFlatAcTypeNcController(
      {Map<String, dynamic>? body}) async {
    _getFlatAcTypeNCApiResponse = ApiResponse.loading(message: 'Loading');
    flatChecklistList = [];
    update();
    try {
      flatActivityTypeNcResponseModel =
          await NcRepo().ncFlatAcTypeRepo(body: body);
      _getFlatAcTypeNCApiResponse =
          ApiResponse.complete(flatActivityTypeNcResponseModel);
      flatChecklistList =
          flatActivityTypeNcResponseModel?.projectData?.checklist ?? [];
    } catch (e) {
      _getFlatAcTypeNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatAcTypeNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLAT CHECKLIST NC

  Future<dynamic> getFlatChecklistNcController(
      {Map<String, dynamic>? body}) async {
    _getFlatChecklistNcApiResponse = ApiResponse.loading(message: 'Loading');

    update();
    try {
      flatChecklistNcResponseModel =
          await NcRepo().ncFlatCheckListRepo(body: body);
      _getFlatChecklistNcApiResponse =
          ApiResponse.complete(flatChecklistNcResponseModel);

      log('flatChecklistNcResponseModel----------- $flatChecklistNcResponseModel');
    } catch (e) {
      _getFlatChecklistNcApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatChecklistNcApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLOOR NC

  Future<dynamic> getFloorNcController({Map<String, dynamic>? body}) async {
    _getFloorNCApiResponse = ApiResponse.loading(message: 'Loading');

    floorActivityList = [];
    update();
    try {
      floorNcResponseModel = await NcRepo().ncFloorRepo(body: body);
      _getFloorNCApiResponse = ApiResponse.complete(floorNcResponseModel);
      floorActivityList = floorNcResponseModel?.projectData?.activityData ?? [];
    } catch (e) {
      _getFloorNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getFloorNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLOOR AC NC

  Future<dynamic> getFloorAcNcController({Map<String, dynamic>? body}) async {
    _getFloorAcNCApiResponse = ApiResponse.loading(message: 'Loading');
    floorActivityTypeList = [];
    update();
    log('body--------getFloorAcNcController--- ${body}');

    try {
      activityNcResponseModel = await NcRepo().ncFloorAcRepo(body: body);
      _getFloorAcNCApiResponse = ApiResponse.complete(activityNcResponseModel);
      floorActivityTypeList =
          activityNcResponseModel?.projectData?.activityType ?? [];
    } catch (e) {
      _getFloorAcNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getFloorAcNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLOOR AC TYPE NC

  Future<dynamic> getFloorAcTypeNcController(
      {Map<String, dynamic>? body}) async {
    _getFloorAcTypeNCApiResponse = ApiResponse.loading(message: 'Loading');
    floorChecklistList = [];
    update();
    try {
      activityTypeNcResponseModel =
          await NcRepo().ncFloorAcTypeRepo(body: body);
      _getFloorAcTypeNCApiResponse =
          ApiResponse.complete(activityTypeNcResponseModel);
      floorChecklistList =
          activityTypeNcResponseModel?.projectData?.checklist ?? [];
    } catch (e) {
      _getFloorAcTypeNCApiResponse = ApiResponse.error(message: e.toString());
      log("_getFloorAcTypeNCApiResponse=ERROR=>$e");
    }
    update();
  }

  /// FLOOR CHECKLIST NC

  Future<dynamic> getFloorChecklistNcController(
      {Map<String, dynamic>? body}) async {
    _getFloorChecklistNCApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      checklistNcResponseModel =
          await NcRepo().ncFloorCheckListRepo(body: body);
      _getFloorChecklistNCApiResponse =
          ApiResponse.complete(checklistNcResponseModel);
    } catch (e) {
      _getFloorChecklistNCApiResponse =
          ApiResponse.error(message: e.toString());
      log("_getFloorChecklistNCApiResponse=ERROR=>$e");
    }
    update();
  }

  clearFilter() {
    filterIndex = 0;
    selectedTower = null;
    floorList = [];
    selectedFloorData = null;
    flatList = [];
    selectedFlatData = null;
    floorActivityList = [];
    selectedFloorActivity = null;
    flatActivityList = [];
    selectedFlatActivity = null;
    floorActivityTypeList = [];
    selectedFloorActivityType = null;
    flatActivityTypeList = [];
    selectedFlatActivityType = null;
    floorChecklistList = [];
    selectedFloorChecklist = null;
    flatChecklistList = [];
    selectedFlatChecklist = null;
    update();
  }

  applyFilter() {
    if (filterIndex == 0) {
      ncModel = NcModel(
          totalNc: projectNcResponseModel?.projectData?.ncCount,
          green: projectNcResponseModel?.projectData?.greenFlagCount,
          red: projectNcResponseModel?.projectData?.redFlagCount,
          orange: projectNcResponseModel?.projectData?.orangeFlagCount,
          yellow: projectNcResponseModel?.projectData?.yellowFlagCount);
    }
    if (filterIndex == 1) {
      ncModel = NcModel(
          totalNc: towerNcResponseModel?.projectData?.projectNc,
          green: towerNcResponseModel?.projectData?.greenFlagCount,
          red: towerNcResponseModel?.projectData?.projectRed,
          orange: towerNcResponseModel?.projectData?.projectOrange,
          yellow: towerNcResponseModel?.projectData?.projectYellow);
    }
    if (filterIndex == 2) {
      ncModel = NcModel(
          totalNc: flatNcResponseModel?.projectData?.nc,
          green: flatNcResponseModel?.projectData?.flatsGreen,
          red: flatNcResponseModel?.projectData?.flatsRed,
          orange: flatNcResponseModel?.projectData?.flatsOrange,
          yellow: flatNcResponseModel?.projectData?.flatsYellow);
    }
    if (filterIndex == 3) {
      ncModel = NcModel(
          totalNc: flatActivityNcResponseModel?.projectData?.actNc,
          green: flatActivityNcResponseModel?.projectData?.actGreen,
          red: flatActivityNcResponseModel?.projectData?.actRed,
          orange: flatActivityNcResponseModel?.projectData?.actOrange,
          yellow: flatActivityNcResponseModel?.projectData?.actYellow);
    }
    if (filterIndex == 4) {
      ncModel = NcModel(
          totalNc: flatActivityTypeNcResponseModel?.projectData?.actTypeNc,
          green: flatActivityTypeNcResponseModel?.projectData?.actTypeGreen,
          red: flatActivityTypeNcResponseModel?.projectData?.actTypeRed,
          orange: flatActivityTypeNcResponseModel?.projectData?.actTypeOrange,
          yellow: flatActivityTypeNcResponseModel?.projectData?.actTypeYellow);
    }
    if (filterIndex == 5) {
      ncModel = NcModel(
          totalNc: flatChecklistNcResponseModel?.projectData?.projectLineNc,
          green: 0,
          red: flatChecklistNcResponseModel?.projectData?.projectLineRed,
          orange: flatChecklistNcResponseModel?.projectData?.projectLineOrange,
          yellow: flatChecklistNcResponseModel?.projectData?.projectLineYellow);
    }
    if (filterIndex == 6) {
      ncModel = NcModel(
          totalNc: floorNcResponseModel?.projectData?.nc,
          green: floorNcResponseModel?.projectData?.floorsGreen,
          red: floorNcResponseModel?.projectData?.floorsRed,
          orange: floorNcResponseModel?.projectData?.floorsOrange,
          yellow: floorNcResponseModel?.projectData?.floorsYellow);
    }
    if (filterIndex == 7) {
      ncModel = NcModel(
          totalNc: activityNcResponseModel?.projectData?.actNc,
          green: activityNcResponseModel?.projectData?.actGreen,
          red: activityNcResponseModel?.projectData?.actRed,
          orange: activityNcResponseModel?.projectData?.actOrange,
          yellow: activityNcResponseModel?.projectData?.actYellow);
    }
    if (filterIndex == 8) {
      ncModel = NcModel(
          totalNc: activityTypeNcResponseModel?.projectData?.actTypeNc,
          green: activityTypeNcResponseModel?.projectData?.actTypeGreen,
          red: activityTypeNcResponseModel?.projectData?.actTypeRed,
          orange: activityTypeNcResponseModel?.projectData?.actTypeOrange,
          yellow: activityTypeNcResponseModel?.projectData?.actTypeYellow);
    }
    if (filterIndex == 9) {
      ncModel = NcModel(
          totalNc: checklistNcResponseModel?.projectData?.projectLineNc,
          green: 0,
          red: checklistNcResponseModel?.projectData?.projectLineRed,
          orange: checklistNcResponseModel?.projectData?.projectLineOrange,
          yellow: checklistNcResponseModel?.projectData?.projectLineYellow);
    }

    Get.back();
    update();
  }
}

class NcModel {
  int? totalNc;
  int? yellow;
  int? orange;
  int? red;
  int? green;

  NcModel({
    this.totalNc,
    this.yellow,
    this.orange,
    this.red,
    this.green,
  });

  factory NcModel.fromJson(Map<String, dynamic> json) => NcModel(
        totalNc: json["nc"],
        yellow: json["floors_yellow"],
        orange: json["floors_orange"],
        red: json["floors_red"],
        green: json["floors_green"],
      );
}
