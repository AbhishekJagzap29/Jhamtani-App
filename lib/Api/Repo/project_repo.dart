import 'dart:convert';
import 'dart:developer';

import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_by_app_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_close_state_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_flat_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_project_responsible_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_tower_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/impact_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/submit_multiple_observation_res_model.dart';
import 'package:flutter/material.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/complete_for_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/download_pdf_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/fetch_obs_resubmit_maker_checker_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/fetch_observation_form_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_flat_list_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_category_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/observation_completed_form_checker_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/observation_history_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/observation_resubmit_to_checker_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/site_visits_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/submit_flat_for_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/submit_observation_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/document_no_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/material_count_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/material_description_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/supplier_name_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/ucom_code_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/development_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checkpoint_details_by_activity_type_id.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_material_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/material_inspection_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_details_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/Api/Services/api_service.dart';
import 'package:jhamtani_app/Api/Services/base_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';

class ProjectRepo {
  Map<String, String> header = {
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// GET PROJECT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getAssignedProjectRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getAssignedProject,
      apiType: APIType.aPost,
      body: {},
      header: header,
    );

    log('projectScreenResponseModel --- response>> $response');

    AssignedProjectResponseModel projectScreenResponseModel =
        AssignedProjectResponseModel.fromJson(response);

    log('projectScreenResponseModel --- response>> $response');

    return projectScreenResponseModel;
  }

  /// GET PROJECT DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> projectDetailsRepo({Map<String, dynamic>? body}) async {
    log('header1::::::::::::::::${header1}');
    var response = await APIService().getResponse(
      url: ApiRouts.projectDetails,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('projectDetailsResponseModel --- response>> $response');

    ProjectDetailsResponseModel projectDetailsResponseModel =
        ProjectDetailsResponseModel.fromJson(response);

    log('projectDetailsResponseModel --- response>> $response');

    return projectDetailsResponseModel;
  }

  /// GET TOWER INFO :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> towerInfoChecklistRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.towerInfoCheckList,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getTowerInfoChecklistResponseModel --- response>> $response');

    GetTowerInfoChecklistResponseModel getTowerInfoChecklistResponseModel =
        GetTowerInfoChecklistResponseModel.fromJson(response);

    log('getTowerInfoChecklistResponseModel --- response>> $response');

    return getTowerInfoChecklistResponseModel;
  }

  /// GET FLAT FLOOR DETAILS :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getFlatFloorRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getFlatFloor,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getFlatFloorDataResponseModel --- response>> $response');

    GetFlatFloorDataResponseModel getFlatFloorDataResponseModel =
        GetFlatFloorDataResponseModel.fromJson(response);

    log('getFlatFloorDataResponseModel --- response>> $response');

    return getFlatFloorDataResponseModel;
  }

/////// GET COMMON CHECKLIST DETAILS :::::::::::::::::::::::::::::::::::::::
//////////////for activity type ::::::::::::::::::::::::::::::::::

  Future<dynamic> getCommonActivityDataRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getCommonActivityData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getCommonActivityDataRepo --- response>> $response');

    CommonActivityResponseModel commonActivityResponseModel =
        CommonActivityResponseModel.fromJson(response);

    log('commonActivityResponseModel --- response>> $response');

    return commonActivityResponseModel;
  }

///////////// for activity type :::::::::::::::::::::::::::::

  Future<dynamic> getCommonActivityTypeDataRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getCommonActivityTypeData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getCommonActivityTypeDataRepo --- response>> $response');

    CommonActivityTypeResponseModel commonActivityTypeResponseModel =
        CommonActivityTypeResponseModel.fromJson(response);

    log('commonActivityTypeResponseModel --- response>> $response');

    return commonActivityTypeResponseModel;
  }

///////////////// development tab
  Future<dynamic> getDevelopmentActivityDataRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getDevelopmentActivityData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getDevelopmentActivityDataRepo --- response>> $response');

    DevelopmentResponseModel developmentResponseModel =
        DevelopmentResponseModel.fromJson(response);

    log('developmentResponseModel --- response>> $response');

    return developmentResponseModel;
  }

  /// GET Material Inspection::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getMaterialInspection({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getMaterialInspection,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getMaterialInspectionResponse --- response>> $response');

    MaterialInspectionResponseModel materialInspectionResponseModel =
        MaterialInspectionResponseModel.fromJson(response);

    log('getMaterialInspectionResponse --- response>> $response');

    return materialInspectionResponseModel;
  }

//// get project for material inspection ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ///project name
// Future<dynamic> getMaterialProjectRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getMaterialProject,
//       apiType: APIType.aPost,
//       body: body ?? {},
//       header: header1,
//     );

