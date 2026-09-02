
//LAST UPDATED BY USERNAME

import 'dart:developer';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/development_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_floor_data_res_model.dart';

class ActivityDetailsController extends GetxController {
  ConstDataModel constData = ConstDataModel();
  String id = '';
  String status1 = "";
  ListFloorData? floorData;
  ListFlatData? flatData;
  ActivityItem? activityCommonData;
  DevelopmentActivityItem? developmentActivityCommonData;

  ActivityTypeItem? activityTypeData;
  List<ListChecklistDataByAc>? checklistData;
  String activityId = '';
  CommonActivityTypeResponseModel commonActivityTypeResponseModel =
      CommonActivityTypeResponseModel();
  List<ActivityTypeItem> activityTypeCommonData = [];

  List<ActivityTypeItem> searchActivityTypeCommonData = [];

  CommonActivityTypeResponseModel? commonActivityTypeResponse;

  Future<dynamic> getActivityData() async {
    activityId = Get.arguments['activityId']?.toString() ?? '';
    constData = Get.arguments["model"] as ConstDataModel;
    log('activityId::::::::::::::::$activityId');
    log('constData::::::::::::::::${constData.data}');
    log('constData.screen::::::::::::::::${constData.screen}');
    if (constData.screen == 'flat') {
      flatData = constData.data;
      await getActivityChecklistController(
          body: {"activity_id": '${flatData?.activityId ?? ""}'});
    } else if (constData.screen == 'tower_details') {
      activityTypeData = constData.data;
      await getActivityChecklistController(
          body: {"activity_id": '${activityTypeData?.activityId ?? ""}'});
    } else if (constData.screen == 'floor') {
      floorData = constData.data;
      await getActivityChecklistController(
          body: {"activity_id": '${floorData?.activityId ?? ""}'});
    } else {
      checklistData = constData.data;
    }
    update();
  }

  /// API

  ApiResponse _getActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getActivityChecklistApiResponse =>
      _getActivityChecklistApiResponse;

  Future<dynamic> getActivityChecklistController(
      {Map<String, dynamic>? body}) async {
    _getActivityChecklistApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      ChecklistByActivityResponseModel response =
          await ProjectRepo().getActivityChecklistRepo(body: body);
      _getActivityChecklistApiResponse = ApiResponse.complete(response);

      log("_getActivityChecklistApiResponse==>$response");
    } catch (e) {
      _getActivityChecklistApiResponse =
          ApiResponse.error(message: e.toString());
      log("_getActivityChecklistApiResponse=ERROR=getActivityChecklistController>$e");
    }
    update();
  }

////////////// for common tab activity type
  ApiResponse _getCommonActivityTypeChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getCommonActivityTypeChecklistApiResponse =>
      _getCommonActivityTypeChecklistApiResponse;

  Future<dynamic> fetchCommonActivityTypeChecklist(
      {Map<String, dynamic>? body}) async {
    _getCommonActivityTypeChecklistApiResponse =
        ApiResponse.loading(message: 'Loading');
    log("Fetching checklist data for  activity_id: $activityId");

    try {
      final requestBody = {
        "activity_id": int.tryParse(activityId) ?? activityId
      };
      commonActivityTypeResponse =
          await ProjectRepo().getCommonActivityTypeDataRepo(body: requestBody);

      if (commonActivityTypeResponse != null &&
          commonActivityTypeResponse!.status == "SUCCESS") {
        activityTypeCommonData =
            commonActivityTypeResponse?.activityData?.listChecklistData ?? [];

        activityTypeCommonData = List.from(activityTypeCommonData);
        _getCommonActivityTypeChecklistApiResponse =
            ApiResponse.complete(commonActivityTypeResponse);
        log("Checklist Data Loaded Successfully: ${activityTypeCommonData.length} items");
      } else {
        log("Checklist data not found: ${commonActivityTypeResponse?.message}");
        _getCommonActivityTypeChecklistApiResponse = ApiResponse.error(
            message: commonActivityTypeResponse?.message ??
                "Checklist not available");
      }

      update();
    } catch (e) {
      log("fetchCommonChecklist error: $e");
      _getCommonActivityTypeChecklistApiResponse =
          ApiResponse.error(message: e.toString());
      update();
    }
  }
}


