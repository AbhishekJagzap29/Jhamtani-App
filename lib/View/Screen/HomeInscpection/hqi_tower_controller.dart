import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_flat_list_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/submit_flat_for_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:path_provider/path_provider.dart';

class HQITowerController extends GetxController {
  String towerId = Get.arguments['towerId'];
  String projectId = Get.arguments['projectId'];

  var name = Get.arguments['name'];
  GetFlatFloorDataResponseModel? flatFloorRes;

  FlatListForHQIResponseModel? hqiFlatListRes;

  GetHQITowersResponseModel? towerres;

  final searchController = TextEditingController();
  bool loading = false;
  List<SubmitFlatData> submittedHQIFlatsList = [];
  List<ListFloor> listFloorData = [];
  List<ListFloor> listFlatData = [];
  List<ListFloor> searchListFloorData = [];
  List<ListFloor> searchListFlatData = [];
  List<HQIFlatData> hqiFlatList = [];
  List<HQIFlatData> searchHQIFlatList = [];

  int flatLength = 0;
  bool load = false;
  int select = 0;

  HQITower? selectedTower;

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

  setLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }
    if (select == 0) {
      flatLength = _calculateLength(flatLength, searchListFlatData.length);
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
    if (select == 0) {
      _filterData(searchController.text, listFlatData, searchListFlatData);
    }
    setLength(true);
    update();
  }

  void _filterData(String query, List<ListFloor> sourceList, List<ListFloor> targetList) {
    targetList.clear();
    if (query.isNotEmpty) {
      targetList.addAll(sourceList.where((element) => element.name.toString().toLowerCase().contains(query.toLowerCase())));
    } else {
      targetList.addAll(sourceList);
    }
  }

  @override
  void onInit() {
    super.onInit();
    {
      getHQIFlatListController(towerId: towerId, projectId: projectId);
    }
  }

  @override
  void dispose() {
    select = 0;
    super.dispose();
  }

  selectFlatFloor(int index) {
    select = index;
    searchController.clear();
    searchData();
    update();
  }

  ApiResponse _submitFlatResponse = ApiResponse.initial(message: "Initialization");
  ApiResponse get submitFlatResponse => _submitFlatResponse;

  Future<void> submitFlatForHQI({required int flatId}) async {
    _submitFlatResponse = ApiResponse.loading(message: "Submitting flat for HQI...");
    update();

    try {
      final request = {"flat_id": flatId, "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")};

      final response = await ProjectRepo().SubmitFlatForHQIRepo(body: request);

      if (response.status == "SUCCESS") {
        submittedHQIFlatsList = response.data ?? [];
        _submitFlatResponse = ApiResponse.complete(response);
      } else {
        _submitFlatResponse = ApiResponse.error(message: response.message ?? "Failed to submit flat for HQI");
      }
    } catch (e, st) {
      print("HQI submission error: $e");
      print("Stacktrace: $st");
      _submitFlatResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

//// hqi flat list
  ApiResponse _getFlatApiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get getFlatApiResponse => _getFlatApiResponse;

  Future<void> getHQIFlatListController({
    required String towerId,
    required String projectId,
  }) async {
    _getFlatApiResponse = ApiResponse.loading(message: 'Loading...');
    hqiFlatList = [];
    searchHQIFlatList = [];
    update();
    try {
      final response = await ProjectRepo().hqiFlatListRepo(body: {
        "tower_id": towerId,
        "project_id": projectId,
      });

      if (response.status == "SUCCESS") {
        hqiFlatList = response.data ?? [];
        hqiFlatList.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        searchHQIFlatList = List.from(hqiFlatList);
        _getFlatApiResponse = ApiResponse.complete(response);
      } else {
        _getFlatApiResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
      }

      log("HQI Flat List Loaded: ${hqiFlatList.length}");
    } catch (e) {
      _getFlatApiResponse = ApiResponse.error(message: e.toString());
      log("getHQIFlatListController ERROR: $e");
    }

    update();
  }

  ApiResponse _completeHQIFlatResponse = ApiResponse.initial(message: "Initialization");
  ApiResponse get completeHQIFlatResponse => _completeHQIFlatResponse;

  Future<void> completeHQIFlat({required int flatId}) async {
    _completeHQIFlatResponse = ApiResponse.loading(message: "Completing HQI flat...");
    update();

    try {
      final response = await ProjectRepo().completeForHQIRepo(body: {
        "flat_id": flatId,
      });

      if (response.status == "SUCCESS") {
        int index = searchHQIFlatList.indexWhere((element) => element.id == flatId);
        if (index != -1) {
          searchHQIFlatList[index].isHQICompleted = true;
        }

        _completeHQIFlatResponse = ApiResponse.complete(response);
        successSnackBar("Success", "HQI Flat completed");
      } else {
        _completeHQIFlatResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
      }
    } catch (e) {
      _completeHQIFlatResponse = ApiResponse.error(message: e.toString());
      log("completeHQIFlat error: $e");
    }

    update();
  }


  /// OFFLINE DATA HANDLING
  ApiResponse _getOfflineHqiFlateResponseModel = ApiResponse.initial(message: 'Initialization');

  ApiResponse get getOfflineHqiFlatResponseModel => _getOfflineHqiFlateResponseModel;

  /// STORE DATA OFFLINE
  Future<dynamic> storeForOfflineUse({
    required double h,
    required double w,
    required BuildContext context,
    required String flatId,
  }) async {
    log('===== storeForOfflineUse START =====');
    log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

    _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
    update();
    log('ApiResponse state set to LOADING');

    try {
      log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
      OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
        "flat_id": flatId,
        "user_id": preferences.getString(SharedPreference.userId) ?? "",
      });
      log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

      String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
      log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

      List<List<OfflineHQIData>> allOfflineData = [];

      // Load existing saved offline data
      if (resData != null && resData.isNotEmpty) {
        try {
          var existingData = jsonDecode(resData);
          log('Decoded existingData type: ${existingData.runtimeType}');

          if (existingData is List) {
            for (var sublist in existingData) {
              if (sublist is List) {
                List<OfflineHQIData> innerList = [];
                for (var item in sublist) {
                  if (item is Map<String, dynamic>) {
                    innerList.add(OfflineHQIData.fromJson(item));
                  }
                }
                allOfflineData.add(innerList);
              }
            }
          }
        } catch (decodeError) {
          log(' Error decoding existing offline data: $decodeError');
        }
      }

      log('Total offline FLAT LIST count BEFORE update: ${allOfflineData.length}');

      if (response.data != null && response.data!.isNotEmpty) {
        log('Downloading images locally for offline use...');
        await _downloadOfflineImagesForFlat(response.data!);

        String newFlatId = response.data!.first.flatId.toString();
        log('New response data flat_id: $newFlatId');

        // Remove any existing sublist with the same flat_id
        int beforeRemovalCount = allOfflineData.length;
        allOfflineData.removeWhere((sublist) => sublist.isNotEmpty && sublist.first.flatId.toString() == newFlatId);
        log('Removed ${beforeRemovalCount - allOfflineData.length} flat(s) with flat_id=$newFlatId');

        // Add the new sublist (entire response.data list)
        allOfflineData.add(response.data!);
        log('FLAT LIST count after adding new: ${allOfflineData.length}');
      } else {
        log('⚠ Response data is null or empty. Skipping add.');
      }

      // Save updated list
      String encodedData = jsonEncode(allOfflineData);
      preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
      log('✅ Offline save success. Total FLAT LIST count now: ${allOfflineData.length}');

      successSnackBar("Success", 'Flat data has been saved offline successfully');

      _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
      log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
    } catch (e, stacktrace) {
      _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
      log(' ERROR in storeForOfflineUse: $e');
      log('STACKTRACE: $stacktrace');
    }

    update();
    log('===== storeForOfflineUse END =====');
  }

  /// WORKING FUNCTION STORE IN LOCAL STORAGE
  /*Future<dynamic> storeForOfflineUse({
    required double h,
    required double w,
    required BuildContext context,
    required String flatId,
  }) async {
    log('===== storeForOfflineUse START =====');
    log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

    _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
    update();
    log('ApiResponse state set to LOADING');

    try {
      log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
      OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
        "flat_id": flatId,
        "user_id": preferences.getString(SharedPreference.userId) ?? "",
      });
      log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

      String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
      log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

      List<OfflineHQIData> allOfflineData = [];

      // Load existing saved offline data
      if (resData != null && resData.isNotEmpty) {
        try {
          var existingData = jsonDecode(resData);
          log('Decoded existingData type: ${existingData.runtimeType}');

          if (existingData is List) {
            for (var item in existingData) {
              if (item is Map<String, dynamic>) {
                allOfflineData.add(OfflineHQIData.fromJson(item));
              } else {
                log('⚠ Skipped item (not a Map<String, dynamic>): $item');
              }
            }
          }
        } catch (decodeError) {
          log('❌ Error decoding existing offline data: $decodeError');
        }
      }

      log('Total offline records BEFORE update: ${allOfflineData.length}');

      if (response.data != null && response.data!.isNotEmpty) {
        String newFlatId = response.data!.first.flatId.toString();
        log('New response data flat_id: $newFlatId');

        // Remove any existing record with the same flat_id
        int beforeRemovalCount = allOfflineData.length;
        allOfflineData.removeWhere((e) => e.flatId.toString() == newFlatId);
        log('Removed ${beforeRemovalCount - allOfflineData.length} record(s) with flat_id=$newFlatId');

        // Add the new record(s)
        allOfflineData.addAll(response.data!);
        log('Records count after adding new: ${allOfflineData.length}');
      } else {
        log('⚠ Response data is null or empty. Skipping add.');
      }

      // Save updated list
      String encodedData = jsonEncode(allOfflineData);
      preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
      log('✅ Offline save success. Total records now: ${allOfflineData.length}');

      successSnackBar("Success", 'Flat data has been saved offline successfully');

      _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
      log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
    } catch (e, stacktrace) {
      _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
      log('❌ ERROR in storeForOfflineUse: $e');
      log('STACKTRACE: $stacktrace');
    }

    update();
    log('===== storeForOfflineUse END =====');
  }*/

  /*
  /// STORE DATA OFFLINE
  Future<dynamic> storeForOfflineUse({
    required double h,
    required double w,
    required BuildContext context,
    required String flatId,
  }) async {
    log('flatId----------- $flatId');

    _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
    update();

    try {
      OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
        "flat_id": flatId,
        "user_id": preferences.getString(SharedPreference.userId) ?? "",
      });

      String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
      log('isData::::::::::::::::${resData == null || resData.isEmpty}');

      List<OfflineHQIData> allOfflineData = [];

      if (resData != null && resData.isNotEmpty) {
        // Decode the existing data, which is a list of lists.
        var existingData = jsonDecode(resData);

        if (existingData is List) {
          // Iterate through each nested list and then each map within it.
          for (var nestedList in existingData) {
            if (nestedList is List) {
              for (var item in nestedList) {
                if (item is Map<String, dynamic>) {
                  allOfflineData.add(OfflineHQIData.fromJson(item));
                }
              }
            }
          }
        }
      }

      // Remove the old data for the same visit_id to prevent duplicates.
      if (response.data != null && response.data!.isNotEmpty) {
        allOfflineData.removeWhere((e) => e.visitId == response.data!.first.visitId);
        // Add the new data.
        allOfflineData.addAll(response.data!);
      }

      // Save the updated flattened list back to SharedPreferences.
      preferences.putString(SharedPreference.hqiFlatsOfflineData, jsonEncode(allOfflineData));
      successSnackBar("Success", 'Flat data has been saved offline successfully');

      _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
      log('_getOfflineHqiFlateResponseModel::::::::::::::::${_getOfflineHqiFlateResponseModel.data}');
    } catch (e) {
      _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
      log("_getActivityChecklistApiResponse=ERROR=>$e");
    }
    update();
  }*/

  Future<void> saveForOfflineUse(BuildContext context, double h, double w, int length) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
            child: "Save Flat".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This Flat data saved successfully for the offline use. You can use Flat data for offline."
                    .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                "Total saved Flats : $length".regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _downloadOfflineImagesForFlat(List<OfflineHQIData> flatDataList) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final offlineImgDir = Directory('${appDir.path}/offline_images');
      if (!offlineImgDir.existsSync()) {
        await offlineImgDir.create(recursive: true);
      }

      Dio dio = Dio();

      for (var flat in flatDataList) {
        if (flat.locationData != null) {
          for (var location in flat.locationData!) {
            if (location.observations != null) {
              for (var observation in location.observations!) {
                if (observation.imgData != null) {
                  for (int i = 0; i < observation.imgData!.length; i++) {
                    var imgDatum = observation.imgData![i];

                    String? checkerImg = imgDatum.checkerUploadedImg;
                    String? makerImg = imgDatum.makerUploadedImg;

                    String updatedCheckerImg = checkerImg ?? '';
                    String updatedMakerImg = makerImg ?? '';

                    // Process checker uploaded image (Before image)
                    if (checkerImg != null &&
                        checkerImg.isNotEmpty &&
                        (checkerImg.startsWith('http://') || checkerImg.startsWith('https://'))) {
                      try {
                        String rawFileName = checkerImg.split('/').last.split('?').first;
                        String fileName = 'checker_${observation.observationId ?? 0}_${i}_$rawFileName';
                        fileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_\.]'), '_');
                        String localPath = '${offlineImgDir.path}/$fileName';

                        File localFile = File(localPath);
                        if (!localFile.existsSync()) {
                          await dio.download(checkerImg, localPath);
                        }

                        if (localFile.existsSync()) {
                          updatedCheckerImg = localPath;
                          log('✅ Downloaded offline before image: $localPath');
                        }
                      } catch (err) {
                        log('⚠️ Failed downloading before image: $err');
                      }
                    }

                    // Process maker uploaded image (After image)
                    if (makerImg != null &&
                        makerImg.isNotEmpty &&
                        (makerImg.startsWith('http://') || makerImg.startsWith('https://'))) {
                      try {
                        String rawFileName = makerImg.split('/').last.split('?').first;
                        String fileName = 'maker_${observation.observationId ?? 0}_${i}_$rawFileName';
                        fileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_\.]'), '_');
                        String localPath = '${offlineImgDir.path}/$fileName';

                        File localFile = File(localPath);
                        if (!localFile.existsSync()) {
                          await dio.download(makerImg, localPath);
                        }

                        if (localFile.existsSync()) {
                          updatedMakerImg = localPath;
                          log('✅ Downloaded offline after image: $localPath');
                        }
                      } catch (err) {
                        log('⚠️ Failed downloading after image: $err');
                      }
                    }

                    observation.imgData![i] = ObservationImageData(
                      imgUrl: imgDatum.imgUrl,
                      userChecker: imgDatum.userChecker,
                      userMaker: imgDatum.userMaker,
                      checkerUploadedImg: updatedCheckerImg,
                      makerUploadedImg: updatedMakerImg,
                    );
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      log('❌ Error downloading offline images: $e');
    }
  }
}




























































































































































// class HQITowerController extends GetxController {
//   String towerId = Get.arguments['towerId'];
//   String projectId = Get.arguments['projectId'];

//   var name = Get.arguments['name'];
//   GetFlatFloorDataResponseModel? flatFloorRes;

//   FlatListForHQIResponseModel? hqiFlatListRes;

//   GetHQITowersResponseModel? towerres;

//   final searchController = TextEditingController();
//   bool loading = false;
//   List<SubmitFlatData> submittedHQIFlatsList = [];
//   List<ListFloor> listFloorData = [];
//   List<ListFloor> listFlatData = [];
//   List<ListFloor> searchListFloorData = [];
//   List<ListFloor> searchListFlatData = [];
//   List<HQIFlatData> hqiFlatList = [];
//   List<HQIFlatData> searchHQIFlatList = [];

//   int flatLength = 0;
//   bool load = false;
//   int select = 0;

//   HQITower? selectedTower;

//   setFlatLength(bool isFirst) async {
//     if (!isFirst) {
//       load = true;
//       update();
//       await Future.delayed(const Duration(seconds: 1));
//     }
//     if (flatLength > searchListFlatData.length) {
//       flatLength = searchListFlatData.length;
//     } else if (flatLength + 20 > searchListFlatData.length) {
//       flatLength = searchListFlatData.length;
//     } else {
//       flatLength += 20;
//     }
//     load = false;
//     update();
//   }

//   setLength(bool isFirst) async {
//     if (!isFirst) {
//       load = true;
//       update();
//       await Future.delayed(const Duration(seconds: 1));
//     }
//     if (select == 0) {
//       flatLength = _calculateLength(flatLength, searchListFlatData.length);
//     }

//     load = false;
//     update();
//   }

//   int _calculateLength(int currentLength, int totalLength) {
//     if (currentLength > totalLength) {
//       return totalLength;
//     } else if (currentLength + 20 > totalLength) {
//       return totalLength;
//     } else {
//       return currentLength + 20;
//     }
//   }

//   searchData() {
//     if (select == 0) {
//       _filterData(searchController.text, listFlatData, searchListFlatData);
//     }
//     setLength(true);
//     update();
//   }

//   void _filterData(String query, List<ListFloor> sourceList, List<ListFloor> targetList) {
//     targetList.clear();
//     if (query.isNotEmpty) {
//       targetList.addAll(sourceList.where((element) => element.name.toString().toLowerCase().contains(query.toLowerCase())));
//     } else {
//       targetList.addAll(sourceList);
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     {
//       getHQIFlatListController(towerId: towerId, projectId: projectId);
//     }
//   }

//   @override
//   void dispose() {
//     select = 0;
//     super.dispose();
//   }

//   selectFlatFloor(int index) {
//     select = index;
//     searchController.clear();
//     searchData();
//     update();
//   }

//   ApiResponse _submitFlatResponse = ApiResponse.initial(message: "Initialization");
//   ApiResponse get submitFlatResponse => _submitFlatResponse;

//   Future<void> submitFlatForHQI({required int flatId}) async {
//     _submitFlatResponse = ApiResponse.loading(message: "Submitting flat for HQI...");
//     update();

//     try {
//       final request = {"flat_id": flatId, "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")};

//       final response = await ProjectRepo().SubmitFlatForHQIRepo(body: request);

//       if (response.status == "SUCCESS") {
//         submittedHQIFlatsList = response.data ?? [];
//         _submitFlatResponse = ApiResponse.complete(response);
//       } else {
//         _submitFlatResponse = ApiResponse.error(message: response.message ?? "Failed to submit flat for HQI");
//       }
//     } catch (e, st) {
//       print("HQI submission error: $e");
//       print("Stacktrace: $st");
//       _submitFlatResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }

// //// hqi flat list
//   ApiResponse _getFlatApiResponse = ApiResponse.initial(message: 'Initialization');
//   ApiResponse get getFlatApiResponse => _getFlatApiResponse;

//   Future<void> getHQIFlatListController({
//     required String towerId,
//     required String projectId,
//   }) async {
//     _getFlatApiResponse = ApiResponse.loading(message: 'Loading...');
//     hqiFlatList = [];
//     searchHQIFlatList = [];
//     update();
//     try {
//       final response = await ProjectRepo().hqiFlatListRepo(body: {
//         "tower_id": towerId,
//         "project_id": projectId,
//       });

//       if (response.status == "SUCCESS") {
//         hqiFlatList = response.data ?? [];
//         hqiFlatList.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
//         searchHQIFlatList = List.from(hqiFlatList);
//         _getFlatApiResponse = ApiResponse.complete(response);
//       } else {
//         _getFlatApiResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
//       }

//       log("HQI Flat List Loaded: ${hqiFlatList.length}");
//     } catch (e) {
//       _getFlatApiResponse = ApiResponse.error(message: e.toString());
//       log("getHQIFlatListController ERROR: $e");
//     }

//     update();
//   }

//   ApiResponse _completeHQIFlatResponse = ApiResponse.initial(message: "Initialization");
//   ApiResponse get completeHQIFlatResponse => _completeHQIFlatResponse;

//   Future<void> completeHQIFlat({required int flatId}) async {
//     _completeHQIFlatResponse = ApiResponse.loading(message: "Completing HQI flat...");
//     update();

//     try {
//       final response = await ProjectRepo().completeForHQIRepo(body: {
//         "flat_id": flatId,
//       });

//       if (response.status == "SUCCESS") {
//         int index = searchHQIFlatList.indexWhere((element) => element.id == flatId);
//         if (index != -1) {
//           searchHQIFlatList[index].isHQICompleted = true;
//         }

//         _completeHQIFlatResponse = ApiResponse.complete(response);
//         successSnackBar("Success", "HQI Flat completed");
//       } else {
//         _completeHQIFlatResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
//       }
//     } catch (e) {
//       _completeHQIFlatResponse = ApiResponse.error(message: e.toString());
//       log("completeHQIFlat error: $e");
//     }

//     update();
//   }


//   /// OFFLINE DATA HANDLING
//   ApiResponse _getOfflineHqiFlateResponseModel = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getOfflineHqiFlatResponseModel => _getOfflineHqiFlateResponseModel;

//   /// STORE DATA OFFLINE
//   Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('===== storeForOfflineUse START =====');
//     log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();
//     log('ApiResponse state set to LOADING');

//     try {
//       log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });
//       log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

//       List<List<OfflineHQIData>> allOfflineData = [];

//       // Load existing saved offline data
//       if (resData != null && resData.isNotEmpty) {
//         try {
//           var existingData = jsonDecode(resData);
//           log('Decoded existingData type: ${existingData.runtimeType}');

//           if (existingData is List) {
//             for (var sublist in existingData) {
//               if (sublist is List) {
//                 List<OfflineHQIData> innerList = [];
//                 for (var item in sublist) {
//                   if (item is Map<String, dynamic>) {
//                     innerList.add(OfflineHQIData.fromJson(item));
//                   }
//                 }
//                 allOfflineData.add(innerList);
//               }
//             }
//           }
//         } catch (decodeError) {
//           log(' Error decoding existing offline data: $decodeError');
//         }
//       }

//       log('Total offline FLAT LIST count BEFORE update: ${allOfflineData.length}');

//       if (response.data != null && response.data!.isNotEmpty) {
//         String newFlatId = response.data!.first.flatId.toString();
//         log('New response data flat_id: $newFlatId');

//         // Remove any existing sublist with the same flat_id
//         int beforeRemovalCount = allOfflineData.length;
//         allOfflineData.removeWhere((sublist) => sublist.isNotEmpty && sublist.first.flatId.toString() == newFlatId);
//         log('Removed ${beforeRemovalCount - allOfflineData.length} flat(s) with flat_id=$newFlatId');

//         // Add the new sublist (entire response.data list)
//         allOfflineData.add(response.data!);
//         log('FLAT LIST count after adding new: ${allOfflineData.length}');
//       } else {
//         log('⚠ Response data is null or empty. Skipping add.');
//       }

//       // Save updated list
//       String encodedData = jsonEncode(allOfflineData);
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
//       log('✅ Offline save success. Total FLAT LIST count now: ${allOfflineData.length}');

//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
//     } catch (e, stacktrace) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log(' ERROR in storeForOfflineUse: $e');
//       log('STACKTRACE: $stacktrace');
//     }

//     update();
//     log('===== storeForOfflineUse END =====');
//   }

//   /// WORKING FUNCTION STORE IN LOCAL STORAGE
//   /*Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('===== storeForOfflineUse START =====');
//     log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();
//     log('ApiResponse state set to LOADING');

//     try {
//       log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });
//       log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

//       List<OfflineHQIData> allOfflineData = [];

//       // Load existing saved offline data
//       if (resData != null && resData.isNotEmpty) {
//         try {
//           var existingData = jsonDecode(resData);
//           log('Decoded existingData type: ${existingData.runtimeType}');

//           if (existingData is List) {
//             for (var item in existingData) {
//               if (item is Map<String, dynamic>) {
//                 allOfflineData.add(OfflineHQIData.fromJson(item));
//               } else {
//                 log('⚠ Skipped item (not a Map<String, dynamic>): $item');
//               }
//             }
//           }
//         } catch (decodeError) {
//           log('❌ Error decoding existing offline data: $decodeError');
//         }
//       }

//       log('Total offline records BEFORE update: ${allOfflineData.length}');

//       if (response.data != null && response.data!.isNotEmpty) {
//         String newFlatId = response.data!.first.flatId.toString();
//         log('New response data flat_id: $newFlatId');

//         // Remove any existing record with the same flat_id
//         int beforeRemovalCount = allOfflineData.length;
//         allOfflineData.removeWhere((e) => e.flatId.toString() == newFlatId);
//         log('Removed ${beforeRemovalCount - allOfflineData.length} record(s) with flat_id=$newFlatId');

//         // Add the new record(s)
//         allOfflineData.addAll(response.data!);
//         log('Records count after adding new: ${allOfflineData.length}');
//       } else {
//         log('⚠ Response data is null or empty. Skipping add.');
//       }

//       // Save updated list
//       String encodedData = jsonEncode(allOfflineData);
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
//       log('✅ Offline save success. Total records now: ${allOfflineData.length}');

//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
//     } catch (e, stacktrace) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log('❌ ERROR in storeForOfflineUse: $e');
//       log('STACKTRACE: $stacktrace');
//     }

//     update();
//     log('===== storeForOfflineUse END =====');
//   }*/

//   /*
//   /// STORE DATA OFFLINE
//   Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('flatId----------- $flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('isData::::::::::::::::${resData == null || resData.isEmpty}');

//       List<OfflineHQIData> allOfflineData = [];

//       if (resData != null && resData.isNotEmpty) {
//         // Decode the existing data, which is a list of lists.
//         var existingData = jsonDecode(resData);

//         if (existingData is List) {
//           // Iterate through each nested list and then each map within it.
//           for (var nestedList in existingData) {
//             if (nestedList is List) {
//               for (var item in nestedList) {
//                 if (item is Map<String, dynamic>) {
//                   allOfflineData.add(OfflineHQIData.fromJson(item));
//                 }
//               }
//             }
//           }
//         }
//       }

//       // Remove the old data for the same visit_id to prevent duplicates.
//       if (response.data != null && response.data!.isNotEmpty) {
//         allOfflineData.removeWhere((e) => e.visitId == response.data!.first.visitId);
//         // Add the new data.
//         allOfflineData.addAll(response.data!);
//       }

//       // Save the updated flattened list back to SharedPreferences.
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, jsonEncode(allOfflineData));
//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel::::::::::::::::${_getOfflineHqiFlateResponseModel.data}');
//     } catch (e) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log("_getActivityChecklistApiResponse=ERROR=>$e");
//     }
//     update();
//   }*/

//   Future<void> saveForOfflineUse(BuildContext context, double h, double w, int length) {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: Center(
//             child: "Save Flat".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 "This Flat data saved successfully for the offline use. You can use Flat data for offline."
//                     .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 "Total saved Flats : $length".regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
//               ],
//             ),
//           ),
//           contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 color: appColor,
//                 height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 child: Center(
//                   child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }




































// class HQITowerController extends GetxController {
//   String towerId = Get.arguments['towerId'];
//   String projectId = Get.arguments['projectId'];

//   var name = Get.arguments['name'];
//   GetFlatFloorDataResponseModel? flatFloorRes;

//   FlatListForHQIResponseModel? hqiFlatListRes;

//   GetHQITowersResponseModel? towerres;

//   final searchController = TextEditingController();
//   bool loading = false;
//   List<SubmitFlatData> submittedHQIFlatsList = [];
//   List<ListFloor> listFloorData = [];
//   List<ListFloor> listFlatData = [];
//   List<ListFloor> searchListFloorData = [];
//   List<ListFloor> searchListFlatData = [];
//   List<HQIFlatData> hqiFlatList = [];
//   List<HQIFlatData> searchHQIFlatList = [];

//   int flatLength = 0;
//   bool load = false;
//   int select = 0;

//   HQITower? selectedTower;

//   setFlatLength(bool isFirst) async {
//     if (!isFirst) {
//       load = true;
//       update();
//       await Future.delayed(const Duration(seconds: 1));
//     }
//     if (flatLength > searchListFlatData.length) {
//       flatLength = searchListFlatData.length;
//     } else if (flatLength + 20 > searchListFlatData.length) {
//       flatLength = searchListFlatData.length;
//     } else {
//       flatLength += 20;
//     }
//     load = false;
//     update();
//   }

//   setLength(bool isFirst) async {
//     if (!isFirst) {
//       load = true;
//       update();
//       await Future.delayed(const Duration(seconds: 1));
//     }
//     if (select == 0) {
//       flatLength = _calculateLength(flatLength, searchListFlatData.length);
//     }

//     load = false;
//     update();
//   }

//   int _calculateLength(int currentLength, int totalLength) {
//     if (currentLength > totalLength) {
//       return totalLength;
//     } else if (currentLength + 20 > totalLength) {
//       return totalLength;
//     } else {
//       return currentLength + 20;
//     }
//   }

//   searchData() {
//     if (select == 0) {
//       _filterData(searchController.text, listFlatData, searchListFlatData);
//     }
//     setLength(true);
//     update();
//   }

//   void _filterData(String query, List<ListFloor> sourceList, List<ListFloor> targetList) {
//     targetList.clear();
//     if (query.isNotEmpty) {
//       targetList.addAll(sourceList.where((element) => element.name.toString().toLowerCase().contains(query.toLowerCase())));
//     } else {
//       targetList.addAll(sourceList);
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     {
//       getHQIFlatListController(towerId: towerId, projectId: projectId);
//     }
//   }

//   @override
//   void dispose() {
//     select = 0;
//     super.dispose();
//   }

//   selectFlatFloor(int index) {
//     select = index;
//     searchController.clear();
//     searchData();
//     update();
//   }

//   ApiResponse _submitFlatResponse = ApiResponse.initial(message: "Initialization");
//   ApiResponse get submitFlatResponse => _submitFlatResponse;

//   Future<void> submitFlatForHQI({required int flatId}) async {
//     _submitFlatResponse = ApiResponse.loading(message: "Submitting flat for HQI...");
//     update();

//     try {
//       final request = {"flat_id": flatId, "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")};

//       final response = await ProjectRepo().SubmitFlatForHQIRepo(body: request);

//       if (response.status == "SUCCESS") {
//         submittedHQIFlatsList = response.data ?? [];
//         _submitFlatResponse = ApiResponse.complete(response);
//       } else {
//         _submitFlatResponse = ApiResponse.error(message: response.message ?? "Failed to submit flat for HQI");
//       }
//     } catch (e, st) {
//       print("HQI submission error: $e");
//       print("Stacktrace: $st");
//       _submitFlatResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }

// //// hqi flat list
//   ApiResponse _getFlatApiResponse = ApiResponse.initial(message: 'Initialization');
//   ApiResponse get getFlatApiResponse => _getFlatApiResponse;

//   Future<void> getHQIFlatListController({
//     required String towerId,
//     required String projectId,
//   }) async {
//     _getFlatApiResponse = ApiResponse.loading(message: 'Loading...');
//     hqiFlatList = [];
//     searchHQIFlatList = [];
//     update();
//     try {
//       final response = await ProjectRepo().hqiFlatListRepo(body: {
//         "tower_id": towerId,
//         "project_id": projectId,
//       });

//       if (response.status == "SUCCESS") {
//         hqiFlatList = response.data ?? [];
//         hqiFlatList.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
//         searchHQIFlatList = List.from(hqiFlatList);
//         _getFlatApiResponse = ApiResponse.complete(response);
//       } else {
//         _getFlatApiResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
//       }

//       log("HQI Flat List Loaded: ${hqiFlatList.length}");
//     } catch (e) {
//       _getFlatApiResponse = ApiResponse.error(message: e.toString());
//       log("getHQIFlatListController ERROR: $e");
//     }

//     update();
//   }

//   ApiResponse _completeHQIFlatResponse = ApiResponse.initial(message: "Initialization");
//   ApiResponse get completeHQIFlatResponse => _completeHQIFlatResponse;

//   Future<void> completeHQIFlat({required int flatId}) async {
//     _completeHQIFlatResponse = ApiResponse.loading(message: "Completing HQI flat...");
//     update();

//     try {
//       final response = await ProjectRepo().completeForHQIRepo(body: {
//         "flat_id": flatId,
//       });

//       if (response.status == "SUCCESS") {
//         int index = searchHQIFlatList.indexWhere((element) => element.id == flatId);
//         if (index != -1) {
//           searchHQIFlatList[index].isHQICompleted = true;
//         }

//         _completeHQIFlatResponse = ApiResponse.complete(response);
//         successSnackBar("Success", "HQI Flat completed");
//       } else {
//         _completeHQIFlatResponse = ApiResponse.error(message: response.message ?? "Something went wrong");
//       }
//     } catch (e) {
//       _completeHQIFlatResponse = ApiResponse.error(message: e.toString());
//       log("completeHQIFlat error: $e");
//     }

//     update();
//   }


//   /// OFFLINE DATA HANDLING
//   ApiResponse _getOfflineHqiFlateResponseModel = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getOfflineHqiFlatResponseModel => _getOfflineHqiFlateResponseModel;

//   /// STORE DATA OFFLINE
//   Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('===== storeForOfflineUse START =====');
//     log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();
//     log('ApiResponse state set to LOADING');

//     try {
//       log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });
//       log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

//       List<List<OfflineHQIData>> allOfflineData = [];

//       // Load existing saved offline data
//       if (resData != null && resData.isNotEmpty) {
//         try {
//           var existingData = jsonDecode(resData);
//           log('Decoded existingData type: ${existingData.runtimeType}');

//           if (existingData is List) {
//             for (var sublist in existingData) {
//               if (sublist is List) {
//                 List<OfflineHQIData> innerList = [];
//                 for (var item in sublist) {
//                   if (item is Map<String, dynamic>) {
//                     innerList.add(OfflineHQIData.fromJson(item));
//                   }
//                 }
//                 allOfflineData.add(innerList);
//               }
//             }
//           }
//         } catch (decodeError) {
//           log(' Error decoding existing offline data: $decodeError');
//         }
//       }

//       log('Total offline FLAT LIST count BEFORE update: ${allOfflineData.length}');

//       if (response.data != null && response.data!.isNotEmpty) {
//         String newFlatId = response.data!.first.flatId.toString();
//         log('New response data flat_id: $newFlatId');

//         // Remove any existing sublist with the same flat_id
//         int beforeRemovalCount = allOfflineData.length;
//         allOfflineData.removeWhere((sublist) => sublist.isNotEmpty && sublist.first.flatId.toString() == newFlatId);
//         log('Removed ${beforeRemovalCount - allOfflineData.length} flat(s) with flat_id=$newFlatId');

//         // Add the new sublist (entire response.data list)
//         allOfflineData.add(response.data!);
//         log('FLAT LIST count after adding new: ${allOfflineData.length}');
//       } else {
//         log('⚠ Response data is null or empty. Skipping add.');
//       }

//       // Save updated list
//       String encodedData = jsonEncode(allOfflineData);
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
//       log('✅ Offline save success. Total FLAT LIST count now: ${allOfflineData.length}');

//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
//     } catch (e, stacktrace) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log(' ERROR in storeForOfflineUse: $e');
//       log('STACKTRACE: $stacktrace');
//     }

//     update();
//     log('===== storeForOfflineUse END =====');
//   }

//   /// WORKING FUNCTION STORE IN LOCAL STORAGE
//   /*Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('===== storeForOfflineUse START =====');
//     log('Incoming Parameters: h=$h, w=$w, flatId=$flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();
//     log('ApiResponse state set to LOADING');

//     try {
//       log('Calling getHQIFlatsOfflineRepo with: flat_id=$flatId, user_id=${preferences.getString(SharedPreference.userId) ?? ""}');
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });
//       log('Response received from ProjectRepo().getHQIFlatsOfflineRepo');

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('SharedPreferences existing offline data is NULL or EMPTY? => ${resData == null || resData.isEmpty}');

//       List<OfflineHQIData> allOfflineData = [];

//       // Load existing saved offline data
//       if (resData != null && resData.isNotEmpty) {
//         try {
//           var existingData = jsonDecode(resData);
//           log('Decoded existingData type: ${existingData.runtimeType}');

//           if (existingData is List) {
//             for (var item in existingData) {
//               if (item is Map<String, dynamic>) {
//                 allOfflineData.add(OfflineHQIData.fromJson(item));
//               } else {
//                 log('⚠ Skipped item (not a Map<String, dynamic>): $item');
//               }
//             }
//           }
//         } catch (decodeError) {
//           log('❌ Error decoding existing offline data: $decodeError');
//         }
//       }

//       log('Total offline records BEFORE update: ${allOfflineData.length}');

//       if (response.data != null && response.data!.isNotEmpty) {
//         String newFlatId = response.data!.first.flatId.toString();
//         log('New response data flat_id: $newFlatId');

//         // Remove any existing record with the same flat_id
//         int beforeRemovalCount = allOfflineData.length;
//         allOfflineData.removeWhere((e) => e.flatId.toString() == newFlatId);
//         log('Removed ${beforeRemovalCount - allOfflineData.length} record(s) with flat_id=$newFlatId');

//         // Add the new record(s)
//         allOfflineData.addAll(response.data!);
//         log('Records count after adding new: ${allOfflineData.length}');
//       } else {
//         log('⚠ Response data is null or empty. Skipping add.');
//       }

//       // Save updated list
//       String encodedData = jsonEncode(allOfflineData);
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, encodedData);
//       log('✅ Offline save success. Total records now: ${allOfflineData.length}');