//     log('getBusinessUnitResponseRepo --- response>> $response');

//     BusinessUnitResponseModel businessUnitResponseModel =
//         BusinessUnitResponseModel.fromJson(response);

//     log('getBusinessUnitResponseRepo --- response>> $response');

//     return businessUnitResponseModel;
//   }

////////////documnet number
  Future<dynamic> getDocumentNumberRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getDocumentNo,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getDocumentNumberRepo --- response>> $response');

    DocumnetNumberResponseModel documnetNumberResponseModel =
        DocumnetNumberResponseModel.fromJson(response);

    log('getDocumentNumberRepo --- parsed response>> ${documnetNumberResponseModel.toJson()}');

    return documnetNumberResponseModel;
  }

////supplier name
  Future<dynamic> getLedgerDescriptionRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getMaterialSupplierName,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getLedgerDescriptionRepo --- response>> $response');

    LedgerDescriptionResponseModel ledgerDescriptionResponseModel =
        LedgerDescriptionResponseModel.fromJson(response);

    log('getLedgerDescriptionRepo --- parsed response>> ${ledgerDescriptionResponseModel.toJson()}');

    return ledgerDescriptionResponseModel;
  }

//// material description
  Future<dynamic> getMaterialDescriptionRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getMaterialdescription,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getMaterialDescriptionRepo --- response>> $response');

    MaterialDescriptionResponseModel materialDescriptionResponseModel =
        MaterialDescriptionResponseModel.fromJson(response);

    log('getMaterialDescriptionRepo --- parsed response>> ${materialDescriptionResponseModel.toJson()}');

    return materialDescriptionResponseModel;
  }

////// material quantity
  // Future<dynamic> getMaterialquantityRepo({Map<String, dynamic>? body}) async {
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.getMaterialquantity,
  //     apiType: APIType.aPost,
  //     body: body,
  //     header: header1,
  //   );

  //   log('getMaterialquantityRepo --- response>> $response');

  //   MaterialQuantityResponseModel materialQuantityResponseModel =
  //       MaterialQuantityResponseModel.fromJson(response);

  //   log('getMaterialquantityRepo --- parsed response>> ${materialQuantityResponseModel.toJson()}');

  //   return materialQuantityResponseModel;
  // }

//// material  uomCode

  Future<dynamic> getUomCodeRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getUomCode,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getUomCodeRepo --- response>> $response');

    UomCodeResponseModel uomCodeResponseModel =
        UomCodeResponseModel.fromJson(response);

    log('getUomCodeRepo --- parsed response>> ${uomCodeResponseModel.toJson()}');

    return uomCodeResponseModel;
  }

