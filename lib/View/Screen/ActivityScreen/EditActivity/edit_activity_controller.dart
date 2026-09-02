import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checkpoint_details_by_activity_type_id.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/ActivityDetails/activity_details_controller.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';

class EditActivityController extends GetxController {
  ListFloorData? floorData;
  ListFlatData? flatData;
  ListChecklistDataByAc? activityData;
  String? activityId;
  ActivityDataConstModel? constData;
  List<LineData> savedLineData = [];
  String overallRemark = "";
  String offlineStatus = "";
  String screen = Get.arguments["screen"];
  String isNetwork = Get.arguments["network"] ?? "";
  String? imgFile;
  String status = '';
  bool isEdit = false;
  bool imageSaver = false;
  int userId = int.parse(preferences.getString(SharedPreference.userId) ?? "0");
  List<History> history = [];

  String towerName = Get.arguments?["towerName"] ?? "";

  String activityTypeId = '';

//DateTime? formSubmittedTime;

  // List overallImageList = [];

  ActivityDetailsController activityDetailsController =
      Get.put(ActivityDetailsController());

  loader(bool value) {
    imageSaver = value;
    update();
  }

  @override
  void onInit() {
    getActivityFloorFlatData();
    super.onInit();
  }

  bool isNotification = false;

  getActivityFloorFlatData() async {
    // if (isNetwork == "no") {
    constData = Get.arguments["model"];
    activityId = constData?.activityId.toString();
    activityData = constData?.activityData;
    String resData =
        preferences.getString(SharedPreference.savedActivityData).toString();
    print('resData==============>>>${resData}');
    if (resData.isNotEmpty) {
      List existingData = jsonDecode(resData);
      final data1 = existingData
          .where((element) =>
              element["activity_type_id"] == activityData?.activityTypeId)
          .toList();
      if (data1.isNotEmpty) {
        print('data1==============>>>${data1}');
        overallRemark = data1.first["overall_remarks"];
        activityData!.controller.text = overallRemark;
        activityData!.overallImagesList = data1.first['overall_images'] ?? [];
        if (isNetwork == "no") {
          offlineStatus = data1.first["status"];
        }
        log('offlineStatus==============>>>${offlineStatus}');
        savedLineData.addAll(
          List<LineData>.from(
            data1.first["checklist_line"].map((x) => LineData.fromJson(x)),
          ),
        );
      }

      if (isNetwork.isEmpty) {
        isNetwork = "yes";
      }

      changeStatus();
    }
    // } else {
    if (screen == "activity") {
      constData = Get.arguments["model"];
      activityId = constData?.activityId.toString();
      activityData = constData?.activityData;
      changeStatus();
      if (constData?.floorFlatData.runtimeType.toString() == "ListFloorData") {
        floorData = constData?.floorFlatData;
      } else {
        flatData = constData?.floorFlatData;
      }
    } else 
    {

      isNotification = true;
      update();
      int id = int.parse(Get.arguments["activity_type_id"].toString());
      getCheckpointDataController(id).then(
        (value) {

          
          if (getCheckpointDataApiResponse.status == Status.COMPLETE) {
            GetCheckPointDetailsByActivityTypeId res =
                getCheckpointDataApiResponse.data;
            activityData = res.activityData;
          



            status = activityData?.activityStatus == "draft"
                ? 'maker'
                : activityData?.activityStatus == "submit"
                    ? 'checker'
                    : 'approver';
            if (activityData?.activityStatus == "approve") {
              isEdit = false;
              // } else if (preferences.getString(SharedPreference.userType) ==
              //     status) {
              //   isEdit = true;
            } else if ((status == 'maker' &&
                    (preferences
                            .getString(SharedPreference.userType)
                            ?.contains("maker") ??
                        false)) ||
                (status != 'maker' &&
                    preferences.getString(SharedPreference.userType) ==
                        status)) {
              isEdit = true;
            } else {
              isEdit = false;
            }
            isNotification = false;
            update();
          } else if (getCheckpointDataApiResponse.status == Status.ERROR) {
            isNotification = false;
            update();
          }
        },
      );
    }
    // }

    update();
  }

