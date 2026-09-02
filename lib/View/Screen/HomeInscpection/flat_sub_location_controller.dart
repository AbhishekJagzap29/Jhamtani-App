import 'dart:convert';
import 'dart:developer';

import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlatSubLocationController extends GetxController {
  List<OfflineObservationData> observationList = [];

  List<OfflineObservationData> data = [];
  OfflineLocationData? selectedLocationData; // <-- store matched location data
  // bool isOffline = false;

  final searchController = TextEditingController();
  List<OfflineObservationData> filteredObservationList = [];
  bool isSearching = false;

  bool isLoading = false;

  bool selectionMode = false;
  final RxSet<int> selectedObservations = <int>{}.obs;

  void toggleSelectionMode() {
    selectionMode = !selectionMode;

    if (!selectionMode) {
      selectedObservations.clear();
    }

    update();
  }

  void toggleSelection(int observationId) {
    if (selectedObservations.contains(observationId)) {
      selectedObservations.remove(observationId);
    } else {
      selectedObservations.add(observationId);
    }
    update();
  }

  bool isSelected(int observationId) {
    return selectedObservations.contains(observationId);
  }

  void selectAll(List<int> allIds) {
    selectedObservations.addAll(allIds);
    update();
  }

  void clearSelection() {
    selectedObservations.clear();
    update();
  }

  List<int> getSelectedList() {
    return selectedObservations.toList();
  }

  Future<void> submitSelectedObservations() async {
    if (selectedObservations.isEmpty) return;

    final selectedIds = selectedObservations.toList();

    print("Submitting Observations: $selectedIds");

    clearSelection();
    selectionMode = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    _performSearch();
  }

  void _performSearch() {
    if (searchController.text.isEmpty) {
      filteredObservationList = List.from(observationList);
      isSearching = false;
    } else {
      final query = searchController.text.toLowerCase();
      filteredObservationList = observationList.where((observation) {
        return (observation.name?.toLowerCase().contains(query) ?? false) ||
            (observation.description?.toLowerCase().contains(query) ?? false) ||
            (observation.issueCategoryName?.toLowerCase().contains(query) ??
                false) ||
            (observation.issueTypeName?.toLowerCase().contains(query) ??
                false) ||
            (observation.remark?.toLowerCase().contains(query) ?? false) ||
            (observation.impact?.toLowerCase().contains(query) ?? false) ||
            (observation.state?.toLowerCase().contains(query) ?? false) ||
            (observation.date?.toString().toLowerCase().contains(query) ??
                false) ||
            (observation.targetDate?.toString().toLowerCase().contains(query) ??
                false);
      }).toList();
      isSearching = true;
    }
    update();
  }

  void clearSearch() {
    searchController.clear();
    filteredObservationList = List.from(observationList);
    isSearching = false;
    update();
  }

  // Method to refresh search when data is updated
  void refreshSearch() {
    if (searchController.text.isEmpty) {
      filteredObservationList = List.from(observationList);

      isSearching = false;
    } else {
      _performSearch();
    }
  }

  Future<void> getAndStoreData({
    required int locationId,
    required String projectId,
    required String towerId,
    required String flatId,
  }) async {
    if (isLoading) {
      log('⚠ Already loading data, skipping...');
      return;
    }

    isLoading = true;
    _observationResponse =
        ApiResponse.loading(message: 'Loading observation data...');

    // update();

    try {
      log('📦 Checking offline data for flatId=$flatId, locationId=$locationId');

      // 🔹 Step 1: Check local storage first
      String? existingData =
          preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
      bool foundOfflineData = false;

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
          log('✅ Full offlineHQIData: ${jsonEncode(allOfflineData)}');
          // Find the location data for the specific locationId
          for (var flatList in allOfflineData) {
            for (var flat in flatList) {
              for (var loc in flat.locationData ?? []) {
                if (loc.locationId == locationId) {
                  log("✅ Found offline observation data for locationId=$locationId");

                  // Store location data in local variable
                  selectedLocationData = loc;

                  // Use OfflineObservationData directly
                  observationList = (loc.observations ?? [])
                      .map<OfflineObservationData>((e) =>
                          e is OfflineObservationData
                              ? e
                              : OfflineObservationData.fromJson(e))
                      .toList();

                  filteredObservationList = List.from(observationList);

                  _observationResponse = ApiResponse.complete(observationList);
                  refreshSearch(); // Refresh search with new data
                  foundOfflineData = true;
                  break;
                }
              }
              if (foundOfflineData) break;
            }
            if (foundOfflineData) break;
          }
        } catch (e) {
          log('❌ Error processing offline data: $e');
        }
      }

      // 🔹 Step 2: If no offline data found, call API
      if (!foundOfflineData) {
        log('📦 No offline data found, calling API...');

        // 🔹 REPLACED: Using new API for Home Inspection
        final request = {
          "flat_id": flatId,
          "user_id":
              int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
        };

        final response =
            await ProjectRepo().getHQIFlatsOfflineRepo(body: request);

        if (response.status == "SUCCESS" &&
            response.data != null &&
            response.data!.isNotEmpty) {
          // Find the location data for the specific locationId
          for (var visit in response.data!) {
            for (var loc in visit.locationData ?? []) {
              if (loc.locationId == locationId) {
                log("✅ Found location data for locationId=$locationId from API");

                // Store location data in local variable
                selectedLocationData = loc;

                // Use OfflineObservationData directly
                observationList = (loc.observations ?? [])
                    .map<OfflineObservationData>((e) =>
                        e is OfflineObservationData
                            ? e
                            : OfflineObservationData.fromJson(e))
                    .toList();

                filteredObservationList = List.from(observationList);

                _observationResponse = ApiResponse.complete(observationList);
                refreshSearch(); // Refresh search with new data
                break;
              }
            }
          }
        } else {
          log('❌ API call failed or no data returned');
          observationList = [];
          filteredObservationList = [];
          selectedLocationData = null;
          _observationResponse =
              ApiResponse.error(message: 'Failed to fetch observation data');
          refreshSearch(); // Refresh search with empty data
        }
      }

      isLoading = false;

      update();
    } catch (e, stacktrace) {
      log("❌ Error fetching observation data: $e");
      log("Stacktrace: $stacktrace");
      observationList = [];
      filteredObservationList = [];
      selectedLocationData = null;
      _observationResponse = ApiResponse.error(message: e.toString());
      refreshSearch(); // Refresh search with empty data
      isLoading = false;
      update();
    }
  }

  ApiResponse _observationResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get observationResponse => _observationResponse;

  Future<void> fetchObservationform({
    required int locationId,
    required int flatId,
    required bool isFlatExistOffline,
    required int observationId,
  }) async {
    _observationResponse =
        ApiResponse.loading(message: 'Loading observation data...');
    log('🔹 fetchObservationform called with locationId=$locationId, flatId=$flatId, isFlatExistOffline=$isFlatExistOffline');
    update();

    try {
      int? finalFlatId = flatId;

      if (finalFlatId == null) {
        log('⚠ flatId not provided');
        _observationResponse = ApiResponse.error(
            message: 'flatId is required if isFlatExistOffline is not mapped');
        update();
        return;
      }

      // ------------------------
      // Load pending offline observations if flat exists locally
      // ------------------------
      List<Map<String, dynamic>> pendingObservations = [];
      if (isFlatExistOffline) {
        String? existingData =
            preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
        if (existingData.isNotEmpty) {
          try {
            var allOfflineData = jsonDecode(existingData) as List<dynamic>;
            for (var flatList in allOfflineData) {
              for (var siteVisit in flatList) {
                for (var location in siteVisit['location_data'] ?? []) {
                  for (var obs in location['observations'] ?? []) {
                    if (obs['is_newly_added'] == true ||
                        obs['is_updated'] == true) {
                      pendingObservations.add(obs);
                    }
                  }
                }
              }
            }
          } catch (e) {
            log('❌ Error decoding existing offline data: $e');
          }
        }
      }

      // ------------------------
      // Call API
      // ------------------------
      final request = {
        "flat_id": finalFlatId,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
      };
      log('🔹 Calling API with request: $request');

      OfflineHqiFlateResponseModel response =
          await ProjectRepo().getHQIFlatsOfflineRepo(body: request);
      log('🔹 API response received with status: ${response.status}');

      if (response.status == "SUCCESS" &&
          response.data != null &&
          response.data!.isNotEmpty) {
        if (isFlatExistOffline) {
          // ------------------------
          // Merge pending offline observations into API response
          // ------------------------
          for (var flatList in response.data!) {
            if (flatList.flatId != finalFlatId) continue;

            for (var location in flatList.locationData ?? []) {
              // Filter pending observations for this location
              final locationPendingObs = pendingObservations.where((obs) {
                if (obs['location_id'] != location.locationId) return false;
                // Only remove current observation if observationId is valid (>0)
                if ((observationId ?? 0) > 0) {
                  return obs['observation_id'] != observationId;
                }
                return true;
              }).toList();

              // Remove old versions of pending observations from API response
              if ((observationId ?? 0) > 0) {
                for (var obs in locationPendingObs) {
                  location.observations?.removeWhere(
                      (o) => o.observationId == obs['observation_id']);
                }
              }

              // Add pending observations
              location.observations?.addAll(locationPendingObs
                  .map((e) => OfflineObservationData.fromJson(e))
                  .toList());

              log('🔹 Merged ${locationPendingObs.length} pending observations into location ${location.locationId}');
            }
          }

          // ------------------------
          // Update localStorage with merged data
          // ------------------------
          String? existingOfflineData =
              preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
          List allOfflineData = existingOfflineData.isNotEmpty
              ? jsonDecode(existingOfflineData)
              : [];

          bool flatUpdated = false;
          for (int i = 0; i < allOfflineData.length; i++) {
            if (allOfflineData[i].isNotEmpty &&
                allOfflineData[i].first['flat_id'] == finalFlatId) {
              allOfflineData[i] = response.data!;
              flatUpdated = true;
              break;
            }
          }

          if (!flatUpdated) {
            allOfflineData.add(response.data!);
          }

          await preferences.putString(
              SharedPreference.hqiFlatsOfflineData, jsonEncode(allOfflineData));
          log('✅ Offline data updated successfully for flatId=$finalFlatId');
        }

        // ------------------------
        // Set selected location data for UI
        // ------------------------
        bool locationFound = false;
        for (var flatList in response.data!) {
          for (var loc in flatList.locationData ?? []) {
            if (loc.locationId == locationId) {
              selectedLocationData = loc;
              observationList = (loc.observations ?? [])
                  .map<OfflineObservationData>((e) =>
                      e is OfflineObservationData
                          ? e
                          : OfflineObservationData.fromJson(e))
                  .toList();
              filteredObservationList = List.from(observationList);
              _observationResponse = ApiResponse.complete(observationList);
              refreshSearch();
              locationFound = true;
              log('✅ Location data set for locationId=$locationId with ${observationList.length} observations');
              break;
            }
          }
          if (locationFound) break;
        }

        if (!locationFound) {
          log('⚠ Location data not found in API response for locationId=$locationId');
          _observationResponse =
              ApiResponse.error(message: 'Location data not found');
        }
      } else {
        log('⚠ API returned no data for flatId=$finalFlatId');
        _observationResponse =
            ApiResponse.error(message: 'No observation data found');
      }

      update();
    } catch (e, stacktrace) {
      log("❌ Error fetching observation data: $e");
      log("Stacktrace: $stacktrace");
      _observationResponse = ApiResponse.error(message: e.toString());
      update();
    }
  }

  ApiResponse _bulkResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get bulkResponse => _bulkResponse;
 Future<void> submitBulkReturnToMaker() async {
  if (selectedObservations.isEmpty) {
    Get.snackbar("Error", "Please select at least one observation");
    return;
  }

  final int finalLocationId =
      selectedLocationData?.locationId ?? 0;

  if (finalLocationId == 0) {
    Get.snackbar("Error", "Location not found");
    return;
  }

  _bulkResponse = ApiResponse.loading(message: "Submitting...");
  update();

  try {
    final selectedIds = selectedObservations.toList();

    debugPrint("SELECTED IDS: $selectedIds");

    final observationsPayload = selectedIds.map((id) {
      final obs = observationList.firstWhere(
        (e) => e.observationId == id,
      );

      return {
        "location_id": obs.locationId,
        "user_id": int.parse(
          preferences.getString(SharedPreference.userId) ?? "0",
        ),
        "observation_id": obs.observationId,
        "issue_category_id": obs.issueCategoryId,
        "issue_type_id": obs.issueTypeId,
        "remark": obs.remark ?? "",
        "state": "return_to_maker",
      };
    }).toList();

    final body = {
      "observations": observationsPayload,
    };

    debugPrint("🔥 FINAL REQUEST BODY: $body");

    final response =
        await ProjectRepo().multiobservationsubmitRepo(body: body);

    if (response.status == "SUCCESS") {
      Get.snackbar("Success", "Submitted Successfully");

      clearSelection();
      selectionMode = false;
      update();

      await getAndStoreData(
        locationId: finalLocationId,
        projectId: "0",
        towerId: "0",
        flatId: "0",
      );
    } else {
      Get.snackbar("Failed", "Submission failed");
    }

    _bulkResponse = ApiResponse.complete(response);
    update();
  } catch (e) {
    _bulkResponse = ApiResponse.error(message: e.toString());
    update();
  }
}
}