///// material count

  Future<dynamic> getmaterialcountRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getmaterialcount,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getmaterialcountRepo --- response>> $response');

    MaterialCountResModel materialCountResModel =
        MaterialCountResModel.fromJson(response);

    log('getmaterialcountRepo --- parsed response>> $response');

    return materialCountResModel;
  }

  /// GET FLOOR DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getFloorRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getFloorActivity,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getFloorDataResponseModel --- response>> $response');

    GetFloorDataResponseModel getFloorDataResponseModel =
        GetFloorDataResponseModel.fromJson(response);

    log('getFloorDataResponseModel --- response>> $response');

    return getFloorDataResponseModel;
  }

  /// GET FLAT DETAILS :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getFlatRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getFlatActivity,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getFlatDataResponseModel --- response>> $response');

    GetFlatDataResponseModel getFlatDataResponseModel =
        GetFlatDataResponseModel.fromJson(response);

    log('getFlatDataResponseModel --- response>> $response');

    return getFlatDataResponseModel;
  }

  /// GET ACTIVITY CHECKLIST :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getActivityChecklistRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getCheckListByActivity,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getActivityChecklistResponseModel --- response>> $response');

    ChecklistByActivityResponseModel getActivityChecklistResponseModel =
        ChecklistByActivityResponseModel.fromJson(response);

    log('getActivityChecklistResponseModel --- response>> $response');

    return getActivityChecklistResponseModel;
  }

  /// GET Material Inspection Check List :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getMaterialInspectionCheckList() async {
    var response = await APIService().getResponse(
        url: ApiRouts.getMaterialInspectionCheckList,
        apiType: APIType.aPost,
        header: header1,
        body: {});

    log('getMaterialInspectionCheckList --- response>> $response');

    MaterialInspectionPointsModel getMaterialInspectionCheckList =
        MaterialInspectionPointsModel.fromJson(response);

    log('getMaterialInspectionCheckList --- response>> $response');

    return getMaterialInspectionCheckList;
  }

  /// Create Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> createMaterialInspection({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.createMaterialInspection,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('createMaterialInspection --- response>> $response');
    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);
    log('createMaterialInspection --- response>> $response');
    return successDataResponseModel;
  }

  /// Delete Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> deleteMaterialInspection({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.deleteMaterialInspection,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('deleteMaterialInspection --- response>> $response');
    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);
    log('deleteMaterialInspection --- response>> $response');
    return successDataResponseModel;
  }

  /// Replicate Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> replicateMaterialInspection(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.replicateMaterialInspection,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('replicateMaterialInspection --- response>> $response');
    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);
    log('replicateMaterialInspection --- response>> $response');
    return successDataResponseModel;
  }

  /// Update Material inspection ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // Future<dynamic> updateMaterialInspection({Map<String, dynamic>? body}) async {
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.updateMaterialInspection,
  //     apiType: APIType.aPost,
  //     body: body,
  //     header: header1,
  //   );
  //
  //   log('updateMaterialInspection --- response>> $response');
  //   SuccessDataResponseModel successDataResponseModel =
  //       SuccessDataResponseModel.fromJson(response);
  //   log('updateMaterialInspection --- response>> $response');
  //   return successDataResponseModel;
  // }

  /// UPLOAD DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> updateChecklistRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: preferences.getString(SharedPreference.userType) == "checker"
          ? ApiRouts.updateCheckerData
          : preferences.getString(SharedPreference.userType) == "approver"
              ? ApiRouts.updateApproverData
              : ApiRouts.updateMakerData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('successDataResponseModel --- response>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response>> $response');

    return successDataResponseModel;
  }

  /// REJECT DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> rejectChecklistRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: preferences.getString(SharedPreference.userType) == "checker"
          ? ApiRouts.rejectMakerData
          : ApiRouts.rejectCheckerData,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('successDataResponseModel --- response>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response>> $response');

    return successDataResponseModel;
  }

  /// GET CHECKLIST BY ACTIVITY_TYPE_ID DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getChecklistByActivityTypeId(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.projectChecklistByAc,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getCheckPointDetailsByActivityTypeId --- response>> $response');

    GetCheckPointDetailsByActivityTypeId getCheckPointDetailsByActivityTypeId =
        GetCheckPointDetailsByActivityTypeId.fromJson(response);

    log('getCheckPointDetailsByActivityTypeId --- response>> $response');

    return getCheckPointDetailsByActivityTypeId;
  }

  /// DUPLICATE ACTIVITY REPO FOR FLAT/FLOOR::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> duplicateActivityRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.duplicateActivity,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('duplicateActivityRepo --- response>> $response');

    SuccessDataResponseModel duplicateActivityRepo =
        SuccessDataResponseModel.fromJson(response);

    log('duplicateActivityRepo --- response>> $response');

    return duplicateActivityRepo;
  }

  /// DUPLICATE ACTIVITY REPO FOR COMMON?DEVELOPMENT::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> duplicateActivityForCommonRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.duplicateActivityForCommonAndDevelopment,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('duplicateActivityForCommonRepo --- response>> $response');

    SuccessDataResponseModel duplicateActivityForCommonRepo =
        SuccessDataResponseModel.fromJson(response);

    log('duplicateActivityForCommonRepo --- response>> $response');

    return duplicateActivityForCommonRepo;
  }

  /// DELETE ACTIVITY REPO ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> deleteActivityRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.deleteActivity,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('duplicateActivityRepo --- response>> $response');

    SuccessDataResponseModel duplicateActivityRepo =
        SuccessDataResponseModel.fromJson(response);

    log('duplicateActivityRepo --- response>> $response');

    return duplicateActivityRepo;
  }

  /// MATERIAL INSPECTION DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> updateMaterialRepo({Map<String, dynamic>? body}) async {
    log('body----------updateMaterialRepo- ${body}');

    var response = await APIService().getResponse(
      url: preferences.getString(SharedPreference.userType) == "checker"
          ? ApiRouts.updateChecker
          : preferences.getString(SharedPreference.userType) == "approver"
              ? ApiRouts.updateApprover
              : ApiRouts.updateMaker,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );
    log('successDataResponseModel --- response>> $response');
    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);
    log('successDataResponseModel --- response>> $response');
    return successDataResponseModel;
  }

  /// REJECT
  Future<dynamic> rejectMakerRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: preferences.getString(SharedPreference.userType) == "checker"
          ? ApiRouts.rejectChecker
          : ApiRouts.rejectApprover,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('successDataResponseModel --- response>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response>> $response');

    return successDataResponseModel;
  }

  /// UPLOAD DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> changePasswordRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.changePassword,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('successDataResponseModel --- response changePasswordRepo>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response changePasswordRepo>> $response');

    return successDataResponseModel;
  }