  changeStatus() {
    log('activityData?.activityStatus==============>>>${activityData?.activityStatus}');
    status = activityData?.activityStatus == "draft"
        ? 'maker'
        : activityData?.activityStatus == "submit"
            ? 'checker'
            : 'approver';

    print('status----------- $status');
    if (activityData?.activityStatus == "approve") {
      isEdit = false;
      // } else if (preferences.getString(SharedPreference.userType) == status) {
      //   isEdit = true;
    } else if ((status == 'maker' &&
            (preferences
                    .getString(SharedPreference.userType)
                    ?.contains("maker") ??
                false)) ||
        (status != 'maker' &&
            preferences.getString(SharedPreference.userType) == status)) {
      isEdit = true;
    } else {
      isEdit = false;
    }
    update();
  }

  capturePhoto({required int index, required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);

          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                  image: File(compressedFile.path.toString()),
                  title: (constData?.flatFloorName ?? "").toString()),
            ),
          ).then(
            (value1) {
              if (value1 != true) {
                imgFile = value1["image"];
                print('imgFile==============>>>${imgFile}');
                print(
                    'isNetwork.isNotEmpty==============>>>${isNetwork.isNotEmpty}');
                print(
                    'savedLineData.isNotEmpty==============>>>${savedLineData.isNotEmpty}');
                // activityData?.lineData?[index].imageList.add(imgFile);

                (isNetwork.isNotEmpty && savedLineData.isNotEmpty)
                    ? savedLineData[index].imageData.add(imgFile)
                    : activityData?.lineData?[index].imageList.add(imgFile);

                update();
              }
              return;
            },
          );
        } else {
          return value;
        }
      },
    );

    update();
  }

  removeImage(int id, int index) {
    log('id==============>>>${id}');
    log('index==============>>>${index}');
    log('isNetwork.isNotEmpty && savedLineData.isNotEmpty==============>>>${isNetwork.isNotEmpty && savedLineData.isNotEmpty}');
    log('activityData!.lineData?[index].imageData==============>>>${activityData!.lineData?[index].imageData}');
    log(' activityData!.lineData?[index].imageList==============>>>${activityData!.lineData?[index].imageList}');
    if (isNetwork.isNotEmpty && savedLineData.isNotEmpty) {
      savedLineData[index].imageData.removeAt(id);
    } else {
      activityData?.lineData?[index].imageList.removeAt(id);
    }
    update();
  }

  /// Overall Image Capture
  captureOverallImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                  image: File(compressedFile.path.toString()),
                  title: (constData?.flatFloorName ?? "").toString()),
            ),
          ).then(
            (value1) {
              if (value1 != true) {
                imgFile = value1["image"];
                activityData?.overallImagesList?.add(imgFile);
              }
              return;
            },
          );
        } else {
          return value;
        }
      },
    );

    update();
  }

  removeOverallImage(int id) {
    activityData?.overallImagesList?.removeAt(id);
    update();
  }

  changeDropDownValue(
      int index, ListChecklistDataByAc activityData, String newValue) {
    activityData.lineData?[index].value = newValue;
    update();
  }

  /// API

  /// UPLOAD DATA

  ApiResponse _uploadDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

  Future<dynamic> uploadCheckListController({required String isDraft}) async {
    if (activityData?.lineData?.any(
            (element) => (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Alert !",
          'You can not Submit this checklist because You Selected "No" checkpoints');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isNotEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else if ((activityData?.overallImagesList!.isEmpty)!) {
      errorSnackBar(
          "Required Field", "Please enter at least one Overall image");
    } else if (activityData!.controller.text.toString().trim().isEmpty) {
      errorSnackBar("Required Field", "Please enter Overall Remark");
    } else {
      if (activityData!.lineData!
          .any((element) => element.history!.isNotEmpty)) {
        if (activityData?.lineData?.any((element) =>
                element.history?.first.isPass?.toLowerCase() == "no" &&
                !element.imageList
                    .any((element1) => !element1.contains('http://'))) ==
            true) {
          errorSnackBar("Required Field",
              "Please enter at least one image for recently 'Yes' selected checkpoints");
          return;
        }
      }
      _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
      update();
      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];
        for (var element1 in element.imageList) {
          if (!element1.contains('http://')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();
              base64String = base64Encode(fileBytes);
            }
            element.imageData.add(base64String);
          }
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            // "image_data": element.imageData,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                    element.imageData.isNotEmpty
                // && element.imageData.contains('http://')
                )
              "image_data": element.imageData,
          },
        );
      });

      /// Overall Image add
      List overallImageListData = [];
      activityData?.overallImagesList?.forEach((element) {
        if (!element.contains('http://')) {
          String base64String = '';
          File path = File(element);
          if (path.existsSync()) {
            List<int> fileBytes = path.readAsBytesSync();
            base64String = base64Encode(fileBytes);
          }
          overallImageListData.add(base64String);
          update();
        }
      });

      Map<String, dynamic> body = {
        "user_id": userId,
        "is_draft": isDraft,
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,
        "overall_remarks": activityData?.controller.text.toString().trim(),
        // if (preferences.getString(SharedPreference.userType) == "maker" &&
        //     overallImageListData.isNotEmpty)
        if ((preferences
                    .getString(SharedPreference.userType)
                    ?.contains("maker") ??
                false) &&
            overallImageListData.isNotEmpty)
          "overall_images": overallImageListData,
      };

      try {
        SuccessDataResponseModel response =
            await ProjectRepo().updateChecklistRepo(body: body);
        _uploadDataApiResponse = ApiResponse.complete(response);

        if (response.status == "SUCCESS" || response.status == "Maker") {
          Get.back();
          await Future.delayed(const Duration(milliseconds: 500));
          successSnackBar(
              "Success",
              isDraft == "yes"
                  ? 'Checklist data saved successfully'
                  : 'Checklist data updated successfully');
        }
        log("_makerUploadDataApiResponse==>$response");
      } catch (e) {
        _uploadDataApiResponse = ApiResponse.error(message: e.toString());
        log("_makerUploadDataApiResponse=ERROR=>$e");
      }
      update();
    }
  }

  /// REJECT DATA

  ApiResponse _rejectDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get rejectDataApiResponse => _rejectDataApiResponse;

  Future<dynamic> rejectCheckListController() async {
    int? con = activityData?.lineData
        ?.indexWhere((element) => (element.value.toLowerCase() == "no"));

    if (con! < 0) {
      errorSnackBar("Alert !",
          'You can not reject or sent back this checklist because not any points select as "No"');
      return;
    }

    if (activityData?.lineData?.any((element) =>
            element.controller.text.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter description for 'No' selected checkpoints");
      log('Hello description validation');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else

    /// Require Overall Image and Overall Remark **********************
    //   if ((activityData?.overallImagesList!.isEmpty)!) {
    //   errorSnackBar("Required Field", "Please enter at least one Overall image");
    // } else if (activityData!.controller.text.toString().trim().isEmpty) {
    //   errorSnackBar("Required Field", "Please enter Overall Remark");
    // } else
    {
      _rejectDataApiResponse = ApiResponse.loading(message: 'Loading');
      update();

      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];

        for (var element1 in element.imageList) {
          if (!element1.contains('http')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();
              base64String = base64Encode(fileBytes);
            }
            element.imageData.add(base64String);
          }
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                element.imageData.isNotEmpty)
              "image_data": element.imageData,
          },
        );
      });

      Map<String, dynamic> body = {
        "user_id": userId,
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,
        "overall_remarks": activityData?.controller.text.toString().trim(),
      };

      try {
        SuccessDataResponseModel response =
            await ProjectRepo().rejectChecklistRepo(body: body);
        _rejectDataApiResponse = ApiResponse.complete(response);

        if (response.status == "SUCCESS") {
          Get.back();
          await Future.delayed(const Duration(milliseconds: 500));
          successSnackBar("Success", 'Checklist data rejected successfully');
        }
        log("_rejectDataApiResponse==>$response");
      } catch (e) {
        _rejectDataApiResponse = ApiResponse.error(message: e.toString());
        log("_rejectDataApiResponse=ERROR=>$e");
      }
      update();
    }
  }

  /// GET CHECKPOINT DARA BY ACTIVITY TYPE ID

  ApiResponse _getCheckpointDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getCheckpointDataApiResponse => _getCheckpointDataApiResponse;

  Future<dynamic> getCheckpointDataController(int id) async {
    _getCheckpointDataApiResponse = ApiResponse.loading(message: 'Loading');
    update();

    Map<String, dynamic> body = {"id": id};

    log('body==========>>>>>> $body');

    try {
      GetCheckPointDetailsByActivityTypeId response =
          await ProjectRepo().getChecklistByActivityTypeId(body: body);
      _getCheckpointDataApiResponse = ApiResponse.complete(response);

      log("_getCheckpointDataApiResponse==>$response");
    } catch (e) {
      _getCheckpointDataApiResponse = ApiResponse.error(message: e.toString());
      log("_getCheckpointDataApiResponse=ERROR=>$e");
    }
    update();
  }

  saveData(bool isReject) async {
    print(
        'activityData?.overallImagesList.length==============>>>${activityData?.overallImagesList?.length}');
    print(
        'activityData?.overallImagesList==============>>>${activityData?.overallImagesList}');

    if (isReject == true) {
      int? con = activityData?.lineData
          ?.indexWhere((element) => (element.value.toLowerCase() == "no"));

      if (con! < 0) {
        errorSnackBar("Alert !",
            'You can not reject or sent back this checklist because not any points select as "No"');
        return;
      }
    }

    if (activityData?.lineData?.any((element) =>
            element.controller.text.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter description for 'No' selected checkpoints");
      log('Hello description validation');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else

    /// Overall image
    // if (preferences.getString(SharedPreference.userType) == "maker" &&
    //     (activityData?.overallImagesList!.isEmpty)!) {
    //   errorSnackBar(
    //       "Required Field", "Please enter at least one Overall image");

    if ((preferences.getString(SharedPreference.userType)?.contains("maker") ??
            false) &&
        (activityData?.overallImagesList?.isEmpty ?? true)) {
      errorSnackBar(
          "Required Field", "Please enter at least one Overall image");
    } else {
      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];
        for (var element1 in element.imageList) {
          if (!element1.contains('http://')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();

              base64String = base64Encode(fileBytes);
            }
            element.imageData.add(base64String);
          }
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "name": element.name,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                element.imageData.isNotEmpty)
              "image_data": element.imageData,
          },
        );
      });

      Map<String, dynamic> body = {
        "user_id": userId,
        "is_draft": "yes",
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,
        "overall_remarks": activityData?.controller.text.toString().trim(),
        "status": activityData?.activityStatus == "draft"
            ? 'submit'
            : activityData?.activityStatus == "submit"
                ? 'checked'
                : 'approve',
        "isReject": isReject,
        "overall_images": activityData?.overallImagesList,
      };
      String resData =
          preferences.getString(SharedPreference.savedActivityData).toString();
      if (resData.isEmpty) {
        preferences.putString(
            SharedPreference.savedActivityData, jsonEncode([body]));
        activityDetailsController.checklistData?.forEach((element) {
          if (element.activityTypeId == activityData?.activityTypeId) {
            element.activityStatus = activityData?.activityStatus == "draft"
                ? 'submit'
                : activityData?.activityStatus == "submit"
                    ? 'checked'
                    : 'approve';
          }
        });
      } else {
        List existingData = jsonDecode(resData);
        existingData.removeWhere((element) =>
            element["activity_type_id"] == activityData?.activityTypeId);
        activityDetailsController.checklistData?.forEach((element) {
          if (element.activityTypeId == activityData?.activityTypeId) {
            element.activityStatus = activityData?.activityStatus == "draft"
                ? 'submit'
                : activityData?.activityStatus == "submit"
                    ? 'checked'
                    : 'approve';
          }
        });
        existingData.add(body);
        preferences.putString(
            SharedPreference.savedActivityData, jsonEncode(existingData));
      }

      Get.back();

      successSnackBar("Success", "Data saved successfully");
    }
  }

