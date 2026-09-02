// ignore_for_file: non_constant_identifier_names, unnecessary_cast

import 'dart:developer';

import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_by_app_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_flat_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_project_responsible_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_tower_res_model.dart';
import 'package:get/get.dart';


class GenerateNcController extends GetxController {
  int? project_id;
  int? tower_id;
  int? patn_id;
  int? activity_id;
  int? id;
  int? flat_id;
  int? floor_id;
  int? projectresId;
  String? description;
  String? flag_category;
  String? status;

  GenerateNcByAppResponseModel? generateNcRes;
  GenerateNcByAppTowerResponseModel? generateNcTowerRes;
  GenerateNcByAppFloorResponseModel? generateNcFloorRes;
  GenerateNcByAppFlatResponseModel? generateNcFlatRes;
  GenerateNcByAppActivityResponseModel? generateNcactivitiyRes;
  GenerateNcByAppActivityTypeResponseModel? generateNcactivitiytypeRes;
  GenerateNcByAppActivityTypeChecklistResponseModel?
      generateNcactivitiytypechecklistRes;
  GenerateNcProjectResponsibleTypeResponseModel? projectResponsibleRes;
  FetchAllNcDataResponseModel? fetchdataRes;

  List<NcGenerate> ncgenerate = [];
  List<NcGenerateTower> ncgeneratetower = [];
  List<NcGenerateFloor> ncgeneratefloor = [];
  List<NcGenerateFlat> ncgenerateflat = [];
  List<NcGenerateActivity> ncgenerateactivity = [];
  List<NcGenerateActivityType> ncgenerateactivitytype = [];
  List<NcGenerateActivityTypeChecklist> ncgenerateactivitytypechecklist = [];
  List<NcGenerateProjectResponsible> ncGenerateProjectResponsible = [];
  List<FetchNcData> fetchNcData = [];

  @override
  void onInit() {
    super.onInit();
    getprojectlist();
    gettowerlist();
    getfloorlist();
    getflatlist();
    getActivitylist();
    getprojectresponsiblelist();
  }

  ApiResponse _generateNcProjectResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcProjectResponse => _generateNcProjectResponse;