////////////////////////// Home Inpesction part/////////////////////////////////////////

  Future<dynamic> issueTypeRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.issueType,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('issueTypeResponseModel --- response>> $response');

    IssueTypeResponseModel issueTypeResponseModel =
        IssueTypeResponseModel.fromJson(response);

    log('issueTypeResponseModel --- response>> $response');

    return issueTypeResponseModel;
  }

  Future<dynamic> issueCategoryRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.issueCategory,
      apiType: APIType.aPost,
      body: {},
      header: header1,
    );

    log('issueCategoryResponseModel --- response>> $response');

    IssueCategoryResponseModel issueCategoryResponseModel =
        IssueCategoryResponseModel.fromJson(response);

    log('issueCategoryResponseModel --- response>> $response');

    return issueCategoryResponseModel;
  }



  Future impactTypeRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.categoryRating,
      apiType: APIType.aPost,
      body: {},
      header: header1,
    );

    log('impactTypeResponseModel --- response>> $response');

    // API response contains JSON-RPC "result"
    final result = response['result'];

    ImpactTypeResponseModel impactTypeResponseModel =
        ImpactTypeResponseModel.fromJson(result);

    log(
      'Impact Type Data >>> ${impactTypeResponseModel.data}',
    );

    return impactTypeResponseModel;
  }

  Future<dynamic> SubmitFlatForHQIRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.submitFlatForHQI,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('submitFlatForHQIResponseModel --- response>> $response');

    SubmitFlatForHQIResponseModel submitFlatForHQIResponseModel =
        SubmitFlatForHQIResponseModel.fromJson(response);

    log('submitFlatForHQIResponseModel --- response>> $response');

    return submitFlatForHQIResponseModel;
  }

  Future<dynamic> hqiFlatListRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.hqiFlatList,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('flatListForHQIResponseModel --- response>> $response');

    FlatListForHQIResponseModel flatListForHQIResponseModel =
        FlatListForHQIResponseModel.fromJson(response);

    log('flatListForHQIResponseModel --- response>> $response');

    return flatListForHQIResponseModel;
  }

  Future<dynamic> hqiSiteVisitRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.hqiSiteVisit,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('flatVisitsResponseModel --- response>> $response');

    FlatVisitsResponseModel flatVisitsResponseModel =
        FlatVisitsResponseModel.fromJson(response);

    log('flatVisitsResponseModel --- response>> $response');

    return flatVisitsResponseModel;
  }

  Future<dynamic> getHQITowersRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.hqiTowerdata,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('getHQITowersResponseModel --- response>> $response');

    GetHQITowersResponseModel getHQITowersResponseModel =
        GetHQITowersResponseModel.fromJson(response);

    log('getHQITowersResponseModel --- response>> $response');

    return getHQITowersResponseModel;
  }

  Future<dynamic> submitObservationFormRepo(
      {Map<String, dynamic>? body}) async {
    log('body:::::::::::::::submitObservationFormRepo:${body}');
    print('body::::::::::::::submitObservationFormRepo::${body}');
    debugPrint('body::::::::::::::submitObservationFormRepo::${body}');
    var response = await APIService().getResponse(
      url: ApiRouts.submitObservationForm,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('submitObservationFormResponseModel --- response>> $response');

    SubmitObservationResponseModel submitObservationFormResponseModel =
        SubmitObservationResponseModel.fromJson(response);

    log('submitObservationFormResponseModel --- response>> $response');

    return submitObservationFormResponseModel;
  }

  Future<dynamic> multiobservationsubmitRepo(
      {Map<String, dynamic>? body}) async {
    log('body:::::::::::::::multiobservationsubmitRepo:${body}');
    print('body::::::::::::::multiobservationsubmitRepo::${body}');
    debugPrint('body::::::::::::::multiobservationsubmitRepo::${body}');
    var response = await APIService().getResponse(
      url: ApiRouts.multiobservationsubmit,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('multipleObservationToMakerResponseModel --- response>> $response');

    MultipleObservationToMakerResponseModel
        multipleObservationToMakerResponseModel =
        MultipleObservationToMakerResponseModel.fromJson(response);

    log('multipleObservationToMakerResponseModel --- response>> $response');

    return multipleObservationToMakerResponseModel;
  }

  Future<dynamic> fetchObservationFormRepo({Map<String, dynamic>? body}) async {
    print('body:::::::::::::fetchObservationFormRepo:::${body}');
    log('header1::::::::::::::::${header1}');
    var response = await APIService().getResponse(
      url: ApiRouts.fetchObservationForm,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    print('fetchObservationFormResponseModel --- response>> $response');

    FetchObservationFromResponseModel fetchObservationFormResponseModel =
        FetchObservationFromResponseModel.fromJson(response);

    log('fetchObservationFormResponseModel --- response>> ${fetchObservationFormResponseModel.toJson()}');

    return fetchObservationFormResponseModel;
  }

  Future<dynamic> flatCompletedFormCheckerSide(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.flatCompletedForHQI,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('observationCompleteeckerFromChResponseModel --- response>> $response');

    ObservationCompleteeckerFromChResponseModel
        observationCompleteeckerFromChResponseModel =
        ObservationCompleteeckerFromChResponseModel.fromJson(response);

    log('observationCompleteeckerFromChResponseModel --- response>> $response');

    return observationCompleteeckerFromChResponseModel;
  }

  Future<dynamic> flatResubmittoCheckerRepo(
      {Map<String, dynamic>? body}) async {
    log('body::::::::::::flatResubmittoCheckerRepo::::${body}');
    var response = await APIService().getResponse(
      url: ApiRouts.flatResubmittoChecker,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    print('resubmitToCheckerResponseModel --- response>> $response');

    ResubmitToCheckerResponseModel resubmitToCheckerResponseModel =
        ResubmitToCheckerResponseModel.fromJson(response);

    log('resubmitToCheckerResponseModel --- response.json>> ${resubmitToCheckerResponseModel.toJson()}');

    return resubmitToCheckerResponseModel;
  }

  Future<dynamic> getAttachmentDetailRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getAttachmentDetail,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('fetchMakerObservationDetailsModel --- response>> $response');

    FetchMakerObservationDetailsModel fetchMakerObservationDetailsModel =
        FetchMakerObservationDetailsModel.fromJson(response);

    log('fetchMakerObservationDetailsModel --- response>> $response');

    return fetchMakerObservationDetailsModel;
  }

  Future<dynamic> downloadPdfForHQIRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.downloadPdfForHQI,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );
    log('downloadPdfResponseModel --- response>> $response');

    DownloadPdfResponseModel downloadPdfResponseModel =
        DownloadPdfResponseModel.fromJson(response);
    log('downloadPdfResponseModel --- response>> $response');
    return downloadPdfResponseModel;
  }

  Future<dynamic> observationHistoryRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.observationHistory,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );
    log('observationHistoryModel --- response>> $response');

    ObservationHistoryModel observationHistoryModel =
        ObservationHistoryModel.fromJson(response);
    log('observationHistoryModel --- response>> $response');
    return observationHistoryModel;
  }

  Future<dynamic> completeForHQIRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.completeForHQI,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );
    log('completeForHQIResponseModel --- response>> $response');

    CompleteForHQIResponseModel completeForHQIResponseModel =
        CompleteForHQIResponseModel.fromJson(response);
    log('completeForHQIResponseModel --- response>> $response');
    return completeForHQIResponseModel;
  }

  Future<dynamic> replicatelocationforhqiRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.replicatelocationforhqi,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('replicatelocationforhqiRepo --- response>> $response');

    SuccessDataResponseModel replicatelocationforhqiRepo =
        SuccessDataResponseModel.fromJson(response);

    log('replicatelocationforhqiRepo --- response>> $response');

    return replicatelocationforhqiRepo;
  }

  // Future<dynamic> getFlatLocationObservationOfflineRepo({Map<String, dynamic>? body}) async {
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.siteVisitSaveOfflineLocObs,
  //     apiType: APIType.aPost,
  //     body: body,
  //     header: header1,
  //   );
  //
  //   log('getHQIFlatsOfflineResponseModel --- response>> $response');
  //
  //   FlatLocationObservationOfflineResponseModel getHQIFlatsOfflineResponseModel =
  //       FlatLocationObservationOfflineResponseModel.fromJson(response);
  //
  //   log('getHQIFlatsOfflineResponseModel --- response>> $response');
  //
  //   return getHQIFlatsOfflineResponseModel;
  // }

  Future<dynamic> downloadPdfForHqiFlatRepo(
      {Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.downloadPdfForHqiFlat,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );
    log('downloadPdfResponseModel --- response>> $response');

    DownloadPdfResponseModel downloadPdfResponseModel =
        DownloadPdfResponseModel.fromJson(response);
    log('downloadPdfResponseModel --- response>> $response');
    return downloadPdfResponseModel;
  }

  /// GET OFFLINE HOME INSPECTION FLAT :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getHQIFlatsOfflineRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getHQIFlatOffline,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('OfflineHqiFlateResponseModel --- response>> $response');

    OfflineHqiFlateResponseModel offlineHqiFlateResponseModel =
        OfflineHqiFlateResponseModel.fromJson(response);

    log('OfflineHqiFlateResponseModel --- response>> $offlineHqiFlateResponseModel');

    return offlineHqiFlateResponseModel;
  }

  ////// generate nc by app
  /// get project

  Future<dynamic> ncgetprojectRepo(Map<String, dynamic>? map) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetProject,
      apiType: APIType.aPost,
      body: {},
      header: header1,
    );

    log('generateNcByAppResponseModel --- response>> $response');

    GenerateNcByAppResponseModel generateNcByAppResponseModel =
        GenerateNcByAppResponseModel.fromJson(response);

    log('generateNcByAppResponseModel --- response>> $generateNcByAppResponseModel');

    return generateNcByAppResponseModel;
  }

  ///nc close state

  Future<dynamic> closencstateRepo(int nc_id,
      {Map<String, dynamic>? map}) async {
    if (map == null || map.isEmpty) {
      log('Missing map parameter in API call.');
      return null;
    }

    var response = await APIService().getResponse(
      url: ApiRouts.ncclosestate,
      apiType: APIType.aPost,
      body: map,
      header: header1,
    );

    log('generateNcCloseStateResponseModel --- response>> $response');

    if (response is List && response.isNotEmpty) {
      var status = response[0]['status'];
      var message = response[0]['message'];

      if (status == 'error') {
        log('Error: $message');
        return null;
      }

      GenerateNcCloseStateResponseModel generateNcCloseStateResponseModel =
          GenerateNcCloseStateResponseModel.fromJson(response[0]);

      log('generateNcCloseStateResponseModel --- response>> $generateNcCloseStateResponseModel');
      return generateNcCloseStateResponseModel;
    } else {
      log('Unexpected response format: $response');
      return null;
    }
  }

  ///get tower
  Future<dynamic> ncgettowerRepo(int project_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetTower,
      apiType: APIType.aPost,
      body: {'project_id': project_id},
      header: header1,
    );

    log('generateNcByAppTowerResponseModel --- response>> $response');

    GenerateNcByAppTowerResponseModel generateNcByAppTowerResponseModel =
        GenerateNcByAppTowerResponseModel.fromJson(response);

    log('generateNcByAppTowerResponseModel --- response>> $response');

    return generateNcByAppTowerResponseModel;
  }

  ///get floor
  Future<dynamic> ncgetfloorRepo(int tower_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetFloor,
      apiType: APIType.aPost,
      body: {'tower_id': tower_id},
      header: header1,
    );

    log('generateNcByAppFloorResponseModel --- response>> $response');

    GenerateNcByAppFloorResponseModel generateNcByAppFloorResponseModel =
        GenerateNcByAppFloorResponseModel.fromJson(response);

    log('generateNcByAppFloorResponseModel --- response>> $response');

    return generateNcByAppFloorResponseModel;
  }

  ///// get flat
  Future<dynamic> ncgetflatRepo(int tower_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetFlat,
      apiType: APIType.aPost,
      body: {'tower_id': tower_id},
      header: header1,
    );

    log('generateNcByAppFlatResponseModel --- response>> $response');

    GenerateNcByAppFlatResponseModel generateNcByAppFlatResponseModel =
        GenerateNcByAppFlatResponseModel.fromJson(response);

    log('generateNcByAppFlatResponseModel --- response>> $response');

    return generateNcByAppFlatResponseModel;
  }

  ////get activity

  Future<dynamic> ncgetactivityRepo(
      int flat_id, int floor_id, int tower_id, int project_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetActivity,
      apiType: APIType.aPost,
      body: {
        "flat_id": flat_id,
        "floor_id": floor_id,
        "tower_id": tower_id,
        "project_id": project_id,
      },
      header: header1,
    );

    log('generateNcByAppActivityResponseModel --- response>> $response');

    GenerateNcByAppActivityResponseModel generateNcByAppActivityResponseModel =
        GenerateNcByAppActivityResponseModel.fromJson(response);

    log('generateNcByAppActivityResponseModel --- response>> $response');

    return generateNcByAppActivityResponseModel;
  }

