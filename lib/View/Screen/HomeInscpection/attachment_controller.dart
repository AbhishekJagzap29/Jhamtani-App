import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class AttachmentController extends GetxController {
  ApiResponse _resubmitObservationResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get resubmitObservationResponse => _resubmitObservationResponse;

  bool isLoading = false;
  Future<void> resubmitObservationToChecker({
    required int observationId,
    required List<String> imageFiles,
    required String remark,
    required String date,
    required String targetDate,
    int? locationId,
    required String description,
    // String? observationCategory,
    String? impactType,

  }) async {
    isLoading = true;
    _resubmitObservationResponse = ApiResponse.loading(message: 'Resubmitting...');
    update();
    debugPrint('imageFiles::::::::::::::111::${imageFiles.toList()}');
    print('imageFiles::::::::::::::222::${imageFiles.toList()}');
    try {
      List<String> base64Images = [];
      for (var path in imageFiles) {
        File file = File(path);
        if (file.existsSync()) {
          List<int> bytes = file.readAsBytesSync();
          String base64 = base64Encode(bytes);
          base64Images.add('data:image/png;base64,$base64');
        }
      }
      print('base64Images:::::::maker_uploaded_img:::::::::${base64Images.length}  :  ${base64Images}');
      Map<String, dynamic> body = {
        "observation_id": observationId,
        "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
        "remark": remark,
        "date": date,
        "target_date": targetDate,
        "maker_uploaded_img": base64Images,
        "checker_uploaded_img": [],
        "description": description,
        // "observation_category": observationCategory,
        "impact_type": impactType,
      };

      final response = await ProjectRepo().flatResubmittoCheckerRepo(body: body);
      print('response::::::::::::::::${response.toString()}');
      if (response.status == "SUCCESS") {
        successSnackBar("Success", "Resubmitted successfully");
        _resubmitObservationResponse = ApiResponse.complete(response);
      } else {
        errorSnackBar("Failed", response.message ?? "Something went wrong");
        _resubmitObservationResponse = ApiResponse.error(message: response.message ?? "Error occurred");
      }
      isLoading = false;
      update();
    } catch (e) {
      log("Resubmit Observation Error: $e");
      isLoading = false;
      update();
      _resubmitObservationResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  ApiResponse _completeObservationResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get completeObservationResponse => _completeObservationResponse;

  Future<void> completeObservationByChecker({
    required int observationId,
    required List<String> imageFiles,
    required String remark,
    required String date,
    required String targetDate,
    required String description,
   // required String observationCategory,
    String? impactType,
  }) async {
    isLoading = true;
    _completeObservationResponse = ApiResponse.loading(message: 'Submitting...');
    update();

    try {
      List<String> base64Images = [];
      for (var path in imageFiles) {
        File file = File(path);
        if (file.existsSync()) {
          List<int> bytes = file.readAsBytesSync();
          String base64 = base64Encode(bytes);
          base64Images.add('data:image/png;base64,$base64');
        }
      }

      Map<String, dynamic> body = {
        "observation_id": observationId,
        "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
        "remark": remark,
        "date": date,
        "target_date": targetDate,
        "checker_uploaded_img": base64Images,
        "maker_uploaded_img": [],
        "description": description,
      //  "observation_category": observationCategory, 
        "impact_type": impactType,
      };

      final response = await ProjectRepo().flatCompletedFormCheckerSide(body: body);

      if (response.status == "SUCCESS") {
        successSnackBar("Success", "Observation approved successfully");
        _completeObservationResponse = ApiResponse.complete(response);
      } else {
        errorSnackBar("Failed", response.message ?? "Something went wrong");
        _completeObservationResponse = ApiResponse.error(message: response.message ?? "Error");
      }
      isLoading = false;
      update();
    } catch (e, stackTrace) {
      log('❌ Submit Observation Error: $e');
      log('📄 StackTrace: $stackTrace');
      isLoading = false;
      update();
      _completeObservationResponse = ApiResponse.error(message: e.toString());
    }

    // catch (e) {
    //   log("Observation Completion Error: $e");
    //   isLoading = false;
    //   update();
    //   _completeObservationResponse = ApiResponse.error(message: e.toString());
    // }

    update();
  }
}

//   ApiResponse _completeObservationResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get completeObservationResponse => _completeObservationResponse;

//   Future<void> completeObservationByChecker({
//     required int observationId,
//   }) async {
//     isLoading = true;
//     _completeObservationResponse =
//         ApiResponse.loading(message: 'Submitting...');
//     update();

//     try {
//       Map<String, dynamic> body = {
//         "observation_id": observationId,
//         "user_id":
//             int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
//       };

//       final response =
//           await ProjectRepo().flatCompletedFormCheckerSide(body: body);

//       if (response.status == "SUCCESS") {
//         successSnackBar("Success", "Observation completed");
//         _completeObservationResponse = ApiResponse.complete(response);
//       } else {
//         errorSnackBar("Failed", response.message ?? "Something went wrong");
//         _completeObservationResponse =
//             ApiResponse.error(message: response.message ?? "Error");
//       }
//       isLoading = false;
//       update();
//     } catch (e) {
//       log("Observation Completion Error: $e");
//       isLoading = false;
//       update();
//       _completeObservationResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }
// }
