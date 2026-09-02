import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/development_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';

class TowerController extends GetxController {
  String towerId = Get.arguments['towerId'];

  var name = Get.arguments['name'];

  GetFlatFloorDataResponseModel? flatFloorRes;
  CommonActivityResponseModel? commonActivityResponse;
  final searchController = TextEditingController();
  bool loading = false;
  bool get isDevelopmentTower {
    return flatFloorRes?.towerData?.towerName?.toUpperCase() == 'DEVELOPMENT';
  }


  DevelopmentResponseModel? developmentActivityResponse;

  List<ListFloor> listFloorData = [];
  List<ListFloor> listFlatData = [];
  List<ActivityItem> activityCommonData = [];
  List<DevelopmentActivityItem> developmentActivityCommonData = [];

  List<ListFloor> searchListFloorData = [];
  List<ListFloor> searchListFlatData = [];
  List<ActivityItem> searchActivityCommonData = [];
  List<DevelopmentActivityItem> searchDevelopmentActivityCommonData = [];

  int flatLength = 0;
  int floorLength = 0;
  int commonLength = 0;
  int developmentLength = 0;

  bool load = false;
  int select = 0;

  setFloorLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (floorLength > searchListFloorData.length) {
      floorLength = searchListFloorData.length;
    } else if (floorLength + 20 > searchListFloorData.length) {
      floorLength = searchListFloorData.length;
    } else {
      floorLength += 20;
    }
    load = false;
    update();
  }

  setFlatLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }
    if (flatLength > searchListFlatData.length) {
      flatLength = searchListFlatData.length;
    } else if (flatLength + 20 > searchListFlatData.length) {
      flatLength = searchListFlatData.length;
    } else {
      flatLength += 20;
    }
    load = false;
    update();
  }

  setCommonLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (commonLength > searchActivityCommonData.length) {
      commonLength = searchActivityCommonData.length;
    } else if (commonLength + 20 > searchActivityCommonData.length) {
      commonLength = searchActivityCommonData.length;
    } else {
      commonLength += 20;
    }
    load = false;
    update();
  }

  setDevelopmentLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (developmentLength > searchDevelopmentActivityCommonData.length) {
      developmentLength = searchDevelopmentActivityCommonData.length;
    } else if (developmentLength + 20 > searchDevelopmentActivityCommonData.length) {
      developmentLength = searchDevelopmentActivityCommonData.length;
    } else {
      developmentLength += 20;
    }
    load = false;
    update();
  }

setLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }
    if (select == 0) {
      flatLength = _calculateLength(flatLength, searchListFlatData.length);
    } else if (select == 1) {
      floorLength = _calculateLength(floorLength, searchListFloorData.length);
    } else if (select == 2) {
      commonLength = _calculateLength(commonLength, searchActivityCommonData.length);
    } else if (select == 3) { 
      developmentLength = _calculateLength(developmentLength, searchDevelopmentActivityCommonData.length);
    }

    load = false;
    update();
  }

  int _calculateLength(int currentLength, int totalLength) {
    if (currentLength > totalLength) {
      return totalLength;
    } else if (currentLength + 20 > totalLength) {
      return totalLength;
    } else {
      return currentLength + 20;
    }
  }
  

  searchData() {
    if (isDevelopmentTower) {
      _filterDevelopmentData(
        searchController.text,
        developmentActivityCommonData,
        searchDevelopmentActivityCommonData,
      );
    } else {
      if (select == 0) {
        _filterData(searchController.text, listFlatData, searchListFlatData);
      } else if (select == 1) {
        _filterData(searchController.text, listFloorData, searchListFloorData);
      } else if (select == 2) {
        _filterCommonData(searchController.text, activityCommonData,
            searchActivityCommonData);
      }
    }
    setLength(true);
    update();
  }

  void _filterData(
      String query, List<ListFloor> sourceList, List<ListFloor> targetList) {
    targetList.clear();
    if (query.isNotEmpty) {
      targetList.addAll(sourceList.where((element) =>
          element.name.toString().toLowerCase().contains(query.toLowerCase())));
    } else {
      targetList.addAll(sourceList);
    }
  }

  void _filterCommonData(String query, List<ActivityItem> sourceList,
      List<ActivityItem> targetList) {
    print("Query: $query");
    print("Source List: ${sourceList.map((e) => e.name).toList()}");

    targetList.clear();
    if (query.isNotEmpty) {
      targetList.addAll(sourceList.where((element) =>
          element.name != null &&
          element.name.toString().toLowerCase().contains(query.toLowerCase())));
    } else {
      targetList.addAll(sourceList);
    }
    print("Filtered List: ${targetList.map((e) => e.name).toList()}");
  }

  void _filterDevelopmentData(
      String query,
      List<DevelopmentActivityItem> sourceList,
      List<DevelopmentActivityItem> targetList) {
    print("Query: $query");
    print("Source List: ${sourceList.map((e) => e.name).toList()}");
    targetList.clear();
    if (query.isNotEmpty) {
      targetList.addAll(sourceList.where((element) =>
          element.name != null &&
          element.name.toString().toLowerCase().contains(query.toLowerCase())));
    } else {
      targetList.addAll(sourceList);
    }
    print("Filtered List: ${targetList.map((e) => e.name).toList()}");
  }

  @override
  void onInit() {
    super.onInit();
    if (!isDevelopmentTower) {
      getFlatFloorController();
      fetchCommonActivityChecklist();
    }
    fetchDevelopmentActivityChecklist();
  }

  @override
  void dispose() {
    select = 0;
    super.dispose();
  }

  void selectCommonTab(int index) {
    select = index;
    searchController.clear();
    //fetchCommonActivityChecklist();
    searchData();
    update();
  }

  void selectDevelopmentTab(int index) {
    select = index;
    searchController.clear();
    searchData();
    update();
  }

  selectFlatFloor(int index) {
    select = index;
    searchController.clear();
    searchData();
    update();
  }

  /// API
  ApiResponse _getFlatFlorApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getFlatFlorApiResponse => _getFlatFlorApiResponse;

  /// **Fetch Floor and Flat Data**
  Future<void> getFlatFloorController() async {
    if (isDevelopmentTower) return;
    _getFlatFlorApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      flatFloorRes =
          await ProjectRepo().getFlatFloorRepo(body: {"tower_id": towerId});
      listFloorData = flatFloorRes?.towerData?.listFloorData ?? [];
      listFlatData = flatFloorRes?.towerData?.listFlatData ?? [];
      searchListFloorData = List.from(listFloorData);
      searchListFlatData = List.from(listFlatData);
      setLength(true);
      _getFlatFlorApiResponse = ApiResponse.complete(flatFloorRes);
      update();
    } catch (e) {
      _getFlatFlorApiResponse = ApiResponse.error(message: e.toString());
      update();
    }
  }

  /// **Fetch Common Checklist**
  // ApiResponse _getCommonActivityChecklistApiResponse =
  //     ApiResponse.initial(message: 'Initialization');
  // ApiResponse get getCommonActivityChecklistApiResponse =>
  //     _getCommonActivityChecklistApiResponse;

  // Future<void> fetchCommonActivityChecklist() async {
  //   _getCommonActivityChecklistApiResponse =
  //       ApiResponse.loading(message: 'Loading');
  //   update();

  //   log("Fetching checklist data for tower_id: $towerId");

  //   try {
  //     final requestBody = {
  //       "tower_id": int.tryParse(towerId) ?? towerId,
  //     };
  //     commonActivityResponse =
  //         await ProjectRepo().getCommonActivityDataRepo(body: requestBody);

  //     if (commonActivityResponse != null &&
  //         commonActivityResponse!.status == "SUCCESS") {
  //       activityCommonData =
  //           commonActivityResponse?.activityData?.activityCommonData ?? [];
  //       searchActivityCommonData = List.from(activityCommonData);
  //       activityCommonData.sort(
  //         (a, b) => "${a.name}".compareTo("${b.name}"),
  //       );

  //       setLength(true);
  //       _getCommonActivityChecklistApiResponse =
  //           ApiResponse.complete(commonActivityResponse);
  //       log("Checklist Data Loaded Successfully: ${activityCommonData.length} items");
  //     } else {
  //       log("Activity not found: ${commonActivityResponse?.message}");
  //       _getCommonActivityChecklistApiResponse = ApiResponse.error(
  //           message:
  //               commonActivityResponse?.message ?? "Activity not available");
  //     }

  //     update();
  //   } catch (e) {
  //     log("fetchCommonChecklist error: $e");
  //     _getCommonActivityChecklistApiResponse =
  //         ApiResponse.error(message: e.toString());
  //     update();
  //   }
  // }

  ApiResponse _getCommonActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getCommonActivityChecklistApiResponse =>
      _getCommonActivityChecklistApiResponse;

  Future<void> fetchCommonActivityChecklist() async {
    loading = true;
    update();

    try {
      final requestBody = {
        "tower_id": int.tryParse(towerId) ?? towerId,
      };
      commonActivityResponse =
          await ProjectRepo().getCommonActivityDataRepo(body: requestBody);

      if (commonActivityResponse != null &&
          commonActivityResponse!.status == "SUCCESS") {
        activityCommonData =
            commonActivityResponse?.activityData?.activityCommonData ?? [];
        activityCommonData.sort(
          (a, b) => "${a.name}".compareTo("${b.name}"),
        );
    searchActivityCommonData = List.from(activityCommonData);
        setLength(true);
        update();
      } else {
        log("Activity not found: ${commonActivityResponse?.message}");
      }
      update();
    } catch (e) {
      log("fetchCommonChecklist error: $e");
    } 
      update();
    
  }

  //////// fetch development activity
  ApiResponse _getDevelopmentActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getDevelopmentActivityChecklistApiResponse =>
      _getDevelopmentActivityChecklistApiResponse;
  Future<void> fetchDevelopmentActivityChecklist() async {
    loading = true;
    update();
    try {
      final requestBody = {
        "tower_id": int.tryParse(towerId) ?? towerId,
      };
      developmentActivityResponse =
          await ProjectRepo().getDevelopmentActivityDataRepo(body: requestBody);
      if (developmentActivityResponse != null &&
          developmentActivityResponse!.status == "SUCCESS") {
        developmentActivityCommonData = developmentActivityResponse
                ?.developmentactivityData?.developmentActivityCommonData ??
            [];
        developmentActivityCommonData.sort(
          (a, b) => "${a.name}".compareTo("${b.name}"),
        );
        searchDevelopmentActivityCommonData =
            List.from(developmentActivityCommonData);

        setLength(true);


        update();
      } else {
        log("Development activity not found: ${developmentActivityResponse?.message}");
      }
    } catch (e) {
      log("fetchDevelopmentActivityChecklist error: $e");
    } finally {
      loading = false;
      update();
    }
  }

  ApiResponse _getReplicateActivityForCommonApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getReplicateActivityForCommonApiResponse =>
      _getReplicateActivityForCommonApiResponse;

  // Future<dynamic> getReplicateActivityForCommonAndDevelopmentController(
  //     {Map<String, dynamic>? body}) async {
  //   _getReplicateActivityForCommonApiResponse =
  //       ApiResponse.loading(message: 'Loading');

  //   update();
  //   try {
  //     SuccessDataResponseModel successDataResponseModel =
  //         await ProjectRepo().duplicateActivityForCommonRepo(body: body);
  //     _getReplicateActivityForCommonApiResponse =
  //         ApiResponse.complete(successDataResponseModel);

  //     log("successDataResponseModel==>$successDataResponseModel");
  //   } catch (e) {
  //     _getReplicateActivityForCommonApiResponse =
  //         ApiResponse.error(message: e.toString());
  //     log("successDataResponseModel=ERROR=>$e");
  //   }
  //   update();
  // }

  Future<void> getReplicateActivityForCommonAndDevelopmentController({
    required String activityId,
    required String type,
  }) async {
    _getReplicateActivityForCommonApiResponse =
        ApiResponse.loading(message: 'Loading');
    update();

    try {
      Map<String, dynamic> body = {
        "activity_id": activityId,
        "type": type,
      };

      SuccessDataResponseModel successDataResponseModel =
          await ProjectRepo().duplicateActivityForCommonRepo(body: body);

      _getReplicateActivityForCommonApiResponse =
          ApiResponse.complete(successDataResponseModel);

      log("Replicate Success => $successDataResponseModel");
    } catch (e) {
      _getReplicateActivityForCommonApiResponse =
          ApiResponse.error(message: e.toString());
      log("Replicate ERROR => $e");
    }
    update();
  }

  ApiResponse _deleteActivityApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteActivityApiResponse => _deleteActivityApiResponse;

  Future<dynamic> deleteActivityForCandDController(
      {Map<String, dynamic>? body}) async {
    _deleteActivityApiResponse = ApiResponse.loading(message: 'Loading');

    update();
    try {
      SuccessDataResponseModel successDataResponseModel =
          await ProjectRepo().deleteActivityRepo(body: body);
      _deleteActivityApiResponse =
          ApiResponse.complete(successDataResponseModel);

      log("_deleteActivityApiResponse==>$successDataResponseModel");
    } catch (e) {
      _deleteActivityApiResponse = ApiResponse.error(message: e.toString());
      log("_deleteActivityApiResponse=ERROR=>$e");
    }
    update();
  }

  Future<void> saveForOfflineUse(
      BuildContext context, double h, double w, int length) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
            child: "Save Activity".semiBoldBarlowTextStyle(
                fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This activity data saved successfully for the offline use. You can store maximum 10 activity data for offline use."
                    .regularRobotoTextStyle(
                        fontSize: 15, textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                "Total saved activities : $length/10".regularRobotoTextStyle(
                    fontSize: 15, textAlign: TextAlign.center),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: appColor,
                height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: "Okay".boldRobotoTextStyle(
                      fontSize: 16, fontColor: backGroundColor),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  ApiResponse _getActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getActivityChecklistApiResponse =>
      _getActivityChecklistApiResponse;

  Future<dynamic> storeForOfflineUseCommonAndDevelopment({
    required int index,
    required double h,
    required double w,
    required BuildContext context,
    required String activityType,
  }) async {
    log('activityType----------- ${activityType}');

    String resData =
        preferences.getString(SharedPreference.activityData).toString();
    if (resData.isNotEmpty) {
      var data = jsonDecode(resData);
      List<ChecklistData> tempData =
          List<ChecklistData>.from(data.map((x) => ChecklistData.fromJson(x)));
      if (tempData.length >= 10) {
        syncDataFirst(context, h, w);
        return;
      }
    }

    _getActivityChecklistApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    log('searchDevelopmentActivityCommonData----------- ${searchDevelopmentActivityCommonData}');
    log('searchActivityCommonData----------- ${searchActivityCommonData}');
    log('*******************---------${activityType == "common"}-- ${activityType == "common" ? '${searchDevelopmentActivityCommonData[index].activityId ?? ""}' : '${searchActivityCommonData[index].activityId ?? ""}'}');

    try {
      ChecklistByActivityResponseModel response =
          await ProjectRepo().getActivityChecklistRepo(body: {
        "activity_id": activityType == "DEVELOPMENT"
            ? '${searchDevelopmentActivityCommonData[index].activityId ?? ""}'
            : '${searchActivityCommonData[index].activityId ?? ""}'
      });
      bool isData = preferences
          .getString(SharedPreference.activityData)
          .toString()
          .isEmpty;

      if (isData) {
        List data = [];
        data.add(response.checklistData);
        log('data-ert---------- ${data}');

        preferences.putString(SharedPreference.activityData, jsonEncode(data));
      } else {
        String resData =
            preferences.getString(SharedPreference.activityData).toString();
        var data = jsonDecode(resData);
        List<ChecklistData> tempData = List<ChecklistData>.from(
            data.map((x) => ChecklistData.fromJson(x)));
        tempData.removeWhere(
            (e) => e.activityId == response.checklistData?.activityId);
        log('response.checklistData!-------FALSE---- ${response.checklistData!}');

        tempData.add(response.checklistData!);
        log('tempData-.length---------- ${tempData.length}');
        log('tempData----------- ${tempData.toList()}');

        preferences.putString(
            SharedPreference.activityData, jsonEncode(tempData));
        await Future.delayed(const Duration(seconds: 1));
        _getActivityChecklistApiResponse = ApiResponse.complete(response);
        saveForOfflineUse(context, h, w, tempData.length);
      }

      _getActivityChecklistApiResponse = ApiResponse.complete(response);

      log("_getActivityChecklistApiResponse==>$response");
    } catch (e) {
      _getActivityChecklistApiResponse =
          ApiResponse.error(message: e.toString());
      log("_getActivityChecklistApiResponse=ERROR=>$e");
    }
    update();
  }

  Future<void> syncDataFirst(BuildContext context, double h, double w) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
            child: "Alert!".semiBoldBarlowTextStyle(
                fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "You have reached save activity limit which is maximum 10 so please sync data to the server then you can store other activities."
                    .regularRobotoTextStyle(
                        fontSize: 15, textAlign: TextAlign.center),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: appColor,
                height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: "Okay".boldRobotoTextStyle(
                      fontSize: 16, fontColor: backGroundColor),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