//////get activity type checklist
  Future<dynamic> ncgetactivitytypechecklistRepo(int patn_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetActivityTypeChecklist,
      apiType: APIType.aPost,
      body: {'patn_id': patn_id},
      header: header1,
    );

    log('generateNcByAppActivityTypeChecklistResponseModel --- response>> $response');

    GenerateNcByAppActivityTypeChecklistResponseModel
        generateNcByAppActivityTypeChecklistResponseModel =
        GenerateNcByAppActivityTypeChecklistResponseModel.fromJson(response);

    log('generateNcByAppActivityTypeChecklistResponseModel --- response>> $response');

    return generateNcByAppActivityTypeChecklistResponseModel;
  }

  //////get activity type

  Future<dynamic> ncgetactivitytypeRepo(int activity_id,
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncGetActivityType,
      apiType: APIType.aPost,
      body: {'activity_id': activity_id},
      header: header1,
    );

    log('generateNcByAppActivityTypeResponseModel --- response>> $response');

    GenerateNcByAppActivityTypeResponseModel
        generateNcByAppActivityTypeResponseModel =
        GenerateNcByAppActivityTypeResponseModel.fromJson(response);

    log('generateNcByAppActivityTypeResponseModel --- response>> $response');

    return generateNcByAppActivityTypeResponseModel;
  }

  ///// project responsible user name
  Future<dynamic> ncgetprojectresponsibleRepo(
      Map<String, dynamic>? body) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncprojectresponsiblelist,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    log('generateNcProjectResponsibleTypeResponseModel --- response>> $response');

    GenerateNcProjectResponsibleTypeResponseModel
        generateNcProjectResponsibleTypeResponseModel =
        GenerateNcProjectResponsibleTypeResponseModel.fromJson(response);

    log('generateNcProjectResponsibleTypeResponseModel --- response>> $response');

    return generateNcProjectResponsibleTypeResponseModel;
  }
  // /////fetch all nc data

  // Future ncfetchalldataRepo({Map<String, dynamic>? body}) async {
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.ncfetchalldata,
  //     apiType: APIType.aPost,
  //     body: {},
  //     header: header1,
  //   );

  //   log('FetchAllNcDataResponseModel --- raw response>> $response');

  //   if (response is List && response.isNotEmpty) {
  //     var firstElement = response[0];

  //     if (firstElement is Map<String, dynamic>) {
  //       if (firstElement.containsKey('status') &&
  //           firstElement['status'] == 'error') {
  //         throw Exception('API Error: ${firstElement['message']}');
  //       }

  //       FetchAllNcDataResponseModel fetchAllNcDataResponseModel =
  //           FetchAllNcDataResponseModel.fromJson(firstElement);

  //       log('fetchAllNcDataResponseModel --- response>> $fetchAllNcDataResponseModel');

  //       return fetchAllNcDataResponseModel;
  //     } else {
  //       throw Exception(
  //           'Expected a Map but received a List element that is not a Map');
  //     }
  //   } else if (response is String) {
  //     throw Exception('Expected a Map but received a String: $response');
  //   } else {
  //     throw Exception('Invalid response format');
  //   }
  // }
  //26/11 11:47pm
  Future ncfetchalldataRepo({bool forceRefresh = false}) async {
    var response = await APIService().getResponse(
      url: forceRefresh
          ? "${ApiRouts.ncfetchalldata}?nocache=${DateTime.now().millisecondsSinceEpoch}"
          : ApiRouts.ncfetchalldata,
      apiType: APIType.aPost,
      body: {},
      header: header1,
    );

    log('FetchAllNcDataResponseModel --- raw response>> $response');

    if (response is List && response.isNotEmpty) {
      var firstElement = response[0];

      if (firstElement is Map<String, dynamic>) {
        if (firstElement.containsKey('status') &&
            firstElement['status'] == 'error') {
          throw Exception('API Error: ${firstElement['message']}');
        }

        FetchAllNcDataResponseModel model =
            FetchAllNcDataResponseModel.fromJson(firstElement);

        log('fetchAllNcDataResponseModel --- response>> $model');
        return model;
      } else {
        throw Exception(
            'Expected a Map but received a List element that is not a Map');
      }
    } else {
      throw Exception('Invalid response format');
    }
  }

  /////submit nc
  // Future<dynamic> ncsubmitbuttonRepo({Map<String, dynamic>? body}) async {
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.ncsubmitbutton,
  //     apiType: APIType.aPost,
  //     body: body ?? {},
  //     header: header1,
  //   );

  //   log('submitNcDataResponseModel --- raw response>> $response');

  //   if (response is List<dynamic> && response.isNotEmpty) {
  //     var firstElement = response[0];
  //     if (firstElement is Map<String, dynamic>) {
  //       return SubmitNcDataResponseModel.fromJson(firstElement);
  //     } else {
  //       throw Exception("Invalid response format.");
  //     }
  //   } else {
  //     throw Exception("Empty or invalid response.");
  //   }
  // }
  //   Future<dynamic> ncsubmitbuttonRepo({Map<String, dynamic>? body}) async {
  //   try {
  //     var response = await APIService().getResponse(
  //       url: ApiRouts.ncsubmitbutton,
  //       apiType: APIType.aPost,
  //       body: body ?? {},
  //       header: header1,
  //     );

  //     log('submitNcDataResponseModel --- raw response>> $response');

  //     if (response == null) {
  //       throw Exception("Empty response from server.");
  //     }

  //     // ✅ Handle Map-based JSON
  //     if (response is Map<String, dynamic>) {
  //       return response;
  //     }

  //     // ✅ Handle List-based JSON (optional edge case)
  //     if (response is List &&
  //         response.isNotEmpty &&
  //         response.first is Map<String, dynamic>) {
  //       return response.first;
  //     }

  //     // ✅ Handle String-based responses (plain text)
  //     if (response is String) {
  //       try {
  //         return jsonDecode(response);
  //       } catch (e) {
  //         // If plain text message
  //         return {"status": "success", "message": response};
  //       }
  //     }

  //     throw Exception("Invalid response format.");

  //     // } catch (e) {
  //     //   log("Error in ncsubmitbuttonRepo: $e");
  //     //   throw Exception("Form submission failed: $e");
  //     // }
  //   } catch (e) {
  //     log("Error in ncsubmitbuttonRepo: $e");

  //     // ✅ Ignore harmless "connection closed" errors if the server still processes successfully
  //     if (e.toString().contains("Connection closed while receiving data")) {
  //       log("⚠️ Connection closed early, but likely success — ignoring...");
  //       return {"status": "success", "message": "NC submitted successfully"};
  //     }

  //     // ✅ For any other real errors, throw normally
  //     throw Exception("Form submission failed: $e");
  //   }
  // }

  Future<dynamic> ncsubmitbuttonRepo({Map<String, dynamic>? body}) async {
    try {
      var response = await APIService().getResponse(
        url: ApiRouts.ncsubmitbutton,
        apiType: APIType.aPost,
        body: body ?? {},
        header: header1,
      );

      log('submitNcDataResponseModel --- raw response>> $response');

      if (response == null) {
        throw Exception("Empty response from server.");
      }

      // ✅ Handle Map-based JSON
      if (response is Map<String, dynamic>) {
        return response;
      }

      // ✅ Handle List-based JSON (optional edge case)
      if (response is List &&
          response.isNotEmpty &&
          response.first is Map<String, dynamic>) {
        return response.first;
      }

      // ✅ Handle String-based responses (plain text)
      if (response is String) {
        try {
          return jsonDecode(response);
        } catch (e) {
          // If plain text message
          return {"status": "success", "message": response};
        }
      }

      throw Exception("Invalid response format.");

      // } catch (e) {
      //   log("Error in ncsubmitbuttonRepo: $e");
      //   throw Exception("Form submission failed: $e");
      // }
    } catch (e) {
      log("Error in ncsubmitbuttonRepo: $e");

      // ✅ Ignore harmless "connection closed" errors if the server still processes successfully
      if (e.toString().contains("Connection closed while receiving data")) {
        log("⚠️ Connection closed early, but likely success — ignoring...");
        return {"status": "success", "message": "NC submitted successfully"};
      }

      // ✅ For any other real errors, throw normally
      throw Exception("Form submission failed: $e");
    }
  }

  Future<dynamic> approverRejectNcRepo(
      {required Map<String, dynamic> map}) async {
    try {
      var response = await APIService().getResponse(
        url: ApiRouts.approverRejectNc,
        apiType: APIType.aPost,
        body: map,
        header: header1,
      );
      return SuccessDataResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Error rejecting NC: $e');
    }
  }

  Future<dynamic> approverCloseNcRepo(
      {required Map<String, dynamic> map}) async {
    try {
      var response = await APIService().getResponse(
        url: ApiRouts.approverCloseNc,
        apiType: APIType.aPost,
        body: map,
        header: header1,
      );
      return SuccessDataResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Error closing NC: $e');
    }
  }

  //06/12
  Future<dynamic> getNotificationRoutingForNc(
      {Map<String, dynamic>? map}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.ncRoutingThroughNotification,
      apiType: APIType.aPost,
      body: map ?? {},
      header: header1,
    );

    print("RAW TYPE: ${response.runtimeType}");
    print("RAW DATA: $response");

    /// FIX: If API response is a LIST → extract first element
    if (response is List) {
      if (response.isNotEmpty && response.first is Map) {
        response = response.first; // unwrap actual json
      } else {
        throw Exception("Invalid NC Routing response format");
      }
    }

    NcRoutingThroughNotificationResponseModel model =
        NcRoutingThroughNotificationResponseModel.fromJson(response);

    print("Parsed Model: ${model.toJson()}");
    return model;
  }
}
