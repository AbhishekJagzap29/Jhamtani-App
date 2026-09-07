import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/add_observation_controller.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/impact_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_category_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';


class AddObservationScreen extends StatefulWidget {
  const AddObservationScreen({Key? key}) : super(key: key);

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController issueDescController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  bool isLoading = false;
  String? selectedCategory;
  String? selectedIssueType;
  String? selectedAssignTo;
  String impact = 'low';
  File? capturedImage;
  String? selectedCategoryId;
  String? selectedIssueTypeId;
  String? locationName;
  int? locationId;
  String? state;
  int? observationId;
  String? userId;
  // String? flatId;
  bool isOfflineMode = false;
  final List<String> imageList = [];

  String? selectedObservationCategory;
  String? selectedImpactType;
  // 🔹 REMOVED: connectivitySubscription variable - no longer needed

  final AddObservationController observationController =
      Get.put(AddObservationController());

  @override
  void initState() {
    super.initState();

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    observationController.getImpactTypes();
    observationController.getIssueCategories();
    locationId = Get.arguments['location_id'];
    locationName = Get.arguments['location_name'];
    locationController.text = locationName ?? '';
    isOfflineMode = isFlatInLocalStorage(
      projectId: Get.arguments['project_id'] ?? '',
      towerId: Get.arguments['tower_id'] ?? '',
      flatId: Get.arguments['flat_id'] ?? '',
    );
    log('isOfflineMode::::::::::::::::${isOfflineMode}');
  }

  bool isFlatInLocalStorage({
    required String projectId,
    required String towerId,
    required String flatId,
  }) {
    log('isOfflineMode:::::isFlatInLocalStorage::::::::::: ${isOfflineMode} = ${projectId} : ${towerId} : ${flatId}');

    String? resData =
        preferences.getString(SharedPreference.hqiFlatsOfflineData);

    if (resData != null && resData.isNotEmpty) {
      try {
        List<dynamic> decodedData = jsonDecode(resData);

        // Convert JSON -> List<List<OfflineHQIData>>
        List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        // 🔍 Check if any sublist matches projectId, towerId, flatId
        for (var sublist in allOfflineData) {
          if (sublist.isNotEmpty) {
            var first = sublist.first;
            if (first.projectId.toString() == projectId &&
                first.towerId.toString() == towerId &&
                first.flatId.toString() == flatId) {
              return true; // ✅ Flat exists in local storage
            }
          }
        }
      } catch (e) {
        log("❌ Error checking local flat: $e");
      }
    }

    return false; // ❌ Flat not found
  }

