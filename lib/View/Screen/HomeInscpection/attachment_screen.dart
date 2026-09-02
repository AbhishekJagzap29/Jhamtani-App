import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/add_observation_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/attachment_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/flat_sub_location_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AttachmentDialogPopup extends StatefulWidget {
  final OfflineObservationData observationData;
  final VisitDetails visitDetails;
  final int observationId;
  final int locationId;
  final String state;
  final int sequence;
  final int flatId;
  final int projectId;
  final String observationCategory;

  const AttachmentDialogPopup({
    Key? key,
    required this.observationData,
    required this.visitDetails,
    required this.observationId,
    required this.locationId,
    required this.state,
    required this.sequence,
    required this.flatId,
    required this.projectId,
    required this.observationCategory,
  }) : super(key: key);

  @override
  State<AttachmentDialogPopup> createState() => _AttachmentDialogPopupState();
}

class _AttachmentDialogPopupState extends State<AttachmentDialogPopup> {
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> beforeImageList = [];
  List<String> afterImageList = [];
  String? locationName;
  bool isLoading = false;
  bool isLoadingReSubmit = false;

  String? selectedObservationCategory;
  String? selectedImpactType;

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return "-";
    return text[0].toUpperCase() + text.substring(1);
  }

  final AttachmentController attachmentController =
      Get.put(AttachmentController());
  final AddObservationController addObservationController =
      Get.put(AddObservationController());
  final FlatSubLocationController flatSubLocationController =
      Get.put(FlatSubLocationController());

  final userType = preferences.getString(SharedPreference.userType);

  // 🔹 NEW: Check if observation is offline (newly added and not synced)
  bool get isOfflineObservation =>
      widget.observationData.isNewlyAdded == true &&
      widget.observationData.syncStatus == "pending";

  // 🔹 NEW: Check if observation has been modified offline
  bool get isModifiedOffline =>
      widget.observationData.isUpdated == true &&
      widget.observationData.syncStatus == "pending";

  Future<bool> _isFlatExistInOffline() async {
    String? existingData =
        preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
    if (existingData.isEmpty) {
      log('❌ No offline data found');
      return false;
    }

    List<dynamic> decodedData = jsonDecode(existingData);

    List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
      if (sublist is List) {
        return sublist.map<OfflineHQIData>((item) {
          return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
        }).toList();
      }
      return <OfflineHQIData>[];
    }).toList();

    for (var flatList in allOfflineData) {
      for (var flat in flatList) {
        for (var location in flat.locationData ?? []) {
          if (location.locationId == widget.locationId) {
            log('✅ Flat with ID ${widget.locationId} exists in offline data');
            return true;
          }
        }
      }
    }

    log('❌ Flat with ID ${widget.locationId} not found in offline data');
    return false;
  }

  // 🔹 NEW: Update observation in localStorage
  Future<void> _updateObservationInLocalStorage() async {
    log('🔹 Updating observation in localStorage...');

    // Get existing offline data
    String? existingData =
        preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
    if (existingData.isEmpty) {
      log('❌ No offline data found');
      return;
    }

    List<dynamic> decodedData = jsonDecode(existingData);
    List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
      if (sublist is List) {
        return sublist.map<OfflineHQIData>((item) {
          return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
        }).toList();
      }
      return <OfflineHQIData>[];
    }).toList();

    bool observationUpdated = false;

    // Find and update the specific observation
    for (var flatList in allOfflineData) {
      for (var flat in flatList) {
        for (var location in flat.locationData ?? []) {
          if (location.locationId == widget.locationId) {
            for (int i = 0; i < (location.observations ?? []).length; i++) {
              var observation = location.observations![i];
              if (observation.observationId == widget.observationId) {
                final inputDate = DateTime.parse(dateController.text.isNotEmpty
                    ? dateController.text.trim()
                    : DateTime.now().toString());
                final inputTargetDate = DateTime.parse(
                    targetDateController.text.isNotEmpty
                        ? targetDateController.text.trim()
                        : DateTime.now().toString());

                // Update observation with new data
                location.observations![i] = observation.copyWith(
                  remark: remarkController.text.trim(),
                  description: descriptionController.text.trim(),
                  date: inputDate,
                  targetDate: inputTargetDate,
                  isUpdated: true,
                  lastModified: DateTime.now(),
                  syncStatus: "pending",
                  syncErrorMessage: null,
                  imgData: _createUpdatedImageData(),
                  observationCategory: observation.observationCategory,
                  impactType: observation.impactType,
                );

                observationUpdated = true;
                log('✅ Observation updated for ID ${widget.observationId}');
                break;
              }
            }
            if (observationUpdated) break;
          }
        }
        if (observationUpdated) break;
      }
      if (observationUpdated) break;
    }

    if (observationUpdated) {
      // Save updated data back to localStorage
      String updatedData = jsonEncode(allOfflineData
          .map((sublist) => sublist.map((item) => item.toJson()).toList())
          .toList());
      await preferences.putString(
          SharedPreference.hqiFlatsOfflineData, updatedData);
      log('✅ localStorage updated successfully');
    } else {
      log('⚠️ Observation with ID ${widget.observationId} not found');
    }
  }

  List<ObservationImageData> _createUpdatedImageData() {
    List<ObservationImageData> imgDataList = [];
    Set<String> addedImages = {}; // Track added imgUrl to avoid duplicates

    log("🔹 Creating updated image data...");

    // Add before images (checker images)
    for (String imagePath in beforeImageList) {
      imagePath = imagePath.trim();
      if (imagePath.isEmpty || addedImages.contains(imagePath)) continue;

      log(imagePath.startsWith("http")
          ? "🌐 Adding remote before image: $imagePath"
          : "✅ Adding local before image: $imagePath");

      imgDataList.add(ObservationImageData(
        imgUrl: imagePath,
        userChecker: true,
        userMaker: 0,
        checkerUploadedImg: imagePath,
        makerUploadedImg: null,
      ));
      addedImages.add(imagePath);
    }

    // Add after images (maker images)
    for (String imagePath in afterImageList) {
      imagePath = imagePath.trim();
      if (imagePath.isEmpty || addedImages.contains(imagePath)) continue;

      log(imagePath.startsWith("http")
          ? "🌐 Adding remote after image: $imagePath"
          : "✅ Adding local after image: $imagePath");

      imgDataList.add(ObservationImageData(
        imgUrl: imagePath,
        userChecker: false,
        userMaker: 1,
        checkerUploadedImg: null,
        makerUploadedImg: imagePath,
      ));
      addedImages.add(imagePath);
    }

    log("🔹 Total unique images added: ${imgDataList.length}");
    return imgDataList;
  }

  // 🔹 NEW: Submit offline observation to API
  Future<void> _submitOfflineObservation() async {
    try {
      log('🔹 Starting offline observation submission...');
      setState(() => isLoading = true);

      // Process after images (maker images)
      List<String> afterImagesToSubmit = [];
      for (String imagePath in afterImageList) {
        imagePath = imagePath.trim();
        if (imagePath.isEmpty || imagePath.contains('http://')) continue;

        final file = File(imagePath);
        if (file.existsSync()) {
          afterImagesToSubmit.add(imagePath);
          log('✅ After image file exists: $imagePath');
        } else {
          log('⚠️ After image file does not exist: $imagePath');
        }
      }

      // Process before images (checker images)
      List<String> beforeImagesToSubmit = [];
      for (String imagePath in beforeImageList) {
        imagePath = imagePath.trim();
        if (imagePath.isEmpty || imagePath.contains('http://')) continue;

        final file = File(imagePath);
        if (file.existsSync()) {
          beforeImagesToSubmit.add(imagePath);
          log('✅ Before image file exists: $imagePath');
        } else {
          log('⚠️ Before image file does not exist: $imagePath');
        }
      }

      log('🔹 Total before images: ${beforeImagesToSubmit.length}');
      log('🔹 Total after images: ${afterImagesToSubmit.length}');

      // Submit observation via API
      log('🔹 Submitting observation to API...');
      await addObservationController.submitObservation(
        category: widget.observationData.issueCategoryId?.toString() ?? "",
        issueType: widget.observationData.issueTypeId?.toString() ?? "",
        description: descriptionController.text.trim(),
        impact: widget.observationData.impact ?? "low",
        date: convertDateFormat(dateController.text.trim()),
        targetDate: convertDateFormat(targetDateController.text.trim()),
        locationId: widget.locationId,
        name: widget.observationData.name ?? "",
        remark: remarkController.text.trim(),
        observationId: widget.observationId,
        state: widget.state,
        userId: widget.observationData.userId?.toString() ?? "",
        beforeImages: beforeImagesToSubmit.map((path) => File(path)).toList(),
        afterImages: afterImagesToSubmit.map((path) => File(path)).toList(),
        observationCategory: widget.observationData.observationCategory,
        // impactType:
        //     selectedImpactType ?? widget.observationData.impactType ?? "",
        impactType: widget.observationData.impactType,
      );

      log('🔹 API response status: ${addObservationController.submitObservationResponse.status}');
      log('🔹 API response message: ${addObservationController.submitObservationResponse.message}');

      if (addObservationController.submitObservationResponse.status ==
          Status.COMPLETE) {
        log('✅ Observation submitted successfully');

        // Mark the observation as synced locally
        await _markSpecificObservationAsSynced();
        log('🔹 Observation marked as synced locally');

        // Refresh updated observation data
        await flatSubLocationController.fetchObservationform(
            locationId: widget.locationId,
            flatId: widget.flatId,
            isFlatExistOffline: isFlatExistOffline,
            observationId: widget.observationId);
        log('🔹 Updated observation data fetched');

        successSnackBar("Success", "Observation submitted successfully");
        Navigator.pop(context);
      } else {
        log('❌ Submission failed: ${addObservationController.submitObservationResponse.message}');
        errorSnackBar(
            "Error",
            addObservationController.submitObservationResponse.message ??
                "Submission failed");
      }
    } catch (e, stackTrace) {
      log('❌ Exception during submission: $e');
      log('📄 StackTrace: $stackTrace');
      errorSnackBar("Error", "Failed to submit observation: $e");
    } finally {
      setState(() => isLoading = false);
      log('🔹 Submission process finished');
    }
  }

  String convertDateFormat(String inputDate) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(inputDate));
    return formattedDate;
  }

  // 🔹 NEW: Mark observation as synced in localStorage
  Future<void> _markObservationAsSynced() async {
    try {
      log('🔹 Marking observation as synced...');

      // Get existing offline data
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
      if (existingData.isEmpty) return;

      List<dynamic> decodedData = jsonDecode(existingData);
      List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
        if (sublist is List) {
          return sublist.map<OfflineHQIData>((item) {
            return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
          }).toList();
        }
        return <OfflineHQIData>[];
      }).toList();

      bool observationMarked = false;

      // Find the specific observation and mark it as synced
      for (var flatList in allOfflineData) {
        for (var flat in flatList) {
          for (var location in flat.locationData ?? []) {
            if (location.locationId == widget.locationId) {
              for (int i = 0; i < (location.observations ?? []).length; i++) {
                var observation = location.observations![i];
                if (observation.observationId == widget.observationId) {
                  location.observations![i] = observation.copyWith(
                    isNewlyAdded: false,
                    isUpdated: false,
                    syncStatus: "synced",
                    syncErrorMessage: null,
                    state: "submitted",
                  );
                  observationMarked = true;
                  log('✅ Observation ID ${widget.observationId} marked as synced');
                  break;
                }
              }
              if (observationMarked) break;
            }
          }
          if (observationMarked) break;
        }
        if (observationMarked) break;
      }

      // Save updated data back to localStorage
      if (observationMarked) {
        String updatedData = jsonEncode(allOfflineData
            .map((sublist) => sublist.map((item) => item.toJson()).toList())
            .toList());
        await preferences.putString(
            SharedPreference.hqiFlatsOfflineData, updatedData);
      }
    } catch (e) {
      log('❌ Error marking observation as synced: $e');
    }
  }

  // 🔹 NEW: Mark ONLY the specific observation as synced (for manual submission)
  Future<void> _markSpecificObservationAsSynced() async {
    try {
      log('🔹 Marking specific observation as synced...');

      // Get existing offline data
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
      if (existingData.isEmpty) return;

      List<dynamic> decodedData = jsonDecode(existingData);
      List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
        if (sublist is List) {
          return sublist.map<OfflineHQIData>((item) {
            return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
          }).toList();
        }
        return <OfflineHQIData>[];
      }).toList();

      bool observationMarked = false;

      // Find and mark only the specific observation that was submitted
      for (var flatList in allOfflineData) {
        for (var flat in flatList) {
          for (var location in flat.locationData ?? []) {
            if (location.locationId == widget.locationId) {
              for (int i = 0; i < (location.observations ?? []).length; i++) {
                var observation = location.observations![i];
                if (observation.observationId == widget.observationId &&
                    observation.isNewlyAdded == true &&
                    observation.syncStatus == "pending") {
                  location.observations![i] = observation.copyWith(
                    isNewlyAdded: false,
                    isUpdated: false,
                    syncStatus: "synced",
                    syncErrorMessage: null,
                    state: "submitted",
                  );
                  observationMarked = true;
                  log('✅ Specific observation ${widget.observationId} marked as synced');
                  break;
                }
              }
              if (observationMarked) break;
            }
          }
          if (observationMarked) break;
        }
        if (observationMarked) break;
      }

      // Save updated data back to localStorage if observation was marked
      if (observationMarked) {
        String updatedData = jsonEncode(allOfflineData
            .map((sublist) => sublist.map((item) => item.toJson()).toList())
            .toList());
        await preferences.putString(
            SharedPreference.hqiFlatsOfflineData, updatedData);
        log('✅ Specific observation localStorage updated successfully');
      } else {
        log('⚠️ Specific observation not found or already synced');
      }
    } catch (e) {
      log('❌ Error marking specific observation as synced: $e');
    }
  }

  bool isFlatExistOffline = false;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isFlatExistOffline = await _isFlatExistInOffline();
    });
    addObservationData();
    isEditable = _computeIsEditable();

    // 🔹 NEW: Add listeners to text controllers to track changes
    remarkController.addListener(_onFieldChanged);
    descriptionController.addListener(_onFieldChanged);
    dateController.addListener(_onFieldChanged);
    targetDateController.addListener(_onFieldChanged);
    selectedObservationCategory = widget.observationData.observationCategory;
    selectedImpactType = widget.observationData.impactType;
  }

  @override
  void dispose() {
    // 🔹 NEW: Remove listeners
    remarkController.removeListener(_onFieldChanged);
    descriptionController.removeListener(_onFieldChanged);
    dateController.removeListener(_onFieldChanged);
    targetDateController.removeListener(_onFieldChanged);
    super.dispose();
  }

  // 🔹 NEW: Handle field changes and update localStorage if needed
  void _onFieldChanged() {
    log('isFlatExistOffline::::::::::::::::$isFlatExistOffline : isEditable = $isEditable');
    // Only update localStorage if this is an offline observation or if it's been modified
    // if (isOfflineObservation || isModifiedOffline) {
    if (isFlatExistOffline && isEditable) {
      // Debounce the update to avoid too many localStorage writes
      Future.delayed(const Duration(milliseconds: 500), () {
        _updateObservationInLocalStorage();
      });
    }
  }

  bool _computeIsEditable() {
    // Log entry and key info for debugging
    log("🔍 Computing if observation is editable → userType: $userType, isNewlyAddedOffline: $isNewlyAddedOffline, isUpdatedOffline: $isUpdatedOffline");

    // Case 1: NEW OFFLINE observation → always editable
    if (isNewlyAddedOffline) {
      log("✅ Case 1: NEW OFFLINE observation → Editable");
      return true;
    }

    // Case 2: UPDATED OFFLINE observation
    else if (isUpdatedOffline) {
      log("🔹 Case 2: UPDATED OFFLINE observation");
      if (widget.observationData.checkerSubmitted == true &&
          widget.observationData.makerSubmitted != true &&
          (userType?.contains("hqi_maker") ?? false)) {
        // userType == "hqi_maker") {
        log("✅ Maker resubmitting → Editable");
        return true;
      } else if (widget.observationData.checkerSubmitted != true &&
          (userType == "hqi_checker" || userType == "hqi_approver")) {
        log("✅ Checker/Approver approving → Editable");
        return true;
      } else {
        log("❌ Updated offline but conditions not met → Not Editable");
        return false;
      }
    }

    // Case 3: ONLINE observation
    else {
      log("🔹 Case 3: ONLINE observation");
      if (widget.observationData.checkerSubmitted == true &&
          widget.observationData.makerSubmitted != true &&
          (userType?.contains("hqi_maker") ?? false)) {
        //  userType == "hqi_maker") {
        log("✅ Maker resubmitting online → Editable");
        return true;
      } else if (widget.observationData.checkerSubmitted != true &&
          (userType == "hqi_checker" || userType == "hqi_approver")) {
        log("✅ Checker/Approver approving online → Editable");
        return true;
      } else if (((userType?.contains("hqi_maker") ?? false) &&
              widget.observationData.state == "in_review_by_checker") ||
          ((userType == "hqi_checker" || userType == "hqi_approver") &&
              widget.observationData.state == "completed")) {
        log("⛔ Already submitted → Not Editable");
        return false;
      } else {
        log("❌ Online observation conditions not met → Not Editable");
        return false;
      }
    }
  }

  // 🔹 NEW: Check if observation needs to be submitted (offline observation)
  bool get needsSubmission =>
      isOfflineObservation &&
      widget.observationData.state == "pending" &&
      widget.observationData.isNewlyAdded == true;

  // 🔹 NEW: Check if observation is newly added and needs submission
  bool get isNewlyAddedOffline =>
      widget.observationData.isNewlyAdded == true &&
      widget.observationData.syncStatus == "pending";

  // 🔹 NEW: Check if observation is updated and needs submission
  bool get isUpdatedOffline =>
      widget.observationData.isUpdated == true &&
      widget.observationData.syncStatus == "pending";

  // 🔹 NEW: Handle offline observation submission based on conditions
  Future<void> _handleOfflineSubmission() async {
    if (isNewlyAddedOffline) {
      // 🔹 New observation: Call /flat/observation/return-to-maker API
      await _submitOfflineObservation();
    } else if (isUpdatedOffline) {
      // 🔹 Updated observation: Check user type and conditions
      if (widget.observationData.checkerSubmitted == true &&
          widget.observationData.makerSubmitted != true &&
          (userType?.contains("hqi_maker") ?? false)) {
        //userType == "hqi_maker") {
        // 🔹 Maker resubmitting to checker: Call /flat/observation/resubmit-to-checker API
        await _resubmitOfflineObservationToChecker();
      } else if (widget.observationData.checkerSubmitted != true &&
          (userType == "hqi_checker" || userType == "hqi_approver")) {
        // 🔹 Checker/Approver: Call completeObservationByChecker or submitObservation based on conditions
        await _handleCheckerApproverSubmission();
      }
    }
  }

  // 🔹 NEW: Resubmit offline observation to checker
  Future<void> _resubmitOfflineObservationToChecker() async {
    try {
      log('🔹 Resubmitting offline observation to checker...');

      setState(() {
        isLoading = true;
      });

      final imagePaths =
          afterImageList.where((img) => File(img).existsSync()).toList();

      String finalObservationCategory = (selectedObservationCategory != null &&
              selectedObservationCategory!.isNotEmpty)
          ? selectedObservationCategory!
          : (widget.observationData.observationCategory ?? "");

      log("🔹 FINAL observation_category: $finalObservationCategory");

      print(
          'afterImageList:::::::::67:::::${afterImageList.length}::${afterImageList}');
      print('imagePaths:::::::::::78:::::${imagePaths}');
      await attachmentController.resubmitObservationToChecker(
        observationId: widget.observationId,
        imageFiles: imagePaths,
        remark: remarkController.text.trim(),
        date: dateController.text.trim(),
        targetDate: targetDateController.text.trim(),
        locationId: widget.locationId,
        description: descriptionController.text.trim(),
        impactType: widget.observationData.impactType,
        // impactType: selectedImpactType,
      );

      if (attachmentController.resubmitObservationResponse.status ==
          Status.COMPLETE) {
        // Mark as synced
        await _markObservationAsSynced();
        flatSubLocationController.fetchObservationform(
          locationId: widget.locationId,
          flatId: widget.flatId,
          isFlatExistOffline: isFlatExistOffline,
          observationId: widget.observationId,
        );
        successSnackBar("Success", "Observation resubmitted successfully");
        Navigator.pop(context);
      } else {
        errorSnackBar(
            "Error",
            attachmentController.resubmitObservationResponse.message ??
                "Resubmission failed");
      }
    } catch (e) {
      log('❌ Error resubmitting offline observation: $e');
      errorSnackBar("Error", "Failed to resubmit observation: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔹 NEW: Handle checker/approver submission for offline observations
  Future<void> _handleCheckerApproverSubmission() async {
    try {
      log('🔹 Handling checker/approver submission for offline observation...');

      setState(() {
        isLoading = true;
      });

      // For now, use the same logic as online submission
      // You can add specific conditions here if needed
      await addObservationController.submitObservation(
        category: widget.observationData.issueCategoryId.toString(),
        issueType: widget.observationData.issueTypeId.toString(),
        description: descriptionController.text.trim(),
        impact: 'low',
        date: dateController.text.trim(),
        locationId: widget.locationId,
        name: locationName ?? locationController.text.trim(),
        remark: remarkController.text.trim(),
        observationId: widget.observationId,
        targetDate: targetDateController.text.trim(),
        state: widget.state,
        userId: widget.observationData.userId.toString(),
        observationCategory: widget.observationData.observationCategory,
        //  impactType: selectedImpactType,
        // ?? widget.observationData.impactType ?? "",
        impactType: widget.observationData.impactType,
        beforeImages: beforeImageList
            .where((e) => File(e).existsSync())
            .map((e) => File(e))
            .toList(),
        afterImages: afterImageList
            .where((e) => File(e).existsSync())
            .map((e) => File(e))
            .toList(),
      );
      log('beforeImageList::::::::::::::1111::${beforeImageList.length} : ${beforeImageList}');
      log('afterImageList:::::::::::::::1111:${afterImageList.length} : ${afterImageList}');
      print(
          'beforeImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList()::::::::::::::::${beforeImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList().length} : ${beforeImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList()}');
      print(
          'afterImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList()::::::::::::::::${afterImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList().length} : ${afterImageList.where((e) => File(e).existsSync()).map((e) => File(e)).toList()}');
      if (addObservationController.submitObservationResponse.status ==
          Status.COMPLETE) {
        // Mark as synced
        await _markObservationAsSynced();
        flatSubLocationController.fetchObservationform(
          locationId: widget.locationId,
          flatId: widget.flatId,
          isFlatExistOffline: isFlatExistOffline,
          observationId: widget.observationId,
        );
        successSnackBar("Success", "Observation submitted successfully");
        Navigator.pop(context);
      } else {
        errorSnackBar(
            "Error",
            addObservationController.submitObservationResponse.message ??
                "Submission failed");
      }
    } catch (e) {
      log('❌ Error in checker/approver submission: $e');
      errorSnackBar("Error", "Failed to submit observation: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  addObservationData() {
    if (widget.observationData.remark != null &&
        widget.observationData.date != null &&
        widget.observationData.targetDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(
          widget.observationData.date != null
              ? widget.observationData.date!
              : DateTime.now());
      final formattedTargetDate = DateFormat('yyyy-MM-dd').format(
          widget.observationData.targetDate != null
              ? widget.observationData.targetDate!
              : DateTime.now());

      remarkController.text = widget.observationData.remark ?? '';
      descriptionController.text = widget.observationData.description ?? '';
      dateController.text = formattedDate;
      // dateController.text = inputFormat.parse(widget.observationData.date.toString()).toString();
      targetDateController.text = formattedTargetDate;
      // targetDateController.text = inputFormat.parse(widget.observationData.targetDate.toString()).toString();
      log('dateController.text::::::::::::::::${dateController.text}');
      print(
          'widget.observationData.imgData::::::::::::::::${jsonEncode(widget.observationData.imgData)}');
      beforeImageList = widget.observationData.imgData
              ?.map((e) => e.checkerUploadedImg)
              .whereType<String>()
              .toList() ??
          [];
      afterImageList = widget.observationData.imgData
              ?.map((e) => e.makerUploadedImg)
              .whereType<String>()
              .toList() ??
          [];
      setState(() {});
      log('beforeImageList::::::::::::::::${beforeImageList}');
      log('afterImageList::::::::::::::::${afterImageList}');
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchObservationData();
      });
    }
  }

  Future<void> fetchObservationData() async {
    await addObservationController
        .fetchObservationform(locationId: widget.locationId)
        .then(
      (value) {
        if (addObservationController.observationList.isNotEmpty) {
          final data = addObservationController.observationList.first;

          final inputDate = DateTime.parse(data.date != ''
              ? data.date.toString()
              : DateTime.now().toString());
          final formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
          final inputTargetDate = DateTime.parse(data.targetDate != ''
              ? data.targetDate.toString()
              : DateTime.now().toString());
          final formattedTargetDate =
              DateFormat('yyyy-MM-dd').format(inputTargetDate);

          remarkController.text = data.remark ?? '';
          descriptionController.text = data.description ?? '';
          dateController.text = formattedDate;
          targetDateController.text = formattedTargetDate;

          beforeImageList = data.imgData
                  ?.map((e) => e.checkerUploadedImg)
                  .whereType<String>()
                  .toList() ??
              [];

          afterImageList = data.imgData
                  ?.map((e) => e.makerUploadedImg)
                  .whereType<String>()
                  .toList() ??
              [];
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    int beforeRows = (beforeImageList.length / 3).ceil();
    double beforeImageHeight = beforeImageList.isEmpty ? 100 : beforeRows * 110;

    int afterRows = (afterImageList.length / 3).ceil();
    double afterImageHeight = afterImageList.isEmpty ? 100 : afterRows * 110;
    print(
        'widget.visitDetails.sequence::::::::::::::::${widget.visitDetails.sequence} = ${widget.observationData.makerSubmitted} = ${widget.observationData.checkerSubmitted}');
    return GetBuilder<AttachmentController>(builder: (controller) {
      debugPrint(
          "widget.observationData===================${widget.observationData.toJson()}");
      return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          (isOfflineObservation || isModifiedOffline)
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                      children: [
                        // 🔹 NEW: Show offline indicator
                        if (isOfflineObservation || isModifiedOffline)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isOfflineObservation ? "Offline" : "Modified",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    buildLabel("Date"),
                    buildField(dateController.text.toString()),
                    buildLabel("Target Date"),
                    buildField(targetDateController.text.toString()),
                    buildLabel("Issue Category"),
                    buildField(widget.observationData.issueCategoryName ?? "-"),
                    buildLabel("Issue Type"),
                    buildField(widget.observationData.issueTypeName ?? "-"),

                    buildLabel("Impact Type"),
                    buildField(capitalizeFirstLetter(
                        widget.observationData.impactType)),

                    // buildLabel("Condition Rating"),
                    // buildField(capitalizeFirstLetter(
                    //     widget.observationData.observationCategory)),

                    buildLabel("Issue Description"),
                    buildEditableField(
                      descriptionController,
                      hint: "Enter Description",
                      fontSize: 14,
                    ),
                    buildLabel("Remarks"),
                    buildEditableField(
                      remarkController,
                      hint: "Enter Remark",
                      fontSize: 14,
                    ),
                    SizedBox(height: h * 0.008),
                    buildLabel("Before Photo"),
                    Container(
                      height: beforeImageList.isEmpty ? 100 : beforeImageHeight,

                      // Container(
                      //   height: h * 0.35,
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
                          if (beforeImageList.isNotEmpty)
                            const SizedBox(height: 5),
                          if (beforeImageList.isNotEmpty)
                            Expanded(
                              child: GridView.builder(
                                itemCount: beforeImageList.length,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final url = beforeImageList[index];
                                  // print('url::::::::::::::::url::::::::::::::::${url}');
                                  return Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: getImageProvider(url),

                                            /* (url.contains('http://'))
                                                ? NetworkImage(url)
                                                : FileImage(
                                                    File(url),
                                                  ) as ImageProvider,*/
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
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                    height: h * 0.5,
                                                    width: w * 0.8,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: blackColor,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: getImageProvider(
                                                            url),
                                                        /*(url.contains('http://'))
                                                            ? NetworkImage(url)
                                                            : FileImage(
                                                                File(url),
                                                              ) as ImageProvider,*/
                                                      ),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          height: h * 0.052,
                                                          width: h * 0.052,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: const Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      if (widget.observationData.state ==
                                              "correction_by_maker" ||
                                          widget.observationData.state ==
                                                  "in_review_by_checker" &&
                                              userType == "hqi_checker" ||
                                          // userType == "hqi_maker")

                                          (userType?.contains("hqi_maker") ??
                                              false))
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                beforeImageList.removeAt(index);
                                              });
                                              // 🔹 NEW: Update localStorage when images are removed
                                              _onFieldChanged();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: const Icon(
                                                  Icons.close_outlined,
                                                  size: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          if (beforeImageList.isEmpty)
                            const Center(
                              child: Text(
                                "No before photos",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    const Text('After Photo',
                        style: TextStyle(fontWeight: FontWeight.w500)),
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
                          if (afterImageList.isNotEmpty)
                            const SizedBox(height: 5),
                          if (afterImageList.isNotEmpty)
                            Expanded(
                              child: GridView.builder(
                                itemCount: afterImageList.length,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: w * 0.03,
                                  mainAxisSpacing: h * 0.015,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  log('afterImageList.length::::::::::::::::${afterImageList.length}');
                                  final url = afterImageList[index];
                                  log('url::::::::::::::After Photo::${url}');
                                  return Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: getImageProvider(url),

                                            /*              (url.startsWith("data:image")
                                                ? MemoryImage(
                                                    base64Decode(
                                                      url
                                                          .replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '')
                                                          .replaceAll(RegExp(r'\s'), ''),
                                                    ),
                                                  )
                                                : (!url.contains('http://'))
                                                    ? FileImage(File(url)) as ImageProvider
                                                    : NetworkImage(url)),*/
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
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                    height: h * 0.5,
                                                    width: w * 0.8,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: blackColor,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: getImageProvider(
                                                            url),

                                                        /*            (url.startsWith("data:image")
                                                            ? MemoryImage(
                                                                base64Decode(
                                                                  url
                                                                      .replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '')
                                                                      .replaceAll(RegExp(r'\s'), ''),
                                                                ),
                                                              )
                                                            : (!url.contains('http://'))
                                                                ? FileImage(File(url)) as ImageProvider
                                                                : NetworkImage(url)),*/
                                                      ),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          height: h * 0.052,
                                                          width: h * 0.052,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: const Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      if (widget.observationData.state ==
                                              "correction_by_maker" ||
                                          widget.observationData.state ==
                                                  "in_review_by_checker" &&
                                              userType == "hqi_checker" ||
                                          // userType == "hqi_maker")
                                          (userType?.contains("hqi_maker") ??
                                              false))
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                afterImageList.removeAt(index);
                                              });
                                              // 🔹 NEW: Update localStorage when images are removed
                                              _onFieldChanged();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: const Icon(
                                                  Icons.close_outlined,
                                                  size: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          InkWell(
                            onTap: () => _pickImage(isBefore: false),
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
                                  Icon(Icons.camera_alt,
                                      color: Colors.grey, size: 30),
                                  SizedBox(height: 7),
                                  Text('Add photo',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 UPDATED: Handle offline observations and regular submissions based on sync status
                    if (isNewlyAddedOffline) ...[
                      // 🔹 New observation: Always call /flat/observation/return-to-maker API
                      buildActionButton("Submit", () async {
                        setState(() {
                          isLoading = true;
                        });
                        await _handleOfflineSubmission();
                        setState(() {
                          isLoading = false;
                        });
                      }),
                    ] else if (isUpdatedOffline) ...[
                      // 🔹 Updated observation: Check user type and conditions
                      if (widget.observationData.checkerSubmitted == true &&
                          widget.observationData.makerSubmitted != true &&
                          // userType == "hqi_maker")

                          (userType?.contains("hqi_maker") ?? false)) ...[
                        // 🔹 Maker resubmitting to checker: Call /flat/observation/resubmit-to-checker API
                        buildActionButton("Update & Resubmit", () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _handleOfflineSubmission();
                          setState(() {
                            isLoading = false;
                          });
                        }),
                      ] else if (widget.observationData.checkerSubmitted !=
                              true &&
                          (userType == "hqi_checker" ||
                              userType == "hqi_approver")) ...[
                        // 🔹 Checker/Approver: Show both Approve and Submit buttons
                        Row(
                          children: [
                            Expanded(
                              child: buildActionButton2("Approve", () async {
                                setState(() {
                                  isLoadingReSubmit = true;
                                });
                                await attachmentController
                                    .completeObservationByChecker(
                                  observationId: widget.observationId,
                                  imageFiles: afterImageList
                                      .where((e) => File(e).existsSync())
                                      .map((e) => e)
                                      .toList(),
                                  remark: widget.observationData.remark ?? "",
                                  date: dateController.text.trim(),
                                  targetDate: targetDateController.text.trim(),
                                  description:
                                      widget.observationData.description ?? '',
                                  //  observationCategory: selectedObservationCategory ?? "",
                                  impactType: selectedImpactType ?? "",
                                );
                                if (attachmentController
                                        .completeObservationResponse.status ==
                                    Status.COMPLETE) {
                                  await _markObservationAsSynced();
                                  flatSubLocationController
                                      .fetchObservationform(
                                    locationId: widget.locationId,
                                    flatId: widget.flatId,
                                    isFlatExistOffline: isFlatExistOffline,
                                    observationId: widget.observationId,
                                  );
                                  successSnackBar("Success",
                                      "Observation submitted successfully");
                                  Navigator.pop(context);
                                } else if (attachmentController
                                        .completeObservationResponse.status ==
                                    Status.ERROR) {
                                  log("Error submitting observation: ${attachmentController.completeObservationResponse.message}");
                                  errorSnackBar(
                                      "Error",
                                      attachmentController
                                              .completeObservationResponse
                                              .message ??
                                          "Submission failed");
                                }
                                setState(() {
                                  isLoadingReSubmit = false;
                                });
                              }),
                            ),
                            const SizedBox(width: 10),
                            if (widget.visitDetails.sequence != 3)
                              Expanded(
                                child: buildActionButton("Update & Resubmit",
                                    () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _handleOfflineSubmission();
                                  setState(() {
                                    isLoading = false;
                                  });
                                }),
                              ),
                          ],
                        ),
                      ],
                    ] else ...[
                      // 🔹 ONLINE OBSERVATION: Handle regular online flow
                      if (widget.observationData.checkerSubmitted == true &&
                          widget.observationData.makerSubmitted != true &&
                          (userType?.contains("hqi_maker") ?? false)) ...[
                        //  userType == "hqi_maker") ...[
                        buildActionButton("Resubmit", () async {
                          setState(() {
                            isLoading = true;
                          });

                          final imagePaths = afterImageList
                              .where((img) => File(img).existsSync())
                              .toList();
                          print(
                              'afterImageList:::::::::45:::::${afterImageList.length}::${afterImageList}');
                          print('imagePaths:::::::::::34:::::${imagePaths}');

                          await attachmentController
                              .resubmitObservationToChecker(
                            observationId: widget.observationId,
                            imageFiles: imagePaths,
                            remark: remarkController.text.trim(),
                            date: dateController.text.trim(),
                            targetDate: targetDateController.text.trim(),
                            locationId: widget.locationId,
                            description: descriptionController.text.trim(),
                            impactType: selectedImpactType ?? "",
                            //observationCategory: selectedObservationCategory ?? "",
                            // observationCategory: (selectedObservationCategory !=
                            //             null &&
                            //         selectedObservationCategory!.isNotEmpty)
                            //     ? selectedObservationCategory
                            //     : widget.observationData.observationCategory,
                          );
                          if (attachmentController
                                  .resubmitObservationResponse.status ==
                              Status.COMPLETE) {
                            flatSubLocationController.fetchObservationform(
                              locationId: widget.locationId,
                              flatId: widget.flatId,
                              isFlatExistOffline: isFlatExistOffline,
                              observationId: widget.observationId,
                            );
                            successSnackBar("Success",
                                "Observation resubmitted successfully");
                            Navigator.pop(context);
                          } else if (attachmentController
                                  .resubmitObservationResponse.status ==
                              Status.ERROR) {
                            log("Error reSubmitting observation: ${attachmentController.resubmitObservationResponse.message}");
                            errorSnackBar(
                                "Error",
                                attachmentController
                                        .resubmitObservationResponse.message ??
                                    "Resubmission failed");
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }),
                      ] else if (widget.observationData.checkerSubmitted !=
                              true &&
                          (userType == "hqi_checker" ||
                              userType == "hqi_approver")) ...[
                        Row(
                          children: [
                            Expanded(
                              child: buildActionButton2("Approve", () async {
                                setState(() {
                                  isLoadingReSubmit = true;
                                });
                                await attachmentController
                                    .completeObservationByChecker(
                                  observationId: widget.observationId,
                                  imageFiles: afterImageList
                                      .where((e) => File(e).existsSync())
                                      .map((e) => e)
                                      .toList(),
                                  remark: widget.observationData.remark ?? "",
                                  date: dateController.text.trim(),
                                  targetDate: targetDateController.text.trim(),
                                  description:
                                      widget.observationData.description ?? '',
                                  //  observationCategory: selectedObservationCategory ?? "",
                                  impactType: selectedImpactType ?? "",
                                );
                                if (attachmentController
                                        .completeObservationResponse.status ==
                                    Status.COMPLETE) {
                                  flatSubLocationController
                                      .fetchObservationform(
                                    locationId: widget.locationId,
                                    flatId: widget.flatId,
                                    isFlatExistOffline: isFlatExistOffline,
                                    observationId: widget.observationId,
                                  );
                                  successSnackBar("Success",
                                      "Observation approved successfully");
                                  Navigator.pop(context);
                                } else if (attachmentController
                                        .completeObservationResponse.status ==
                                    Status.ERROR) {
                                  log("Error approved observation: ${attachmentController.completeObservationResponse.message}");
                                  errorSnackBar(
                                      "Error",
                                      attachmentController
                                              .completeObservationResponse
                                              .message ??
                                          "Submission failed");
                                }
                                setState(() {
                                  isLoadingReSubmit = false;
                                });
                              }),
                            ),

                            const SizedBox(width: 10),
                            if (widget.visitDetails.sequence != 3)
                              Expanded(
                                child: buildActionButton("Resubmit", () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await addObservationController
                                      .submitObservation(
                                    category: widget
                                        .observationData.issueCategoryId
                                        .toString(),
                                    issueType: widget
                                        .observationData.issueTypeId
                                        .toString(),
                                    description:
                                        descriptionController.text.trim(),
                                    impact: 'low',
                                    date: dateController.text.trim(),
                                    locationId: widget.locationId,
                                    name: locationName ??
                                        locationController.text.trim(),
                                    remark: remarkController.text.trim(),
                                    observationId: widget.observationId,
                                    targetDate:
                                        targetDateController.text.trim(),

                                    state: widget.state,
                                    userId: widget.observationData.userId
                                        .toString(),
                                    beforeImages: beforeImageList
                                        .where((e) => File(e).existsSync())
                                        .map((e) => File(e))
                                        .toList(),
                                    afterImages: afterImageList
                                        .where((e) => File(e).existsSync())
                                        .map((e) => File(e))
                                        .toList(),
                                    // observationCategory: widget
                                    //     .observationData.observationCategory,
                                              impactType : widget.observationData.impactType,

                                    
                                  );
                                  if (addObservationController
                                          .submitObservationResponse.status ==
                                      Status.COMPLETE) {
                                    flatSubLocationController
                                        .fetchObservationform(
                                      locationId: widget.locationId,
                                      flatId: widget.flatId,
                                      isFlatExistOffline: isFlatExistOffline,
                                      observationId: widget.observationId,
                                    );
                                    successSnackBar("Success",
                                        "Observation submitted successfully");
                                    Navigator.pop(context);
                                  } else if (addObservationController
                                          .submitObservationResponse.status ==
                                      Status.ERROR) {
                                    log("Error submitted observation: ${addObservationController.submitObservationResponse.message}");
                                    errorSnackBar(
                                        "Error",
                                        addObservationController
                                                .submitObservationResponse
                                                .message ??
                                            "Submission failed");
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }),
                              ),
                          ],
                        ),
                      ] else if ((
                              //userType == "hqi_maker"
                              (userType?.contains("hqi_maker") ?? false) &&
                                  widget.observationData.state ==
                                      "in_review_by_checker") ||
                          ((userType == "hqi_checker" ||
                                  userType == "hqi_approver") &&
                              widget.observationData.state == "completed")) ...[
                        buildActionButton("Already Submitted", () {}),
                      ] else ...[
                        buildActionButton("Already Submitted", () {}),
                      ]
                    ]
                  ],
                ),
              ),
            ),
          ));
    });
  }

  // Add this helper function in the same file or your widget class
  ImageProvider getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      // Network image
      return NetworkImage(url);
    } else if (url.startsWith('/')) {
      // Local file
      final file = File(url);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        // fallback placeholder
        return const AssetImage('assets/images/placeholder.png');
      }
    } else {
      // Assume base64
      try {
        final decodedBytes = base64Decode(url);
        return MemoryImage(decodedBytes);
      } catch (e) {
        // fallback placeholder if base64 invalid
        return const AssetImage('assets/images/placeholder.png');
      }
    }
  }

  Widget buildLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 12),
        child: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      );

  Widget buildField(String text) => Container(
        height: 44,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      );

  Widget buildEditableField(
    TextEditingController controller, {
    required String hint,
    VoidCallback? onTap,
    bool readOnly = false,
    int? fontSize,
  }) =>
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(fontSize: fontSize?.toDouble()),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14),
          suffixIcon:
              onTap != null ? const Icon(Icons.calendar_today, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget buildActionButton(String text, VoidCallback onPressed) => SizedBox(
        width: double.infinity,
        height: 50,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPressed,
                child: Text(text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
      );
  Widget buildActionButton2(String text, VoidCallback onPressed) => SizedBox(
        width: double.infinity,
        height: 50,
        child: isLoadingReSubmit
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPressed,
                child: Text(text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
      );

  Widget buildActionIcon(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text("+ Add Photo", style: TextStyle(color: Colors.blue)),
          ),
        ),
      );

  Future<void> _pickImage({required bool isBefore}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    log('beforeImageList.length:::::::::::::_pickImage::${beforeImageList.length}');
    log('afterImageList.length::::::::::::::_pickImage:${afterImageList.length}');
    if (photo != null) {
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
        setState(() {
          if (isBefore) {
            beforeImageList.add(result["image"]);
          } else {
            afterImageList.add(result["image"]);
          }
          // imageList.(result["image"]);
        });
        // 🔹 NEW: Update localStorage when images are added
        _onFieldChanged();
      }
    }
    log('beforeImageList.length::::::::::222:::_pickImage::${beforeImageList.length}');
    log('afterImageList.length:::::::::::222:::_pickImage:${afterImageList.length}');
  }
}