/////////////////////for commom tab activity type checklist details
// ApiResponse _getCommonChecklistApiResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get getCommonActivityChecklistApiResponse =>
//       _getCommonChecklistApiResponse;

//   Future<void> fetchCommonChecklist() async {
//     _getCommonChecklistApiResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     log("Fetching checklist data for activity_type_id: $activityTypeId");

//     try {
//       final requestBody = {
//         "activity_type_id": int.tryParse(activityTypeId) ?? activityTypeId
//       };
//       commonResponse = await ProjectRepo().getCommonDataRepo(body: requestBody);

//       if (commonResponse != null && commonResponse!.status == "SUCCESS") {
//         listCommonData = commonResponse?.listCommonData ?? [];
//         searchListCommonData = List.from(listCommonData);
//         _getCommonChecklistApiResponse = ApiResponse.complete(commonResponse);
//         log("Checklist Data Loaded Successfully: ${listCommonData.length} items");
//       } else {
//         log("Checklist data not found: ${commonResponse?.message}");
//         _getCommonChecklistApiResponse = ApiResponse.error(
//             message: commonResponse?.message ?? "Checklist not available");
//       }

//       update();
//     } catch (e) {
//       log("fetchCommonChecklist error: $e");
//       _getCommonChecklistApiResponse = ApiResponse.error(message: e.toString());
//       update();
//     }
//   }
}
