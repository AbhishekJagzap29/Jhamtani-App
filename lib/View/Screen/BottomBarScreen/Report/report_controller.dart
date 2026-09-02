import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/report_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_report_response_model.dart'
    as r;
import 'package:jhamtani_app/Api/ResponseModel/get_tower_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';

class ReportController extends GetxController {
  HomeScreenController homeScreenController = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController trainingDateController = TextEditingController();
  TextEditingController trainingStartController =
      TextEditingController(text: TimeOfDay.now().format(Get.context!));
  TextEditingController trainingEndController =
      TextEditingController(text: TimeOfDay.now().format(Get.context!));
  List<FocusNode> focusNodes = [];
  TextEditingController topicController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tDurationController =
      TextEditingController(text: "0.0");
  TextEditingController tManHourController = TextEditingController(text: "0.0");
  List overallImages = [];
  List<TowerDatum>? towerData = [];
  List<r.TowerDatum>? towerDataList;
  r.TowerDatum? selectedTowerData;
  r.TowerDatum? selectedTowerDetail;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  Duration? difference;
  ProjectDetails? selectProject;
  List<TextEditingController> trainingController = [];
  List<dynamic> trainingValues = [];
  List trainingGivenList = ['Contractor', 'jhamtaniApp'];
  DateFormat _dateFormat = DateFormat("h:mm a");

  changeProject(ProjectDetails value) {
    selectProject = value;
    getTowerData();
    selectTower = null;
    update();
  }

  TowerDatum? selectTower;

  changeTower(TowerDatum value) {
    selectTower = value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    //  for (int i = 0; i < 1; i++) {
    //    trainingController.add(TextEditingController());
    //    focusNodes.add(FocusNode());
    //    trainingValues.add(null);
    //  }
    //  getReportData();
    super.onInit();
  }

  /// Calculate Total Duration
  void calculateTimeOfDayDifference() {
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    difference = endDateTime.difference(startDateTime);
    log('difference====calculateTimeOfDayDifference==>$difference');
    tDurationController.text =
        "${difference!.inHours} Hour : ${difference!.inMinutes % 60} Minutes";
    getNonEmptyTextFieldsCount();
    update();
  }

  ///Get Text field Length
  void getNonEmptyTextFieldsCount() {
    int length = trainingController
        .where((controller) => controller.text.isNotEmpty)
        .length;

    if (difference != null) {
      int minutes =
          (((difference!.inHours * 60) + difference!.inMinutes % 60) * length) %
              60;

      int hour = (((difference!.inHours * 60) + difference!.inMinutes % 60) *
              length) ~/
          60;
      tManHourController.text = "$hour.$minutes";
      print('Added tManHourController values======>${tManHourController.text}');
    }
    update();
  }

  ///Check End Time Validation
  bool isTimeValid(TimeOfDay selectedEndTime, TimeOfDay startTime) {
    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime = DateTime(now.year, now.month, now.day,
        selectedEndTime.hour, selectedEndTime.minute);
    return endDateTime.isAfter(startDateTime);
  }