  Future<void> getprojectlist() async {
    _generateNcProjectResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      generateNcRes = await ProjectRepo().ncgetprojectRepo({});

      if (generateNcRes != null && generateNcRes!.ncgenerate.isNotEmpty) {
        ncgenerate = generateNcRes!.ncgenerate;
        _generateNcProjectResponse = ApiResponse.complete(generateNcRes);
      } else {
        _generateNcProjectResponse =
            ApiResponse.error(message: 'No projects found');
      }
    } catch (e) {
      _generateNcProjectResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  /////for tower list
  ApiResponse _generateNcTowerResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcTowerResponse => _generateNcTowerResponse;

  Future<void> gettowerlist() async {
    _generateNcTowerResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      final response = await ProjectRepo().ncgettowerRepo(project_id!);

      if (response != null && response.ncgeneratetower.isNotEmpty) {
        ncgeneratetower = response.ncgeneratetower;
        _generateNcTowerResponse = ApiResponse.complete(response);
      } else {
        _generateNcTowerResponse =
            ApiResponse.error(message: 'No towers found');
      }
    } catch (e) {
      _generateNcTowerResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }

/////get floor list
  ApiResponse _generateNcFloorResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcFloorResponse => _generateNcFloorResponse;

  Future<void> getfloorlist() async {
    _generateNcFloorResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      final response = await ProjectRepo().ncgetfloorRepo(tower_id!);

      if (response != null && response.ncgeneratefloor.isNotEmpty) {
        ncgeneratefloor = response.ncgeneratefloor;
        _generateNcFloorResponse = ApiResponse.complete(response);
      } else {
        _generateNcFloorResponse =
            ApiResponse.error(message: 'No Floors found');
      }
    } catch (e) {
      _generateNcFloorResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }

////get flat list
  ApiResponse _generateNcFlatResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNCFlatResponse => _generateNcFlatResponse;

  Future<void> getflatlist() async {
    _generateNcFlatResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      final response = await ProjectRepo().ncgetflatRepo(tower_id!);

      if (response != null && response.ncgenerateflat.isNotEmpty) {
        ncgenerateflat = response.ncgenerateflat;
        _generateNcFlatResponse = ApiResponse.complete(response);
      } else {
        _generateNcFlatResponse = ApiResponse.error(message: 'No Flats found');
      }
    } catch (e) {
      _generateNcFlatResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }

////get activity

  ApiResponse _generateNcActivityResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcActivityResponse => _generateNcActivityResponse;

  Future<void> getActivitylist() async {
    log('Calling getActivitylist with flat_id: $flat_id, floor_id: $floor_id ,tower_id:$tower_id, project_id:$project_id');

    if (tower_id == null) {
      log('Tower ID is not selected. Setting tower_id to null.');
    }
    if (flat_id == null) {
      log('Flat ID is not selected. Setting flat_id to null.');
    }
    if (floor_id == null) {
      log('Floor ID is not selected. Setting floor_id to null.');
    }
    if (project_id == null) {
      log('Project ID is not selected. Setting project_id to null.');
    }

    _generateNcActivityResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      generateNcactivitiyRes = await ProjectRepo().ncgetactivityRepo(
          tower_id ?? 0, flat_id ?? 0, floor_id ?? 0, project_id ?? 0);

      if (generateNcactivitiyRes != null &&
          generateNcactivitiyRes!.ncgenerateactivity.isNotEmpty) {
        ncgenerateactivity = generateNcactivitiyRes!.ncgenerateactivity;
        _generateNcActivityResponse =
            ApiResponse.complete(generateNcactivitiyRes);
      } else {
        _generateNcActivityResponse =
            ApiResponse.error(message: 'No activity found');
      }
    } catch (e) {
      _generateNcActivityResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  // Future<void> getActivitylist() async {
  //   _generateNcActivityResponse = ApiResponse.loading(message: 'Loading');
  //   update();

  //   try {
  //     generateNcactivitiyRes = await ProjectRepo().ncgetactivityRepo(tower_id!, flat_id!, floor_id!, project_id!);

  //     if (generateNcactivitiyRes != null &&
  //         generateNcactivitiyRes!.ncgenerateactivity.isNotEmpty) {
  //       ncgenerateactivity = generateNcactivitiyRes!.ncgenerateactivity;
  //       _generateNcActivityResponse = ApiResponse.complete(generateNcRes);
  //     } else {
  //       _generateNcActivityResponse =
  //           ApiResponse.error(message: 'No projects found');
  //     }
  //   } catch (e) {
  //     _generateNcActivityResponse = ApiResponse.error(message: e.toString());
  //   }

  //   update();
  // }

  ///get activity type
  ApiResponse _generateNcActivityTypeResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcActivityTypeResponse =>
      _generateNcActivityTypeResponse;
  Future<void> getActivityTypelist() async {
    _generateNcActivityTypeResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      final response = await ProjectRepo().ncgetactivitytypeRepo(activity_id!);

      if (response != null && response.ncgenerateactivitytype.isNotEmpty) {
        ncgenerateactivitytype = response.ncgenerateactivitytype;
        _generateNcActivityTypeResponse = ApiResponse.complete(response);
      } else {
        _generateNcActivityTypeResponse =
            ApiResponse.error(message: 'No activite type found');
      }
    } catch (e) {
      _generateNcActivityTypeResponse =
          ApiResponse.error(message: e.toString());
    }

    update();
  }

//// get activity type checklist

  ApiResponse _generateNcActivityTypeChecklistResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcActivityTypeChecklistResponse =>
      _generateNcActivityTypeChecklistResponse;
  Future<void> getActivityTypeCheklistlist() async {
    _generateNcActivityTypeChecklistResponse =
        ApiResponse.loading(message: 'Loading');
    update();

    try {
      final response =
          await ProjectRepo().ncgetactivitytypechecklistRepo(patn_id!);

      if (response != null &&
          response.ncgenerateactivitytypechecklist.isNotEmpty) {
        ncgenerateactivitytypechecklist =
            response.ncgenerateactivitytypechecklist;
        _generateNcActivityTypeChecklistResponse =
            ApiResponse.complete(response);
      } else {
        _generateNcActivityTypeChecklistResponse =
            ApiResponse.error(message: 'No checklist found');
      }
    } catch (e) {
      _generateNcActivityTypeChecklistResponse =
          ApiResponse.error(message: e.toString());
    }

    update();
  }

///////////project responsible user list
  ApiResponse _generateNcProjectResponsibleListResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcProjectResponsibleListResponse =>
      _generateNcProjectResponsibleListResponse;
  Future<void> getprojectresponsiblelist() async {
    _generateNcProjectResponsibleListResponse =
        ApiResponse.loading(message: 'Loading');
    update();
    try {
      projectResponsibleRes =
          await ProjectRepo().ncgetprojectresponsibleRepo({});

      if (projectResponsibleRes != null &&
          projectResponsibleRes!.ncGenerateProjectResponsible.isNotEmpty) {
        ncGenerateProjectResponsible =
            projectResponsibleRes!.ncGenerateProjectResponsible;
        _generateNcProjectResponsibleListResponse =
            ApiResponse.complete(projectResponsibleRes);
      } else {
        _generateNcProjectResponsibleListResponse =
            ApiResponse.error(message: 'No users found');
      }
    } catch (e) {
      _generateNcProjectResponsibleListResponse =
          ApiResponse.error(message: e.toString());
    }
    update();
  }

////// fetch all nc data
  ApiResponse _generateNcFetchResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get generateNcFetchResponse => _generateNcFetchResponse;

  Future<void> fetchAllNcData() async {
    _generateNcFetchResponse =
        ApiResponse.loading(message: 'Fetching NC data...');
    update();
    try {
      var response = await ProjectRepo().ncfetchalldataRepo();
      if (response is FetchAllNcDataResponseModel &&
          response.status == 'success') {
        // _generateNcFetchResponse = ApiResponse.complete(response.fetchNcData);
        //13/12[All closed nc are deleted]
        final List<FetchNcData> filteredNcList =
            (response.fetchNcData ?? []).where((FetchNcData nc) {
          final status = (nc.status ?? "").toLowerCase();
          return status != "close" && status != "done";
        }).toList();

        _generateNcFetchResponse = ApiResponse.complete(filteredNcList);

//========================>
      } else {
        _generateNcFetchResponse =
            ApiResponse.error(message: 'Failed to fetch NC data');
      }
    } catch (e) {
      _generateNcFetchResponse =
          ApiResponse.error(message: "Failed to fetch NC data");
    } finally {}
  }
}

//NC 01/12
// generate_nc_controller.dart (top)
class NCStatus {
  static const String open = "open"; // checker generated
  static const String submit = "submit"; // maker submitted to approver
  static const String approverReject = "approver_reject"; // approver rejected
  static const String finallyClose = "finally_close"; // if used
}
