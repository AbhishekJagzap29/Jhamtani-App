import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';

class FlatFloorActivityController extends GetxController {
  final searchController = TextEditingController();
  GetFlatDataResponseModel? flatActivityRes;
  GetFloorDataResponseModel? floorActivityRes;
  bool loading = false;
  List<ListFlatData> listOfActivityData = [];
  List<ListFlatData> searchListOfActivityData = [];
  List<ListFloorData> listOfFloorActivityData = [];
  List<ListFloorData> searchListFloorOfActivityData = [];
  int flatDataLength = 0;
  int floorDataLength = 0;
  bool load = false;

  List<ListFlatData> dummyActivity = [];
    GetFlatFloorDataResponseModel? flatFloorRes;


  setFlatDataLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (flatDataLength > searchListOfActivityData.length) {
      flatDataLength = searchListOfActivityData.length;
    } else if (flatDataLength + 20 > searchListOfActivityData.length) {
      flatDataLength = searchListOfActivityData.length;
    } else {
      flatDataLength += 20;
    }
    load = false;
    update();
  }

  // fetchFlatActivityData({String? flatId}) async {
  //   loading = true;
  //   update();
  //
  //   final fetchFlatData = await dbHelper.getSingleDataFromTable(
  //       tableName: 'FlatData', id: int.parse(flatId.toString()), where: 'flatId');
  //   FlatDataModel flatDataModel = FlatDataModel.fromJson(fetchFlatData!);
  //
  //   final fetchFlatActivityData = await dbHelper.getDataFromTable(
  //       tableName: 'FlatActivity', where: "flatId", id: int.parse(flatId.toString()));
  //
  //   List<FlatActivityDataModel> flatActivityData =
  //       List<FlatActivityDataModel>.from(fetchFlatActivityData.map((x) => FlatActivityDataModel.fromJson(x)));
  //
  //   for (var element in flatActivityData) {
  //     ListFlatData data = ListFlatData(
  //       activityId: element.id,
  //       desc: element.description,
  //       writeDate: DateTime.parse(element.writeDate.toString()),
  //       name: element.name,
  //     );
  //     listOfActivityData.add(data);
  //   }
  //
  //   searchListOfActivityData = listOfActivityData;
  //
  //   activityData.ActivityData finalData = activityData.ActivityData(
  //       listFlatData: listOfActivityData, flatName: flatDataModel.flatName, flatId: flatDataModel.flatId);
  //   flatActivityRes = GetFlatDataResponseModel(activityData: finalData);
  //   setFlatDataLength(true);
  //   loading = false;
  //   update();
  // }

  searchActivity() {
    flatDataLength = 0;
    update();
    if (searchController.text.isNotEmpty) {
      searchListOfActivityData = [];
      for (var element in listOfActivityData) {
        if (element.name
            .toString()
            .toLowerCase()
            .contains(searchController.text.toString().toLowerCase())) {
          searchListOfActivityData.add(element);
        }
      }
    } else {
      searchListOfActivityData = listOfActivityData;
    }
    setFlatDataLength(true);
    update();
  }

  /// FLAT ACTIVITY API

///// orginal code

  ApiResponse _getFlatApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getFlatApiResponse => _getFlatApiResponse;

  Future<dynamic> getFlatController({Map<String, dynamic>? body}) async {
    _getFlatApiResponse = ApiResponse.loading(message: 'Loading');
    listOfActivityData = [];
    searchListOfActivityData = [];

    update();
    try {
      flatActivityRes = await ProjectRepo().getFlatRepo(body: body);
      _getFlatApiResponse = ApiResponse.complete(flatActivityRes);

      listOfActivityData = flatActivityRes?.activityData?.listFlatData ?? [];

      listOfActivityData.sort(
        (a, b) => "${a.name}".compareTo("${b.name}"),
      );

      searchListOfActivityData = listOfActivityData;
      setFlatDataLength(true);
      log("_getFlatApiResponse==>$flatActivityRes");
    } catch (e) {
      _getFlatApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatApiResponse=ERROR=>$e");
    }
    update();
  }