//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel updated with COMPLETE state.');
//     } catch (e, stacktrace) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log('❌ ERROR in storeForOfflineUse: $e');
//       log('STACKTRACE: $stacktrace');
//     }

//     update();
//     log('===== storeForOfflineUse END =====');
//   }*/

//   /*
//   /// STORE DATA OFFLINE
//   Future<dynamic> storeForOfflineUse({
//     required double h,
//     required double w,
//     required BuildContext context,
//     required String flatId,
//   }) async {
//     log('flatId----------- $flatId');

//     _getOfflineHqiFlateResponseModel = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       OfflineHqiFlateResponseModel response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
//         "flat_id": flatId,
//         "user_id": preferences.getString(SharedPreference.userId) ?? "",
//       });

//       String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
//       log('isData::::::::::::::::${resData == null || resData.isEmpty}');

//       List<OfflineHQIData> allOfflineData = [];

//       if (resData != null && resData.isNotEmpty) {
//         // Decode the existing data, which is a list of lists.
//         var existingData = jsonDecode(resData);

//         if (existingData is List) {
//           // Iterate through each nested list and then each map within it.
//           for (var nestedList in existingData) {
//             if (nestedList is List) {
//               for (var item in nestedList) {
//                 if (item is Map<String, dynamic>) {
//                   allOfflineData.add(OfflineHQIData.fromJson(item));
//                 }
//               }
//             }
//           }
//         }
//       }