  Future<void> _saveOfflineData() async {
    try {
      log('🔹 Starting offline data save process...');

      log("========================================");
      log("OFFLINE IMPACT TYPE DEBUG");
      log("selectedImpactType = $selectedImpactType");
      log("selectedImpactType is null = ${selectedImpactType == null}");
      log("selectedImpactType is empty = ${selectedImpactType?.isEmpty}");
      log("========================================");

      // 🔹 Step 1: Validate required fields before saving offline
      if (dateController.text.trim().isEmpty) {
        errorSnackBar("Required Field", "Please select Date");
        return;
      }
      if (targetDateController.text.trim().isEmpty) {
        errorSnackBar("Required Field", "Please select Target Date");
        return;
      }
      if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
        errorSnackBar("Required Field", "Please select Issue Category");
        return;
      }
      if (selectedIssueTypeId == null || selectedIssueTypeId!.isEmpty) {
        errorSnackBar("Required Field", "Please select Issue Type");
        return;
      }

      if (selectedImpactType == null ||
          selectedImpactType.toString().trim().isEmpty) {
        errorSnackBar("Required", "Please select Impact Type");
        return;
      }

      if (issueDescController.text.trim().isEmpty) {
        errorSnackBar("Required Field", "Please enter Issue Description");
        return;
      }

      log('🔹 Validation passed, creating image data...');
      List<ObservationImageData> imgDataList = [];
      for (String imagePath in imageList) {
        if (imagePath.isNotEmpty && !imagePath.contains('http://')) {
          final file = File(imagePath);
          if (file.existsSync()) {
            String userType =
                preferences.getString(SharedPreference.userType) ?? "";
            imgDataList.add(ObservationImageData(
              imgUrl: imagePath, // Store local path
              userChecker: userType == "hqi_checker",
              checkerUploadedImg: userType == "hqi_checker" ? imagePath : null,
              userMaker: userType.contains("hqi_maker") ? 1 : 0,
              makerUploadedImg:
                  userType.contains("hqi_maker") ? imagePath : null,
            ));
          }
        }
      }

      log('🔹 Created ${imgDataList.length} image data entries');

      // 🔹 Step 3: Create new observation data
      OfflineObservationData newObservation = OfflineObservationData(
        visitDetails: VisitDetails(
          visitName:
              "Site Visit", // You can get this from arguments if available
          sequence: 1,
          visitId: 0, // Will be set when syncing
        ),
        imgData: imgDataList,
        observationId: 0, // New observation, will get ID when synced
        name: locationName ?? locationController.text.trim(),
        state: state ?? "pending",
        date: dateController.text.isNotEmpty
            ? DateTime.parse(dateController.text.trim())
            : DateTime.now(),
        targetDate: targetDateController.text.isNotEmpty
            ? DateTime.parse(targetDateController.text.trim())
            : DateTime.now(),
        issueCategoryId: int.tryParse(selectedCategoryId ?? "0") ?? 0,
        issueCategoryName: selectedCategory ?? "",
        issueTypeId: int.tryParse(selectedIssueTypeId ?? "0") ?? 0,
        issueTypeName: selectedIssueType ?? "",
        description: issueDescController.text.trim(),
        remark: remarkController.text.trim(),
        impact: impact,
        locationId: locationId ?? 0,
        impactType: selectedImpactType,
        observationCategory: selectedObservationCategory,
        checkerSubmitted:
            preferences.getString(SharedPreference.userType) == "hqi_checker",
        makerSubmitted: preferences
                .getString(SharedPreference.userType)
                ?.contains("hqi_maker") ??
            false,

        //  makerSubmitted: preferences.getString(SharedPreference.userType) == "hqi_maker",
        color: "red", // New observation - pending
        locationOverallColor: "red",
        // 🔹 Set sync tracking fields for newly added observation
        isNewlyAdded: true,
        isUpdated: false,
        lastModified: DateTime.now(),
        syncStatus: "pending",
        syncErrorMessage: null,
        // 🔹 Additional fields from FetchObservationData
        projectId:
            int.tryParse(Get.arguments['project_id']?.toString() ?? "0") ?? 0,
        towerId:
            int.tryParse(Get.arguments['tower_id']?.toString() ?? "0") ?? 0,
        flatId: int.tryParse(Get.arguments['flat_id']?.toString() ?? "0") ?? 0,
        userId: int.tryParse(
                preferences.getString(SharedPreference.userId) ?? "0") ??
            0,
        userType: preferences.getString(SharedPreference.userType) ?? "",
        companyId:
            0, // Set to 0 since there's no SharedPreference key for companyId
        activity_type_status: false,
        sequence: 1,
      );

      log('🔹 Created observation data for locationId: ${locationId}');

      // 🔹 Step 4: Get existing offline HQI data
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
      List<List<OfflineHQIData>> allOfflineData = [];

      if (existingData.isNotEmpty) {
        try {
          List<dynamic> decodedData = jsonDecode(existingData);
          allOfflineData = decodedData.map((sublist) {
            if (sublist is List) {
              return sublist.map<OfflineHQIData>((item) {
                return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
              }).toList();
            }
            return <OfflineHQIData>[];
          }).toList();

          log('🔹 Loaded existing offline data with ${allOfflineData.length} flat lists');
        } catch (e) {
          log('❌ Error decoding existing offline data: $e');
        }
      } else {
        log('🔹 No existing offline data found');
      }

      // 🔹 Step 5: Find the correct flat and location to add observation
      bool observationAdded = false;
      for (var flatList in allOfflineData) {
        for (var flat in flatList) {
          log('🔹 Checking flat: ${flat.flatId} with ${flat.locationData?.length ?? 0} locations');
          // Check if this flat contains the location we're looking for
          for (var location in flat.locationData ?? []) {
            log('🔹 Checking location: ${location.locationId} vs target: ${locationId}');
            if (location.locationId == locationId) {
              log('🔹 Found matching location! Adding observation...');
              // Add observation to this location
              location.observations ??= [];
              location.observations!.add(newObservation);

              // Update counts
              location.observationCount = (location.observationCount ?? 0);
              location.pendingObservationCount =
                  (location.pendingObservationCount ?? 0);

              if (preferences.getString(SharedPreference.userType) ==
                  "hqi_checker") {
                location.checkerPendingCount =
                    (location.checkerPendingCount ?? 0);
              } else if (preferences
                      .getString(SharedPreference.userType)
                      ?.contains("hqi_maker") ??
                  false)

              //    (preferences.getString(SharedPreference.userType) == "hqi_maker")
              {
                location.makerPendingCount = (location.makerPendingCount ?? 0);
              }

              // Update flat level counts
              flat.totalObservationCount = (flat.totalObservationCount ?? 0);
              flat.pendingObservationCount =
                  (flat.pendingObservationCount ?? 0);

              observationAdded = true;
              log('🔹 Observation added successfully to location');
              break;
            }
          }
          if (observationAdded) break;
        }
        if (observationAdded) break;
      }

      // 🔹 Step 6: Save updated data back to localStorage
      if (observationAdded) {
        String updatedData = jsonEncode(allOfflineData
            .map((sublist) => sublist.map((item) => item.toJson()).toList())
            .toList());

        await preferences.putString(
            SharedPreference.hqiFlatsOfflineData, updatedData);

        final checkData =
            preferences.getString(SharedPreference.hqiFlatsOfflineData);

        log("========================================");
        log("OFFLINE STORAGE AFTER SAVE");
        log(checkData ?? "NULL");
        log("========================================");

        log('✅ Observation added to offline data successfully');

        // 🔹 Step 7: Handle observation data after save (update local storage or call API)
        await _handleObservationDataAfterSave();

        // 🔹 Step 8: Clear form BEFORE navigation
        _clearForm();

        // Show success message
        successSnackBar("Offline", "Observation saved for offline use.");

        // Navigate back to observations screen with correct IDs
        Get.offNamed(Routes.flatSubLocationScreen, arguments: {
          "location_id": locationId,
          "location_name": locationName,
          "project_id": Get.arguments['project_id']?.toString() ?? "0",
          "tower_id": Get.arguments['tower_id']?.toString() ?? "0",
          "flat_id": Get.arguments['flat_id']?.toString() ?? "0",
          "tower_name": Get.arguments['tower_name'] ?? "",
          "name": Get.arguments['name'] ?? "",
          "offline": true,
        });
      } else {
        log('❌ Could not find matching flat/location to add observation');
        log('❌ Available locations: ${allOfflineData.expand((flatList) => flatList.expand((flat) => flat.locationData ?? [])).map((loc) => loc.locationId).toList()}');
        errorSnackBar("Error",
            "Could not find matching location in offline data. Please try again.");
      }
    } catch (e) {
      log('❌ Error saving offline observation data: $e');
      errorSnackBar(
          "Error", "Failed to save observation offline. Please try again.");
    }
  }

  // 🔹 Helper method to clear form
  void _clearForm() {
    log('🔹 Clearing form data...');

    // Clear all text controllers
    dateController.clear();
    targetDateController.clear();
    issueDescController.clear();
    remarkController.clear();
    selectedImpactType = null;

    // Reset all variables
    selectedCategory = null;
    selectedIssueType = null;
    selectedCategoryId = null;
    selectedIssueTypeId = null;
    impact = 'low';

    // Clear image list
    imageList.clear();

    // Reset other variables
    capturedImage = null;
    selectedAssignTo = null;
    state = null;
    observationId = null;
    userId = null;
    // isOfflineMode = false;

    // Force UI update
    setState(() {});

    log('✅ Form cleared successfully');
  }

  // 🔹 NEW METHOD: Handle observation data after saving offline
  Future<void> _handleObservationDataAfterSave() async {
    try {
      log('🔹 Starting to handle observation data after save...');

      // Get the required IDs from previous routes
      String projectId = Get.arguments['project_id']?.toString() ?? "0";
      String towerId = Get.arguments['tower_id']?.toString() ?? "0";
      String flatId = Get.arguments['flat_id']?.toString() ?? "0";

      log('🔹 IDs from arguments: projectId=$projectId, towerId=$towerId, flatId=$flatId');

      // Check if flat data exists in local storage
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
      bool flatExistsInLocalStorage = false;

      if (existingData.isNotEmpty) {
        try {
          List<dynamic> decodedData = jsonDecode(existingData);
          List<List<OfflineHQIData>> allOfflineData =
              decodedData.map((sublist) {
            if (sublist is List) {
              return sublist.map<OfflineHQIData>((item) {
                return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
              }).toList();
            }
            return <OfflineHQIData>[];
          }).toList();

          // Check if flat exists in local storage
          for (var flatList in allOfflineData) {
            if (flatList.isNotEmpty) {
              var first = flatList.first;
              if (first.projectId.toString() == projectId &&
                  first.towerId.toString() == towerId &&
                  first.flatId.toString() == flatId) {
                flatExistsInLocalStorage = true;
                log('✅ Flat data found in local storage');
                break;
              }
            }
          }
        } catch (e) {
          log('❌ Error checking local storage: $e');
        }
      }

      if (flatExistsInLocalStorage) {
        // 🔹 Step 1: Update existing local storage data
        log('🔹 Updating existing local storage data...');
        await _updateLocalStorageData(projectId, towerId, flatId);
      } else {
        // 🔹 Step 2: Call /get/hqi/flats/offline API to get fresh data
        log('🔹 Flat data not found in local storage, calling API...');
        try {
          await _fetchAndStoreFlatData(flatId);
        } catch (apiError) {
          log('❌ API call failed: $apiError');
          // If API fails, just log the error but don't show error to user
          // The observation is already saved locally, so the user can continue
          log('⚠ API call failed but observation is saved locally. User can continue.');
        }
      }

      log('✅ Observation data handling completed');
    } catch (e) {
      log('❌ Error handling observation data after save: $e');
      // Don't show error to user since the observation is already saved
      log('⚠ Error in data handling but observation is saved locally.');
    }
  }

  // 🔹 Helper method to update local storage data
  Future<void> _updateLocalStorageData(
      String projectId, String towerId, String flatId) async {
    try {
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';

      if (existingData.isNotEmpty) {
        List<dynamic> decodedData = jsonDecode(existingData);
        List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        // Find and update the specific flat data
        for (int i = 0; i < allOfflineData.length; i++) {
          var flatList = allOfflineData[i];
          if (flatList.isNotEmpty) {
            var first = flatList.first;
            if (first.projectId.toString() == projectId &&
                first.towerId.toString() == towerId &&
                first.flatId.toString() == flatId) {
              // Update the flat data with new observation counts
              for (var visit in flatList) {
                for (var location in visit.locationData ?? []) {
                  if (location.locationId == locationId) {
                    // Update observation counts
                    location.observationCount =
                        (location.observationCount ?? 0);
                    location.pendingObservationCount =
                        (location.pendingObservationCount ?? 0);

                    if (preferences.getString(SharedPreference.userType) ==
                        "hqi_checker") {
                      location.checkerPendingCount =
                          (location.checkerPendingCount ?? 0);
                    } else if (preferences
                            .getString(SharedPreference.userType)
                            ?.contains("hqi_maker") ??
                        false)

                    // (preferences.getString(SharedPreference.userType) == "hqi_maker")
                    {
                      location.makerPendingCount =
                          (location.makerPendingCount ?? 0);
                    }

                    // Update flat level counts
                    visit.totalObservationCount =
                        (visit.totalObservationCount ?? 0);
                    visit.pendingObservationCount =
                        (visit.pendingObservationCount ?? 0);

                    log('✅ Updated local storage data for locationId: $locationId');
                    break;
                  }
                }
              }

              // Save updated data back to local storage
              String updatedData = jsonEncode(allOfflineData
                  .map((sublist) =>
                      sublist.map((item) => item.toJson()).toList())
                  .toList());

              await preferences.putString(
                  SharedPreference.hqiFlatsOfflineData, updatedData);
              log('✅ Local storage data updated successfully');
              break;
            }
          }
        }
      }
    } catch (e) {
      log('❌ Error updating local storage data: $e');
      throw e;
    }
  }

  // 🔹 Helper method to fetch and store flat data from API
  Future<void> _fetchAndStoreFlatData(String flatId) async {
    try {
      log('🔹 Calling /get/hqi/flats/offline API for flatId: $flatId');

      // Call the API to get fresh flat data
      final response = await observationController.getHQIFlatsOfflineRepo(
        body: {
          "flat_id": flatId,
          "user_id":
              int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
        },
      );

      if (response.status == "SUCCESS" &&
          response.data != null &&
          response.data!.isNotEmpty) {
        log('✅ API call successful, storing flat data...');

        // Get existing data
        String? existingData =
            preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
        List<List<OfflineHQIData>> allOfflineData = [];

        if (existingData.isNotEmpty) {
          try {
            List<dynamic> decodedData = jsonDecode(existingData);
            allOfflineData = decodedData.map((sublist) {
              if (sublist is List) {
                return sublist.map<OfflineHQIData>((item) {
                  return OfflineHQIData.fromJson(
                      Map<String, dynamic>.from(item));
                }).toList();
              }
              return <OfflineHQIData>[];
            }).toList();
          } catch (e) {
            log('❌ Error decoding existing data: $e');
          }
        }

        // Remove any existing data for this flat
        allOfflineData.removeWhere((sublist) =>
            sublist.isNotEmpty && sublist.first.flatId.toString() == flatId);

        // Add new flat data
        allOfflineData.add(response.data!);

        // Save updated data
        String updatedData = jsonEncode(allOfflineData
            .map((sublist) => sublist.map((item) => item.toJson()).toList())
            .toList());

        await preferences.putString(
            SharedPreference.hqiFlatsOfflineData, updatedData);
        log('✅ Flat data stored successfully from API');
      } else {
        log('❌ API call failed: ${response.message}');
        throw Exception('Failed to fetch flat data: ${response.message}');
      }
    } catch (e) {
      log('❌ Error fetching and storing flat data: $e');
      throw e;
    }
  }

  Future<void> _submitObservation() async {
    // if (dateController.text.trim().isEmpty) {
    //   errorSnackBar("Required", "Please select Date");
    //   return;
    // }

    // if (targetDateController.text.trim().isEmpty) {
    //   errorSnackBar("Required", "Please select Target Date");
    //   return;
    // }

    if (selectedCategoryId == null || selectedCategoryId!.trim().isEmpty) {
      errorSnackBar("Required", "Please select Issue Category");
      return;
    }

    if (selectedIssueTypeId == null || selectedIssueTypeId!.trim().isEmpty) {
      errorSnackBar("Required", "Please select Issue Type");
      return;
    }

    if (selectedImpactType == null ||
        selectedImpactType.toString().trim().isEmpty) {
      errorSnackBar("Required", "Please select Impact Type");
      return;
    }

    if (issueDescController.text.trim().isEmpty) {
      errorSnackBar("Required", "Please Enter Description");
      return;
    }

    if (imageList.isEmpty) {
      errorSnackBar("Required", "Please attach least one image");
      return;
    }

    for (final imagePath in imageList) {
      final file = File(imagePath);

      if (await file.exists()) {
        final sizeInBytes = await file.length();
        final sizeInKB = sizeInBytes / 1024;
        final sizeInMB = sizeInKB / 1024;

        log(
          "📤 IMAGE SENT TO BACKEND: "
          "${path.basename(imagePath)} | "
          "${sizeInKB.toStringAsFixed(2)} KB | "
          "${sizeInMB.toStringAsFixed(2)} MB",
        );
      }
    }

    isLoading = true;
    setState(() {});

    await observationController.submitObservation(
      category: selectedCategoryId ?? "",
      issueType: selectedIssueTypeId ?? "",
      description: issueDescController.text.trim(),
      impact: impact,
      name: locationName ?? locationController.text.trim(),
      date: dateController.text.trim(),
      locationId: locationId!,
      userId: userId ?? "",
      targetDate: targetDateController.text.trim(),
      remark: remarkController.text.trim(),
      beforeImages: imageList.map((path) => File(path)).toList(),
      afterImages: [],
      observationCategory: selectedObservationCategory,
      impactType: selectedImpactType,
    );

    if (observationController.submitObservationResponse.status ==
        Status.COMPLETE) {
      log("Observation submitted successfully online");
      successSnackBar("Success", "Observation submitted successfully");

      // Clear form before navigation
      _clearForm();

      isLoading = false;
      setState(() {});
      Get.offNamed(Routes.flatSubLocationScreen, arguments: {
        "location_id": locationId,
        "location_name": locationName,
        "project_id": Get.arguments['project_id']?.toString() ?? "0",
        "tower_id": Get.arguments['tower_id']?.toString() ?? "0",
        "flat_id": Get.arguments['flat_id']?.toString() ?? "0",
        "tower_name": Get.arguments['tower_name'] ?? "",
        "name": Get.arguments['name'] ?? "",
        "offline": false,
      });
    } else if (observationController.submitObservationResponse.status ==
        Status.ERROR) {
      log("Error submitting observation: ${observationController.submitObservationResponse.message}");
      isLoading = false;
      setState(() {});
      errorSnackBar(
        "Error",
        observationController.submitObservationResponse.message ??
            "Submission failed",
      );
    }
  }

  Future<bool> checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<String?> _compressImage(String imagePath) async {
    try {
      final File originalFile = File(imagePath);

      if (!await originalFile.exists()) {
        log("Image file does not exist: $imagePath");
        return null;
      }

      final Directory tempDir = await getTemporaryDirectory();

      final String targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: 60,
        minWidth: 1280,
        minHeight: 1280,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        log("Image compression failed");
        return null;
      }

      final File finalFile = File(compressedFile.path);

      final int originalSize = await originalFile.length();
      final int compressedSize = await finalFile.length();

      log(
        "Original image size: "
        "${(originalSize / 1024).toStringAsFixed(2)} KB",
      );

      log(
        "Compressed image size: "
        "${(compressedSize / 1024).toStringAsFixed(2)} KB",
      );

      return finalFile.path;
    } catch (e) {
      log("Image compression error: $e");
      return null;
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo == null) {
      return;
    }

    // Open image capture/edit screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCaptureScreen(
          image: File(photo.path),
          title: locationName ?? "Captured Image",
        ),
      ),
    );

    if (result != null && result is Map && result["image"] != null) {
      final String imagePath = result["image"].toString();

      log("Image returned from ImageCaptureScreen: $imagePath");

      // Compress the final image
      final String? compressedPath = await _compressImage(imagePath);

      if (compressedPath == null) {
        errorSnackBar(
          "Error",
          "Unable to compress image",
        );
        return;
      }

      // Add compressed image to imageList
      setState(() {
        imageList.add(compressedPath);
      });

      log("Compressed image added to imageList");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (photo == null) {
      return;
    }

    // Open image capture/edit screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCaptureScreen(
          image: File(photo.path),
          title: locationName ?? "Gallery Image",
        ),
      ),
    );

    if (result != null && result is Map && result["image"] != null) {
      final String imagePath = result["image"].toString();

      log("Image returned from ImageCaptureScreen: $imagePath");

      // Compress the final edited image
      final String? compressedPath = await _compressImage(imagePath);

      if (compressedPath == null) {
        errorSnackBar(
          "Error",
          "Unable to compress image",
        );
        return;
      }

      // Add compressed image to imageList
      setState(() {
        imageList.add(compressedPath);
      });

      log("Compressed gallery image added to imageList");
    }
  }

  // Future<void> _pickImageFromCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  //   if (photo != null) {
  //     final result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => ImageCaptureScreen(
  //           image: File(photo.path),
  //           title: locationName ?? "Captured Image",
  //         ),
  //       ),
  //     );
  //     if (result != null && result is Map && result["image"] != null) {
  //       setState(() {
  //         imageList.add(result["image"]);
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Color containerColor = const Color(0xFFF5F5F5);
    return Scaffold(
      appBar: AppBarWidget(
        backGroundColor: const Color(0xFF3498DB),
        title: AppString.addobservation
            .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      floatingActionButton: const CommonBackToHomeButton(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    buildSmallTextField(
                      controller: dateController,
                      label: '',
                      hint: '2026-08-18',
                    ),
                  ],
                  // children: [
                  //   const Text('Date',
                  //       style: TextStyle(fontWeight: FontWeight.bold)),
                  //   const SizedBox(height: 5),
                  //   buildSmallTextField(
                  //     controller: dateController,
                  //     label: '',
                  //     hint: '06-06-2025',
                  //     isDatePicker: true,
                  //   ),
                  // ],
                ),
              ),
              SizedBox(width: w * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Location',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    buildSmallTextField(
                      controller: locationController,
                      label: '',
                      hint: 'Enter location',
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Target Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              buildSmallTextField(
                controller: targetDateController,
                label: '',
                hint: '06-06-2025',
                isDatePicker: true,
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
// Issue Category Dropdown
          GetBuilder<AddObservationController>(
            builder: (controller) {
              return buildLabeledDropdown(
                title: 'Issue Category',
                selectedValue: selectedCategory,
                items: controller.issueCategoryList
                    .map((e) => e.name ?? '')
                    .toList(),
                onChanged: (val) async {
                  setState(() {
                    final selectedCategoryObj =
                        controller.issueCategoryList.firstWhere(
                      (e) => e.name == val,
                      orElse: () => IssueCategoryData(),
                    );
                    selectedCategory = val;
                    selectedIssueType = null;
                    selectedCategoryId = selectedCategoryObj.id?.toString();
                  });

                  final selectedCategoryObj =
                      controller.issueCategoryList.firstWhere(
                    (e) => e.name == val,
                    orElse: () => IssueCategoryData(),
                  );
                  if (selectedCategoryObj.id != null) {
                    log("Selected Category ID: ${selectedCategoryObj.id}");
                    await controller.getIssueTypes(
                      categoryId: selectedCategoryObj.id!,
                      categoryName: selectedCategoryObj.name!,
                    );
                  }
                },
              );
            },
          ),
          SizedBox(height: h * 0.015),

// Issue Type Dropdown
          GetBuilder<AddObservationController>(
            builder: (controller) {
              return buildLabeledDropdown(
                title: 'Issue Type',
                selectedValue: selectedIssueType,
                items:
                    controller.issueTypeList.map((e) => e.name ?? '').toList(),
                onChanged: (val) {
                  setState(() {
                    selectedIssueType = val;
                    selectedIssueTypeId = controller.issueTypeList
                        .firstWhere((e) => e.name == val,
                            orElse: () => IssueTypeData())
                        .id
                        ?.toString();
                  });
                },
              );
            },
          ),

          SizedBox(height: h * 0.015),

          GetBuilder<AddObservationController>(
            builder: (controller) {
              final list = controller.impactTypeList;

              return buildLabeledDropdown(
                title: 'Impact Type',

                // Display the NAME of the selected impact type
                selectedValue: list.any(
                  (e) => e.key == selectedImpactType,
                )
                    ? list
                        .firstWhere(
                          (e) => e.key == selectedImpactType,
                        )
                        .name
                    : null,

                // Display names in dropdown
                items: list.map((e) => e.name ?? '').toList(),

                onChanged: (val) {
                  setState(() {
                    final selected = list.firstWhere(
                      (e) => e.name == val,
                      orElse: () => ImpactTypeData(),
                    );

                    // Store KEY for API
                    selectedImpactType = selected.key;
                  });
                },
              );
            },
          ),

          // GetBuilder<AddObservationController>(
          //   builder: (controller) {
          //     final list = controller.observationCategoryList;

          //     return buildLabeledDropdown(
          //       title: 'Impact Type',

          //       // Display selected name
          //       selectedValue: list.any((e) => e.key == selectedImpactType)
          //           ? list.firstWhere((e) => e.key == selectedImpactType).name
          //           : null,

          //       // Show names in dropdown
          //       items: list.map((e) => e.name ?? '').toList(),

          //       onChanged: (value) {
          //         final selected = list.firstWhere(
          //           (e) => e.name == value,
          //           orElse: () => ObservationCategoryData(),
          //         );

          //         setState(() {
          //           // Save key for API
          //           selectedImpactType = selected.key;
          //         });
          //       },
          //     );
          //   },
          // ),

          ///

          SizedBox(height: h * 0.015),
          const Text('Issue Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 5),
          TextFormField(
            controller: issueDescController,
            maxLines: 3,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Enter detailed description about the inspection',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          SizedBox(height: h * 0.015),
          const Text('Remarks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 5),
          TextFormField(
            controller: remarkController,
            maxLines: 3,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Enter remarks',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          //    SizedBox(height: h * 0.015),
          // const Text('Impact', style: TextStyle(fontWeight: FontWeight.bold)),
          // const SizedBox(height: 5),
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   decoration: BoxDecoration(
          //     color: containerColor,
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     children: ['low', 'medium', 'high'].map((level) {
          //       Color radioColor;
          //       if (level == 'low') {
          //         radioColor = Colors.yellow;
          //       } else if (level == 'medium') {
          //         radioColor = Colors.orange;
          //       } else {
          //         radioColor = Colors.red;
          //       }
          //       return Expanded(
          //         child: RadioListTile<String>(
          //           title: Text(
          //             level == 'low'
          //                 ? 'Low'
          //                 : level == 'medium'
          //                     ? 'Medium'
          //                     : 'High',
          //             style: const TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.normal,
          //               color: Colors.black,
          //             ),
          //           ),
          //           value: level,
          //           groupValue: impact,
          //           contentPadding: EdgeInsets.zero,
          //           visualDensity: VisualDensity.compact,
          //           activeColor: radioColor,
          //           onChanged: (val) {
          //             setState(() {
          //               impact = val!;
          //             });
          //           },
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
          SizedBox(height: h * 0.015),
          const Text('Attach Photo',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            height: h * 0.35,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: containerColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageList.isNotEmpty) const SizedBox(height: 5),
                if (imageList.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      itemCount: imageList.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: w * 0.03,
                        mainAxisSpacing: h * 0.015,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(File(imageList[index])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              left: 1.1,
                              right: 1.1,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: h * 0.5,
                                        width: w * 0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            image: FileImage(
                                                File(imageList[index])),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              height: h * 0.052,
                                              width: h * 0.052,
                                              margin: const EdgeInsets.all(10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: const Icon(Icons.close,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Icon(Icons.remove_red_eye,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imageList.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: const Icon(Icons.close_outlined,
                                      size: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                // InkWell(
                //   onTap: _pickImageFromCamera,
                //   child: Container(
                //     height: h * 0.09,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.grey),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: const Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.camera_alt, color: Colors.grey, size: 30),
                //         SizedBox(height: 7),
                //         Text('Add photo', style: TextStyle(color: Colors.grey)),
                //       ],
                //     ),
                //   ),
                // ),

                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Camera
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImageFromCamera();
                                  },
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text('Camera'),
                                    ],
                                  ),
                                ),

                                // Gallery
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImageFromGallery();
                                  },
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: Icon(
                                          Icons.photo_library,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text('Gallery'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: h * 0.09,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Add photo',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              height: 45,
              child: isLoading
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                          child: CircularProgressIndicator(color: Colors.blue)))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        // bool isConnected = await checkNetworkConnectivity();
                        if (!isOfflineMode) {
                          await _submitObservation();
                        } else {
                          isLoading = true;
                          setState(() {});

                          await _saveOfflineData();
                          log("Observation saved for offline use");

                          // Success message is now handled in _saveOfflineData
                          isLoading = false;
                          setState(() {});
                        }
                      },
                      child: Text(isOfflineMode ? 'Save as Draft' : 'Submit',
                          style: const TextStyle(fontSize: 16)),
                    ),
            ),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          )
          .toList(),
      selectedItemBuilder: (context) {
        return items.map((e) {
          final isSelected = e == selectedValue;
          return Text(
            e,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          );
        }).toList();
      },
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  Widget buildLabeledDropdown({
    required String title,
    required String? selectedValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )),
        const SizedBox(height: 5),
        buildDropdown(
          label: '',
          selectedValue: selectedValue,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildSmallTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isDatePicker = false,
    bool? readOnly,
  }) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        readOnly: isDatePicker,
        style: TextStyle(
          fontWeight: controller.text.isNotEmpty
              ? FontWeight.normal
              : FontWeight.normal,
          color: controller.text.isNotEmpty ? Colors.black : Colors.black,
          fontSize: 14,
        ),
        onTap: isDatePicker
            ? () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller.text =
                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                }
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          prefixIcon:
              isDatePicker ? const Icon(Icons.calendar_today, size: 20) : null,
        ),
      ),
    );
  }

  // ✅ NEW IMPROVED OFFLINE DATA LOADING METHOD
