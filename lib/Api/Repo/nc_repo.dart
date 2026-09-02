import 'dart:developer';

import 'package:jhamtani_app/Api/ResponseModel/nc_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_flat_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_project_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_tower_res_model.dart';
import 'package:jhamtani_app/Api/Services/api_service.dart';
import 'package:jhamtani_app/Api/Services/base_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';



class NcRepo {
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// PROJECT NC REPO

  Future<dynamic> ncProjectRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncProjectData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('projectNcResponseModel----123----response>> $response');

    ProjectNcResponseModel projectNcResponseModel =
        ProjectNcResponseModel.fromJson(response);

    log('projectNcResponseModel --- response>> $projectNcResponseModel');

    return projectNcResponseModel;
  }

  /// TOWER NC REPO

  Future<dynamic> ncTowerRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncTowerData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('towerNcResponseModel----123----response>> $response');

    TowerNcResponseModel towerNcResponseModel =
        TowerNcResponseModel.fromJson(response);

    log('towerNcResponseModel --- response>> $towerNcResponseModel');

    return towerNcResponseModel;
  }

    /// FLOOR NC REPO

  Future<dynamic> ncFloorRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFloorData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('floorNcResponseModel----123----response>> $response');

    FloorNcResponseModel floorNcResponseModel =
        FloorNcResponseModel.fromJson(response);

    log('floorNcResponseModel --- response>> $floorNcResponseModel');

    return floorNcResponseModel;
  }

  /// FLOOR AC NC REPO

  Future<dynamic> ncFloorAcRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFloorAcData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('floorAcNcResponseModel----123----response>> $response');

    ActivityNcResponseModel floorAcNcResponseModel =
        ActivityNcResponseModel.fromJson(response);

    log('floorAcNcResponseModel --- response>> $floorAcNcResponseModel');

    return floorAcNcResponseModel;
  }

  /// FLOOR AC TYPE NC REPO

  Future<dynamic> ncFloorAcTypeRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFloorAcTypeData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('floorAcTypeNcResponseModel----123----response>> $response');

    ActivityTypeNcResponseModel floorAcTypeNcResponseModel =
        ActivityTypeNcResponseModel.fromJson(response);

    log('floorAcTypeNcResponseModel --- response>> $floorAcTypeNcResponseModel');

    return floorAcTypeNcResponseModel;
  }

  /// FLOOR CHECKLIST NC REPO

  Future<dynamic> ncFloorCheckListRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFloorChecklistData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('checklistNcResponseModel----123----response>> $response');

    ChecklistNcResponseModel checklistNcResponseModel =
        ChecklistNcResponseModel.fromJson(response);

    log('checklistNcResponseModel --- response>> $checklistNcResponseModel');

    return checklistNcResponseModel;
  }

  /// FLAT NC REPO

  Future<dynamic> ncFlatRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFlatData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('flatNcResponseModel----123----response>> $response');

    FlatNcResponseModel flatNcResponseModel =
        FlatNcResponseModel.fromJson(response);

    log('flatNcResponseModel --- response>> $flatNcResponseModel');

    return flatNcResponseModel;
  }

  /// FLAT AC NC REPO

  Future<dynamic> ncFlatAcRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFlatAcData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('activityNcResponseModel----123----response>> $response');

    ActivityNcResponseModel activityNcResponseModel =
        ActivityNcResponseModel.fromJson(response);

    log('activityNcResponseModel --- response>> $activityNcResponseModel');

    return activityNcResponseModel;
  }

  /// FLAT AC TYPE NC REPO

  Future<dynamic> ncFlatAcTypeRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFlatAcTypeData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('activityTypeNcResponseModel----123----response>> $response');

    ActivityTypeNcResponseModel activityTypeNcResponseModel =
        ActivityTypeNcResponseModel.fromJson(response);

    log('activityTypeNcResponseModel --- response>> $activityTypeNcResponseModel');

    return activityTypeNcResponseModel;
  }

  /// FLAT CHECKLIST NC REPO

  Future<dynamic> ncFlatCheckListRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncFlatChecklistData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('checklistNcResponseModel----123----response>> $response');

    ChecklistNcResponseModel checklistNcResponseModel =
        ChecklistNcResponseModel.fromJson(response);

    log('checklistNcResponseModel --- response>> $checklistNcResponseModel');

    return checklistNcResponseModel;
  }
}
