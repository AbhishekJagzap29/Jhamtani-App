import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/fetch_observation_form_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/impact_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_category_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/submit_observation_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class AddObservationController extends GetxController {
  List<IssueTypeData> issueTypeList = [];
  List<IssueCategoryData> issueCategoryList = [];
  List<FetchObservationData> observationList = [];
  List<ImpactTypeData> impactTypeList = [];

  List<FetchObservationData> data = [];
  ApiResponse _issueCategoryResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get issueCategoryResponse => _issueCategoryResponse;


  /// Local storage key
  final String storageKey = SharedPreference.issueCategoriesWithTypes;
  final String observationCategoryStorageKey =
      SharedPreference.observationCategory;

  /// Get Issue Categories (check local storage first)
  Future<void> getIssueCategories() async {
    _issueCategoryResponse = ApiResponse.loading(message: 'Loading...');

    update();

    try {
      // 🔹 Step 1: Check local storage
      String? localData = preferences.getString(storageKey);
      if (localData != null && localData.isNotEmpty) {
        List<dynamic> decoded = jsonDecode(localData);
        issueCategoryList = decoded
            .map((item) => IssueCategoryData.fromJson(item['category']))
            .toList();
        _issueCategoryResponse = ApiResponse.complete(issueCategoryList);
        update();
        return; // Use local data
      }

      // 🔹 Step 2: If not exist, call API
      IssueCategoryResponseModel response =
          await ProjectRepo().issueCategoryRepo();
      if (response.data != null && response.data!.isNotEmpty) {
        issueCategoryList = response.data!;
        _issueCategoryResponse = ApiResponse.complete(issueCategoryList);

        // Save categories in local storage with empty types
        List<Map<String, dynamic>> storageData = issueCategoryList
            .map((cat) => {
                  "category": cat.toJson(),
                  "types": <Map<String, dynamic>>[],
                })
            .toList();
        preferences.putString(storageKey, jsonEncode(storageData));
      } else {
        issueCategoryList = [];
        _issueCategoryResponse =
            ApiResponse.error(message: 'No issue categories found');
      }
    } catch (e, st) {
      print("Error fetching issue categories: $e");
      print("Stacktrace: $st");
      _issueCategoryResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  /// Get Issue Types for selected category
  Future<void> getIssueTypes(
      {required int categoryId, required String categoryName}) async {
    _issueTypeResponse = ApiResponse.loading(message: 'Loading issue types...');
    update();

    try {
      // 🔹 Step 1: Check local storage first
      String? localData = preferences.getString(storageKey);
      if (localData != null && localData.isNotEmpty) {
        List<dynamic> decoded = jsonDecode(localData);
        var categoryItem = decoded.firstWhere(
            (item) => item['category']['name'] == categoryName,
            orElse: () => null);

        if (categoryItem != null &&
            categoryItem['types'] != null &&
            (categoryItem['types'] as List).isNotEmpty) {
          issueTypeList = (categoryItem['types'] as List)
              .map((e) => IssueTypeData.fromJson(e))
              .toList();
          _issueTypeResponse = ApiResponse.complete(issueTypeList);
          update();
          return; // Use stored types
        }
      }

      // 🔹 Step 2: Call API if types not in local storage
      IssueTypeResponseModel response = await ProjectRepo().issueTypeRepo(
        body: {"issue_category_id": categoryId},
      );

      if (response.data != null && response.data!.isNotEmpty) {
        issueTypeList = response.data!;
        _issueTypeResponse = ApiResponse.complete(issueTypeList);

        // Update local storage
        if (localData != null && localData.isNotEmpty) {
          List<dynamic> decoded = jsonDecode(localData);
          for (var item in decoded) {
            if (item['category']['name'] == categoryName) {
              item['types'] = issueTypeList.map((e) => e.toJson()).toList();
              break;
            }
          }
          preferences.putString(storageKey, jsonEncode(decoded));
        }
      } else {
        issueTypeList = [];
        _issueTypeResponse = ApiResponse.error(message: 'No issue types found');
      }
    } catch (e, st) {
      print("Error fetching issue types: $e");
      print("Stacktrace: $st");
      _issueTypeResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  ApiResponse _issueTypeResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get issueTypeResponse => _issueTypeResponse;

  ApiResponse _observationCategoryResponse =
      ApiResponse.initial(message: 'Initialization');



  ApiResponse _impactTypeResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get impactTypeResponse => _impactTypeResponse;

  final String impactTypeStorageKey = SharedPreference.impactTypes;

  Future getImpactTypes() async {
    _impactTypeResponse = ApiResponse.loading(
      message: 'Loading impact types...',
    );

    update();

    try {
      // Step 1: Check local storage
      String? localData = preferences.getString(impactTypeStorageKey);

      if (localData != null && localData.isNotEmpty) {
        List<dynamic> decoded = jsonDecode(localData);

        impactTypeList =
            decoded.map((e) => ImpactTypeData.fromJson(e)).toList();

        _impactTypeResponse = ApiResponse.complete(
          impactTypeList,
        );

        update();
        return;
      }

      // Step 2: Call Impact Type API
      final response = await ProjectRepo().impactTypeRepo();

      if (response.data != null && response.data!.isNotEmpty) {
        impactTypeList = response.data!;

        _impactTypeResponse = ApiResponse.complete(
          impactTypeList,
        );

        // Step 3: Save data locally
        preferences.putString(
          impactTypeStorageKey,
          jsonEncode(
            response.data!.map((e) => e.toJson()).toList(),
          ),
        );
      } else {
        impactTypeList = [];

        _impactTypeResponse = ApiResponse.error(
          message: 'No impact types found',
        );
      }
    } catch (e, st) {
      print("Error fetching impact types: $e");
      print("Stacktrace: $st");

      impactTypeList = [];

      _impactTypeResponse = ApiResponse.error(
        message: e.toString(),
      );
    }

    update();
  }

  ApiResponse _submitObservationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get submitObservationResponse => _submitObservationResponse;

  Future<void> submitObservation({
    required int locationId,
    required String date,
    required String name,
    required String category,
    required String issueType,
    required String description,
    required String impact,
    required String userId,
    required String remark,
    String? state,
    int? observationId,
    required String targetDate,
    required List<File> beforeImages, // ✅ Multiple images
    required List<File> afterImages,
    String? observationCategory,
    String? impactType,
    // ✅ Multiple images
  }) async {
    _submitObservationResponse = ApiResponse.loading(message: 'Submitting...');
    update();

    log('🔹 Starting observation submission');
    log('🔹 Location ID: $locationId, Date: $date, Name: $name');
    log('🔹 Category: $category, Issue Type: $issueType, Impact: $impact');
    log('🔹 Observation ID: $observationId, State: $state, Target Date: $targetDate');
    log('🔹 Description: $description');
    log('🔹 Remark: $remark');
    log('🔹 Before Images Count: ${beforeImages.length}, After Images Count: ${afterImages.length}');
    log('preferences.getString(SharedPreference.userType) == "hqi_maker"::::::::::::::::${preferences.getString(SharedPreference.userType) == " hqi_maker"}');

    try {
      List<String> base64Images = [];
      for (var file in beforeImages) {
        log('🔹 Processing before image: ${file.path}');

        if (!file.path.contains('http://')) {
          if (file.existsSync()) {
            final bytes = file.readAsBytesSync();
            final base64Image = base64Encode(bytes);
            base64Images.add(base64Image);
            log('✅ before image converted to base64 (${bytes.length} bytes)');
          } else {
            // base64Images.add(file);
            log('⚠️ Skipping before image: ${file.path}');
          }
        }
      }

      /// ✅ Convert afterImages to base64
      List<String> base64Images2 = [];
      for (var file in afterImages) {
        log('🔹 Processing after image: ${file.path}');

        if (!file.path.contains('http://')) {
          if (file.existsSync()) {
            final bytes = file.readAsBytesSync();
            final base64Image = base64Encode(bytes);
            base64Images2.add(base64Image);
            log('✅ After image converted to base64 (${bytes.length} bytes)');
          } else {
            // base64Images2.add(file);
            log('⚠️ Skipping after image: ${file.path}');
          }
        }
      }

      // Build request body
      Map<String, dynamic> body = {
        "location_id": locationId,
        "date": date,
        "name": name,
        "issue_category_id": category,
        "issue_type_id": issueType,
        "description": description,
        "impact": impact,
        "impact_type": impactType,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
        "observation_id": observationId,
        "state": state,
        "target_date": targetDate,
        "remark": remark,
     //   "observation_category": observationCategory,
   "checker_uploaded_img": (preferences
                    .getString(SharedPreference.userType)
                    ?.contains("hqi_maker") ??
                false)
            ? []
            : base64Images + base64Images2,
        "maker_uploaded_img": (preferences
                    .getString(SharedPreference.userType)
                    ?.contains("hqi_maker") ??
                false)
            ? base64Images + base64Images2
            : [],
      };

      log('🔹 Request body prepared: ${body.keys.toList()}');
      log('🔹 Checker images count: ${base64Images.length}, Maker images count: ${base64Images2.length}');

      // Submit to API
      SubmitObservationResponseModel response =
          await ProjectRepo().submitObservationFormRepo(body: body);
      log('🔹 API response received: Status=${response.status}, Message=${response.message}');

      if (response.status == "SUCCESS") {
        log('✅ Observation submitted successfully');
        _submitObservationResponse = ApiResponse.complete(
            (message: "Observation submitted successfully"));
      } else {
        log('❌ Observation submission failed: ${response.message}');
        errorSnackBar("Failed", response.message ?? "Something went wrong");
        _submitObservationResponse =
            ApiResponse.error(message: response.message ?? '');
      }
    } catch (e, stackTrace) {
      log('❌ Submit Observation Error: $e');
      log('📄 StackTrace: $stackTrace');
      _submitObservationResponse = ApiResponse.error(message: e.toString());
    }

    log('🔹 Submission process finished');
    update();
  }

///// fetch observation data
  ApiResponse _observationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get observationResponse => _observationResponse;

  Future<void> fetchObservationform({
    required int locationId,
    int? flatId,
  }) async {
    _observationResponse =
        ApiResponse.loading(message: 'Loading observation data...');
    update();

    try {
      int? finalFlatId = flatId;

      if (finalFlatId == null) {
        String? existingData =
            preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';

        if (existingData.isNotEmpty) {
          try {
            List<dynamic> decodedData = jsonDecode(existingData);
            List<List<OfflineHQIData>> allOfflineData =
                decodedData.map((sublist) {
              if (sublist is List) {
                return sublist.map<OfflineHQIData>((item) {
                  return OfflineHQIData.fromJson(
                      Map<String, dynamic>.from(item));
                }).toList();
              }
              return <OfflineHQIData>[];
            }).toList();

            // Find the flat_id for this locationId
            for (var flatList in allOfflineData) {
              for (var flat in flatList) {
                for (var location in flat.locationData ?? []) {
                  if (location.locationId == locationId) {
                    finalFlatId = flat.flatId;
                    break;
                  }
                }
                if (finalFlatId != null) break;
              }
              if (finalFlatId != null) break;
            }
          } catch (e) {
            log('❌ Error decoding offline data: $e');
          }
        }
      }

      if (finalFlatId == null) {
        log('❌ Could not find flat_id for locationId: $locationId');
        _observationResponse = ApiResponse.error(
            message: 'Could not determine flat for this location');
        update();
        return;
      }

      final request = {
        "flat_id": finalFlatId,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
      };

      // 🔹 REPLACED: Using new API for Home Inspection
      OfflineHqiFlateResponseModel response =
          await ProjectRepo().getHQIFlatsOfflineRepo(body: request);
      print('response:::::::::fetchObservationform:::::::${response.toJson()}');

      if (response.status == "SUCCESS" &&
          response.data != null &&
          response.data!.isNotEmpty) {
        // 🔹 Convert OfflineHQIData to FetchObservationData for compatibility
        observationList = [];
        for (var flatData in response.data!) {
          for (var location in flatData.locationData ?? []) {
            if (location.locationId == locationId) {
              // Convert OfflineObservationData to FetchObservationData
              for (var obs in location.observations ?? []) {
                try {
                  observationList.add(FetchObservationData(
                    observationId: obs.observationId,
                    locationId: obs.locationId,
                    projectId: obs.projectId,
                    towerId: obs.towerId,
                    flatId: obs.flatId,
                    issueCategoryId: obs.issueCategoryId,
                    issueTypeId: obs.issueTypeId,
                    remark: obs.remark,
                    date: obs.date != null
                        ? "${obs.date!.year.toString().padLeft(4, '0')}-${obs.date!.month.toString().padLeft(2, '0')}-${obs.date!.day.toString().padLeft(2, '0')}"
                        : null,
                    targetDate: obs.targetDate != null
                        ? "${obs.targetDate!.year.toString().padLeft(4, '0')}-${obs.targetDate!.month.toString().padLeft(2, '0')}-${obs.targetDate!.day.toString().padLeft(2, '0')}"
                        : null,
                    userId: obs.userId,
                    userType: obs.userType,
                    companyId: obs.companyId,
                    state: obs.state,
                    description: obs.description,
                    issueCategoryName: obs.issueCategoryName,
                    issueTypeName: obs.issueTypeName,
                    activity_type_status: obs.activity_type_status,
                    color: obs.color,
                    impact: obs.impact,
                    imgData: obs.imgData,
                    sequence: obs.sequence,
                    visitDetails: obs.visitDetails,
                    checkerSubmitted: obs.checkerSubmitted,
                    makerSubmitted: obs.makerSubmitted,
                //    observationCategory: obs.observationCategory ?? "",
                    impactType: obs.impactType ?? "",
                  ));
                } catch (e) {
                  print('❌ Error converting observation: $e');
                }
              }
              break;
            }
          }
        }

        _observationResponse = ApiResponse.complete(observationList);
      } else {
        observationList = [];
        _observationResponse =
            ApiResponse.error(message: 'No observation data found');
      }
    } catch (e, stacktrace) {
      print("Error fetching observation data: $e");
      print("Stacktrace: $stacktrace");
      _observationResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  ApiResponse _resubmitObservationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get resubmitObservationResponse => _resubmitObservationResponse;

  Future<void> resubmitObservation({
    required int locationId,
    required String date,
    required String name,
    required String category,
    required String issueType,
    required String description,
    required String impact,
    required String userId,
    required List<File> imageFiles,
    String? observationCategory,
    String?impactType,
  }) async {
    _submitObservationResponse = ApiResponse.loading(message: 'Submitting...');
    update();

    try {
      /// ✅ Convert images to base64
      List<String> base64Images = [];
      for (var file in imageFiles) {
        if (!file.path.contains('http://') && file.existsSync()) {
          final bytes = file.readAsBytesSync();
          final base64Image = base64Encode(bytes);
          base64Images.add(base64Image);
        }
      }

      Map<String, dynamic> body = {
        "location_id": locationId,
        "date": date,
        "name": name,
        "issue_category_id": category,
        "issue_type_id": issueType,
        "description": description,
        "impact": impact,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
      //  "observation_category": observationCategory,
        "impact_type": impactType,
        "checker_uploaded_img": (preferences
                    .getString(SharedPreference.userType)
                    ?.contains("hqi_maker") ??
                false)
            ? []
            : base64Images,
        "maker_uploaded_img": (preferences
                    .getString(SharedPreference.userType)
                    ?.contains("hqi_maker") ??
                false)
            ? base64Images
            : [],
      };

      SubmitObservationResponseModel response =
          await ProjectRepo().submitObservationFormRepo(
        body: body,
      );

      if (response.status == "SUCCESS") {
        // successSnackBar("Success", "Observation submitted successfully");
        _submitObservationResponse = ApiResponse.complete(
            (message: "Observation submitted successfully"));
      } else {
        errorSnackBar("Failed", response.message ?? "Something went wrong");
        _submitObservationResponse =
            ApiResponse.error(message: response.message ?? '');
      }
    } catch (e) {
      log("Submit Observation Error: $e");
      _submitObservationResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }

  // 🔹 NEW METHOD: Get HQI Flats Offline Data
  Future<dynamic> getHQIFlatsOfflineRepo({Map<String, dynamic>? body}) async {
    try {
      log('🔹 Calling getHQIFlatsOfflineRepo with body: $body');

      final response = await ProjectRepo().getHQIFlatsOfflineRepo(body: body);

      log('🔹 getHQIFlatsOfflineRepo response: ${response.status}');

      return response;
    } catch (e) {
      log('❌ Error in getHQIFlatsOfflineRepo: $e');
      throw e;
    }
  }
}