/*  Future<void> _loadOfflineDataNew() async {
    try {
      // 🔹 Step 1: Try to load from new offline structure first
      String? existingData = preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';

      if (existingData.isNotEmpty) {
        List<dynamic> decodedData = jsonDecode(existingData);
        List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        // 🔹 Step 2: Look for any pending/draft observations for this location
        for (var flatList in allOfflineData) {
          for (var flat in flatList) {
            for (var location in flat.locationData ?? []) {
              if (location.locationId == locationId) {
                // Check for any pending observations that might be drafts
                for (var observation in location.observations ?? []) {
                  // Look for observations with observationId = 0 (new/draft observations)
                  if (observation.observationId == 0 && observation.state == "pending") {
                    // Load this draft data into the form
                    if (observation.date != null) {
                      dateController.text =
                          "${observation.date!.year}-${observation.date!.month.toString().padLeft(2, '0')}-${observation.date!.day.toString().padLeft(2, '0')}";
                    }
                    if (observation.targetDate != null) {
                      targetDateController.text =
                          "${observation.targetDate!.year}-${observation.targetDate!.month.toString().padLeft(2, '0')}-${observation.targetDate!.day.toString().padLeft(2, '0')}";
                    }

                    issueDescController.text = observation.description ?? '';
                    remarkController.text = observation.remark ?? '';
                    impact = observation.impact ?? 'low';
                    selectedCategory = observation.issueCategoryName;
                    selectedIssueType = observation.issueTypeName;
                    selectedCategoryId = observation.issueCategoryId?.toString();
                    selectedIssueTypeId = observation.issueTypeId?.toString();

                    // Load images from imgData
                    imageList.clear();
                    for (var imgData in observation.imgData ?? []) {
                      if (imgData.imgUrl.isNotEmpty) {
                        imageList.add(imgData.imgUrl);
                      }
                    }

                    log('✅ Loaded draft observation data from offline storage');
                    setState(() {}); // Refresh UI with loaded data
                    return; // Exit after loading the first draft
                  }
                }
              }
            }
          }
        }
      }

      // 🔹 Step 3: Fallback to old SharedPreferences method if no data found in new structure
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('date') != null) {
        dateController.text = prefs.getString('date') ?? '';
        locationController.text = prefs.getString('location') ?? '';
        issueDescController.text = prefs.getString('issueDesc') ?? '';
        targetDateController.text = prefs.getString('targetDate') ?? '';
        remarkController.text = prefs.getString('remark') ?? '';
        impact = prefs.getString('impact') ?? 'low';
        imageList.addAll(prefs.getStringList('images') ?? []);
        selectedCategoryId = prefs.getString('selectedCategoryId');
        selectedIssueTypeId = prefs.getString('selectedIssueTypeId');

        log('✅ Loaded data from old SharedPreferences method');
        setState(() {}); // Refresh UI with loaded data
      }
    } catch (e) {
      log('❌ Error loading offline data: $e');
      // Fallback to old method in case of error
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dateController.text = prefs.getString('date') ?? '';
      locationController.text = prefs.getString('location') ?? '';
      issueDescController.text = prefs.getString('issueDesc') ?? '';
      targetDateController.text = prefs.getString('targetDate') ?? '';
      remarkController.text = prefs.getString('remark') ?? '';
      impact = prefs.getString('impact') ?? 'low';
      imageList.addAll(prefs.getStringList('images') ?? []);
      selectedCategoryId = prefs.getString('selectedCategoryId');
      selectedIssueTypeId = prefs.getString('selectedIssueTypeId');
    }
  }*/

  // 🔹 REMOVED: Automatic offline data submission method
  // User will submit data manually in AttachmentDialogPopup and ShowSaveHQIScreen
  // No automatic sync needed anymore
}