//       // Remove the old data for the same visit_id to prevent duplicates.
//       if (response.data != null && response.data!.isNotEmpty) {
//         allOfflineData.removeWhere((e) => e.visitId == response.data!.first.visitId);
//         // Add the new data.
//         allOfflineData.addAll(response.data!);
//       }

//       // Save the updated flattened list back to SharedPreferences.
//       preferences.putString(SharedPreference.hqiFlatsOfflineData, jsonEncode(allOfflineData));
//       successSnackBar("Success", 'Flat data has been saved offline successfully');

//       _getOfflineHqiFlateResponseModel = ApiResponse.complete(response);
//       log('_getOfflineHqiFlateResponseModel::::::::::::::::${_getOfflineHqiFlateResponseModel.data}');
//     } catch (e) {
//       _getOfflineHqiFlateResponseModel = ApiResponse.error(message: e.toString());
//       log("_getActivityChecklistApiResponse=ERROR=>$e");
//     }
//     update();
//   }*/

//   Future<void> saveForOfflineUse(BuildContext context, double h, double w, int length) {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: Center(
//             child: "Save Flat".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 "This Flat data saved successfully for the offline use. You can use Flat data for offline."
//                     .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 "Total saved Flats : $length".regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
//               ],
//             ),
//           ),
//           contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 color: appColor,
//                 height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 child: Center(
//                   child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