//// code for dummy activity testing

  // ApiResponse _getFlatApiResponse =
  //     ApiResponse.initial(message: 'Initialization');

  // ApiResponse get getFlatApiResponse => _getFlatApiResponse;

  // Future<dynamic> getFlatController({Map<String, dynamic>? body}) async {
  //   _getFlatApiResponse = ApiResponse.loading(message: 'Loading');
  //   listOfActivityData = [];
  //   searchListOfActivityData = [];

  //   update();
  //   try {
  //     flatActivityRes = await ProjectRepo().getFlatRepo(body: body);
  //     _getFlatApiResponse = ApiResponse.complete(flatActivityRes);

  //     listOfActivityData = flatActivityRes?.activityData?.listFlatData ?? [];

  //     // Check if the list is empty and add dummy activity
  //     if (listOfActivityData.isEmpty) {
  //       addDummyActivity();
  //     } else {
  //       listOfActivityData.sort(
  //         (a, b) => "${a.name}".compareTo("${b.name}"),
  //       );
  //     }

  //     searchListOfActivityData = listOfActivityData;
  //     setFlatDataLength(true);
  //     log("_getFlatApiResponse==>$flatActivityRes");
  //   } catch (e) {
  //     _getFlatApiResponse = ApiResponse.error(message: e.toString());
  //     log("_getFlatApiResponse=ERROR=>$e");
  //   }
  //   update();
  // }

  // void addDummyActivity() {
  //   // Create a dummy activity
  //   ListFlatData dummyActivity = ListFlatData(
  //     name: "Dummy Activity",
  //     //activityId: "1",
  //     desc: "Description for activity",
  //     color: "green",
  //     activity_type_status: true,
  //     writeDate: DateTime.now(),
  //   );

  //   // Add the dummy activity to the list
  //   listOfActivityData.add(dummyActivity);
  //   searchListOfActivityData.add(dummyActivity);
  // }

  setFloorDataLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (floorDataLength > searchListFloorOfActivityData.length) {
      floorDataLength = searchListFloorOfActivityData.length;
    } else if (floorDataLength + 20 > searchListFloorOfActivityData.length) {
      floorDataLength = searchListFloorOfActivityData.length;
    } else {
      floorDataLength += 20;
    }
    load = false;
    update();
  }

  searchFloorActivity() {
    floorDataLength = 0;
    if (searchController.text.isNotEmpty) {
      searchListFloorOfActivityData = [];
      for (var element in listOfFloorActivityData) {
        if (element.name
            .toString()
            .toLowerCase()
            .contains(searchController.text.toString().toLowerCase())) {
          searchListFloorOfActivityData.add(element);
        }
      }
    } else {
      searchListFloorOfActivityData = listOfFloorActivityData;
    }
    setFloorDataLength(true);
    update();
  }

  ///  FLOOR ACTIVITY API

  ApiResponse _getFloorApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getFloorApiResponse => _getFloorApiResponse;

  Future<dynamic> getFloorController({Map<String, dynamic>? body}) async {
    _getFloorApiResponse = ApiResponse.loading(message: 'Loading');
    listOfFloorActivityData = [];
    searchListFloorOfActivityData = [];
    update();
    try {
      floorActivityRes = await ProjectRepo().getFloorRepo(body: body);
      _getFloorApiResponse = ApiResponse.complete(floorActivityRes);

      listOfFloorActivityData =
          floorActivityRes?.activityData?.listFloorData ?? [];

      listOfFloorActivityData.sort(
        (a, b) => "${a.name}".compareTo("${b.name}"),
      );

      searchListFloorOfActivityData = listOfFloorActivityData;
      setFloorDataLength(true);
      log("_getFlatFlorApiResponse==>$floorActivityRes");
    } catch (e) {
      _getFloorApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatFlorApiResponse=ERROR=>$e");
    }
    update();
  }

  /// REPLICATE ACTIVITY

  ApiResponse _getReplicateActivityApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getReplicateActivityApiResponse =>
      _getReplicateActivityApiResponse;

  Future<dynamic> getReplicateActivityController(
      {Map<String, dynamic>? body}) async {
    _getReplicateActivityApiResponse = ApiResponse.loading(message: 'Loading');

    update();
    try {
      SuccessDataResponseModel successDataResponseModel =
          await ProjectRepo().duplicateActivityRepo(body: body);
      _getReplicateActivityApiResponse =
          ApiResponse.complete(successDataResponseModel);

      log("successDataResponseModel==>$successDataResponseModel");
    } catch (e) {
      _getReplicateActivityApiResponse =
          ApiResponse.error(message: e.toString());
      log("successDataResponseModel=ERROR=>$e");
    }
    update();
  }

  /// DELETE  ACTIVITY

  ApiResponse _deleteActivityApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteActivityApiResponse => _deleteActivityApiResponse;

  Future<dynamic> deleteActivityController({Map<String, dynamic>? body}) async {
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

  ApiResponse _getActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getActivityChecklistApiResponse =>
      _getActivityChecklistApiResponse;

  /// STORE DATA OFFLINE
  Future<dynamic> storeForOfflineUse({
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
    log('searchListFloorOfActivityData----------- ${searchListFloorOfActivityData}');
    log('searchListOfActivityData----------- ${searchListOfActivityData}');
    log('*******************---------${activityType == "floor"}-- ${activityType == "floor" ? '${searchListFloorOfActivityData[index].activityId ?? ""}' : '${searchListOfActivityData[index].activityId ?? ""}'}');

    try {
      // log('searchListFloorOfActivityData[index].activityId----------- ${searchListFloorOfActivityData[index].activityId}');

      ChecklistByActivityResponseModel response =
          await ProjectRepo().getActivityChecklistRepo(body: {
        "activity_id": activityType == "floor"
            ? '${searchListFloorOfActivityData[index].activityId ?? ""}'
            : '${searchListOfActivityData[index].activityId ?? ""}'
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
        // ignore: use_build_context_synchronously
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