  /// Overall Image Capture
  captureOverallImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    String? imgFile;
    await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then((value) async {
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
                title: ("").toString()),
          ),
        ).then(
          (value1) {
            if (value1 != true) {
              imgFile = value1["image"];
              overallImages.add(imgFile);
            }
            return;
          },
        );
      } else {
        return value;
      }
    });
    update();
  }

  /// Remove Overall Image
  removeOverallImage(int id) {
    overallImages.removeAt(id);
    update();
  }

  ///Get Report Data
  ApiResponse _getReportResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getReportResponse => _getReportResponse;

  Future<void> getReportData() async {
    _getReportResponse = ApiResponse.loading(message: 'Loading');
    try {
      ///Request Body
      Map<String, dynamic> reqBody = {
        "user_id": int.parse(
            preferences.getString(SharedPreference.userId).toString()),
        ////// "projectId" : projectId
      };
      r.GetReportResponseModel getReportResponseModel =
          await ReportRepo().getReportRepo(body: reqBody);
      if (getReportResponseModel.status == "SUCCESS") {
        towerDataList = getReportResponseModel.towerData;
        towerDataList!.sort((a, b) {
          int dateComparison = b.trainingDatedOn!.compareTo(a.trainingDatedOn!);
          return dateComparison;
        });
        update();
      } else {
        errorSnackBar(
            "Something Went Wrong", getReportResponseModel.message ?? "");
      }
      _getReportResponse = ApiResponse.complete(getReportResponseModel);
    } catch (e) {
      _getReportResponse = ApiResponse.error(message: e.toString());
      log("Get Report ERROR=>$e");
    }
    update();
  }

  ///Get Tower Data
  ApiResponse _getTowerResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTowerResponse => _getTowerResponse;

  Future<void> getTowerData() async {
    _getTowerResponse = ApiResponse.loading(message: 'Loading');
    try {
      ///Request Body
      Map<String, dynamic> reqBody = {
        "user_id": int.parse(
            preferences.getString(SharedPreference.userId).toString()),
        "project_id": int.parse(selectProject!.projectId.toString())
      };
      debugPrint("reqBody===================${reqBody}");
      GetTowerResponseModel getTowerResponseModel =
          await ReportRepo().getTowerRepo(body: reqBody);
      if (getTowerResponseModel.status == "SUCCESS") {
        towerData = getTowerResponseModel.towerData;
        update();
      } else {
        errorSnackBar(
            "Something Went Wrong", getTowerResponseModel.message ?? "");
      }
      _getTowerResponse = ApiResponse.complete(getTowerResponseModel);
    } catch (e) {
      _getTowerResponse = ApiResponse.error(message: e.toString());
      log("Get Tower ERROR=>$e");
    }

    update();
  }

  ///Clear Data
  clearData() {
    trainingDateController.clear();
    topicController.clear();
    locationController.clear();
    tNameController.clear();
    descriptionController.clear();
    tManHourController.text = "0.0";
    tDurationController.text = "0.0";
    trainingStartController.text = TimeOfDay.now().format(Get.context!);
    trainingEndController.text = TimeOfDay.now().format(Get.context!);
    selectProject = null;
    selectTower = null;
    overallImages = [];
    difference = null;
    trainingController.clear();
    focusNodes.clear();
    trainingValues.clear();
    // for (int i = 0; i < 1; i++) {
    //   trainingController.add(TextEditingController());
    //   focusNodes.add(FocusNode());
    // }
    update();
  }

  /// Add Checker Report
  ApiResponse _addReportResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get addReportResponse => _addReportResponse;

  Future<void> addCheckerReport() async {
    try {
      if (selectProject == null) {
        errorSnackBar("Required Field", 'Please select project');
      } else if (selectTower == null) {
        errorSnackBar("Required Field", 'Please select tower');
      }
      // else if (overallImages.isEmpty) {
      //   errorSnackBar("Required Field", 'Please upload image');
      //}
      else {
        _addReportResponse = ApiResponse.loading(message: 'Loading');

        ///training Date
        DateTime parsedDate = DateFormat('dd-MM-yyyy')
            .parse(trainingDateController.text.toString());
        String trainingDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
          ),
        );

        /// Overall Image
        List overallImageListData = [];
        for (var element in overallImages) {
          String base64String = '';
          File path = File(element);
          if (path.existsSync()) {
            List<int> fileBytes = path.readAsBytesSync();
            base64String = base64Encode(fileBytes);
          }
          overallImageListData.add(base64String);
          update();
        }

        List<Map<String, dynamic>> data = [];
        for (int i = 0; i < trainingValues.length; i++) {
          if (trainingValues[i] == "" ||
              trainingValues[i] == null && trainingController[i].text == "") {
          } else {
            data.add({
              "tag": trainingValues[i].toString() == "Contractor"
                  ? "contractor"
                  : "vjd",
              "name": trainingController[i].text
            });
          }
        }

        ///Request Body
        Map<String, dynamic> reqBody = {
          "user_id": int.parse(
              preferences.getString(SharedPreference.userId).toString()),
          "project_id": selectProject?.projectId.toString(),
          "tower_id": selectTower?.towerId.toString(),
          "training_date": trainingDate,
          "training_topic": topicController.text.trim(),
          "location": locationController.text.trim(),
          "trainer_name": tNameController.text.trim(),
          // "training_given_to": trainingController
          //     .map((controller) => controller.text.trim())
          //     .toList(),
          "training_given_to": data,
          "start_time": trainingStartController.text.trim(),
          "end_time": trainingEndController.text.trim(),
          "total_duration": tDurationController.text.trim(),
          "total_manhours":
              "${tManHourController.text.toString().split(".").first} Hour : ${tManHourController.text.toString().split(".").last} Minutes",
          "description": descriptionController.text.trim(),

          "overall_images":
              overallImageListData.isEmpty ? [] : overallImageListData
        };

        log("reqBody===================${reqBody}");

        SuccessDataResponseModel successDataResponseModel =
            await ReportRepo().addCheckerReportRepo(body: reqBody);
        if (successDataResponseModel.status == "SUCCESS") {
          clearData();
          Get.back();
          successSnackBar("New Training Report Added",
              successDataResponseModel.message ?? "");
          getReportData();
        } else {
          errorSnackBar(
              "Something Went Wrong", successDataResponseModel.message ?? "");
        }
        _addReportResponse = ApiResponse.complete(successDataResponseModel);
      }
    } catch (e) {
      _addReportResponse = ApiResponse.error(message: e.toString());
      log("Add Report ERROR=>$e");
    }

    update();
  }

  ///Update Report Detail
  ApiResponse _updateReportResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get updateReportResponse => _updateReportResponse;

  Future<void> updateReportDetail(
      List<String>? overallImages,
      DateTime trainingDateData,
      int trainingId,
      int projectId,
      int towerId) async {
    try {
      _updateReportResponse = ApiResponse.loading(message: 'Loading');
      List overallImageListData = [];
      if (overallImages != null) {
        for (var element in overallImages) {
          overallImageListData.add(element);
          update();
        }
      }
      List<Map<String, dynamic>> data = [];
      for (int i = 0; i < trainingValues.length; i++) {
        if (trainingValues[i] == "" ||
            trainingValues[i] == null && trainingController[i].text == "" ||
            trainingController[i].text.isEmpty) {
        } else {
          data.add({
            "tag": trainingValues[i].toString() == "Contractor"
                ? "contractor"
                : "vjd",
            "name": trainingController[i].text
          });
        }
      }

      ///Request Body
      Map<String, dynamic> reqBody = {
        "training_report_id": trainingId,
        "user_id": int.parse(
            preferences.getString(SharedPreference.userId).toString()),
        "project_id": projectId,
        "tower_id": towerId,
        "training_date": DateFormat('yyyy-MM-dd').format(trainingDateData),
        "training_topic": topicController.text.trim(),
        "location": locationController.text.trim(),
        "trainer_name": tNameController.text.trim(),
        "training_given_to": data,
        "start_time": _dateFormat
            .format(
                DateFormat('HH:mm').parse(trainingStartController.text.trim()))
            .toString(),
        "end_time": _dateFormat
            .format(
                DateFormat('HH:mm').parse(trainingEndController.text.trim()))
            .toString(),
        "total_duration": tDurationController.text.trim(),
        "total_manhours":
            "${tManHourController.text.toString().split(".").first} Hour : ${tManHourController.text.toString().split(".").last} Minutes",
        "description": descriptionController.text.trim(),
        // "overall_images":
        //     overallImageListData.isEmpty ? [] : overallImageListData
      };

      log("reqBody===================${reqBody}");

      SuccessDataResponseModel successDataResponseModel =
          await ReportRepo().updateReportRepo(reqBody);
      if (successDataResponseModel.status == "SUCCESS") {
        data.clear();
        overallImageListData.clear();
        clearData();
        Get.back();
        Get.back();
        successSnackBar(
            "Training Report Updated", successDataResponseModel.message ?? "");
        getReportData();
      } else {
        errorSnackBar(
            "Something Went Wrong", successDataResponseModel.message ?? "");
      }
      _updateReportResponse = ApiResponse.complete(successDataResponseModel);
    } catch (e) {
      _updateReportResponse = ApiResponse.error(message: e.toString());
      log("Update Report ERROR=>$e");
    }
    update();
  }
}