// class ActivityDetailsController extends GetxController {
//   ConstDataModel constData = ConstDataModel();
//   String id = '';
//   String status1 = "";
//   ListFloorData? floorData;
//   ListFlatData? flatData;
//   ActivityItem? activityCommonData;
//   DevelopmentActivityItem? developmentActivityCommonData;

//   ActivityTypeItem? activityTypeData;
//   List<ListChecklistDataByAc>? checklistData;
//   String activityId = '';
//   CommonActivityTypeResponseModel commonActivityTypeResponseModel = CommonActivityTypeResponseModel();
//   List<ActivityTypeItem> activityTypeCommonData = [];

//   List<ActivityTypeItem> searchActivityTypeCommonData = [];

//   CommonActivityTypeResponseModel? commonActivityTypeResponse;

//   Future<dynamic> getActivityData() async {
//     activityId = Get.arguments['activityId']?.toString() ?? '';
//     constData = Get.arguments["model"] as ConstDataModel;
//     log('activityId::::::::::::::::${activityId}');
//     log('constData::::::::::::::::${constData.data}');
//     log('constData.screen::::::::::::::::${constData.screen}');
//     if (constData.screen == 'flat') {
//       flatData = constData.data;
//       await getActivityChecklistController(body: {"activity_id": '${flatData?.activityId ?? ""}'});
//     } else if (constData.screen == 'tower_details') {
//       activityTypeData = constData.data;
//       await getActivityChecklistController(body: {"activity_id": '${activityTypeData?.activityId ?? ""}'});
//     } else if (constData.screen == 'floor') {
//       floorData = constData.data;
//       await getActivityChecklistController(body: {"activity_id": '${floorData?.activityId ?? ""}'});
//     } else {
//       checklistData = constData.data;
//     }
//     update();
//   }

//   /// API

//   ApiResponse _getActivityChecklistApiResponse = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getActivityChecklistApiResponse => _getActivityChecklistApiResponse;

//   Future<dynamic> getActivityChecklistController({Map<String, dynamic>? body}) async {
//     _getActivityChecklistApiResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       ChecklistByActivityResponseModel response = await ProjectRepo().getActivityChecklistRepo(body: body);
//       _getActivityChecklistApiResponse = ApiResponse.complete(response);

//       log("_getActivityChecklistApiResponse==>$response");
//     } catch (e) {
//       _getActivityChecklistApiResponse = ApiResponse.error(message: e.toString());
//       log("_getActivityChecklistApiResponse=ERROR=getActivityChecklistController>$e");
//     }
//     update();
//   }

// ////////////// for common tab activity type
//   ApiResponse _getCommonActivityTypeChecklistApiResponse = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getCommonActivityTypeChecklistApiResponse => _getCommonActivityTypeChecklistApiResponse;

//   Future<dynamic> fetchCommonActivityTypeChecklist({Map<String, dynamic>? body}) async {
//     _getCommonActivityTypeChecklistApiResponse = ApiResponse.loading(message: 'Loading');
//     log("Fetching checklist data for  activity_id: $activityId");

//     try {
//       final requestBody = {"activity_id": int.tryParse(activityId) ?? activityId};
//       commonActivityTypeResponse = await ProjectRepo().getCommonActivityTypeDataRepo(body: requestBody);

//       if (commonActivityTypeResponse != null && commonActivityTypeResponse!.status == "SUCCESS") {
//         activityTypeCommonData = commonActivityTypeResponse?.activityData?.listChecklistData ?? [];

//         activityTypeCommonData = List.from(activityTypeCommonData);
//         _getCommonActivityTypeChecklistApiResponse = ApiResponse.complete(commonActivityTypeResponse);
//         log("Checklist Data Loaded Successfully: ${activityTypeCommonData.length} items");
//       } else {
//         log("Checklist data not found: ${commonActivityTypeResponse?.message}");
//         _getCommonActivityTypeChecklistApiResponse =
//             ApiResponse.error(message: commonActivityTypeResponse?.message ?? "Checklist not available");
//       }

//       update();
//     } catch (e) {
//       log("fetchCommonChecklist error: $e");
//       _getCommonActivityTypeChecklistApiResponse = ApiResponse.error(message: e.toString());
//       update();
//     }
//   }
// }
