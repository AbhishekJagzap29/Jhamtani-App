import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/add_observation_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_flat_list_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ShowSaveHQIScreen extends StatefulWidget {
  const ShowSaveHQIScreen({super.key});

  @override
  State<ShowSaveHQIScreen> createState() => _ShowSaveHQIScreenState();
}

class _ShowSaveHQIScreenState extends State<ShowSaveHQIScreen> {
  final HQIFlatListController controller = Get.put(HQIFlatListController());
  final AddObservationController addObservationController = Get.put(AddObservationController());
  NetworkController networkController = Get.put(NetworkController());

  bool showLoader = false;
  List<List<OfflineHQIData>> offlineHQIData = [];

  String? projectId;
  String? towerId;
  String? flatId;
  String? flatName;
  String? towerName;
  int? count;
  String? progress;
  String? visitName;
  int? visitId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
    super.initState();
  }

  void getData() {
    offlineHQIData = []; // This should be declared as List<List<OfflineHQIData>>

    setState(() {
      showLoader = true;
    });

    String? hqiRaw = preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
    log('hqiRaw::::::::: $hqiRaw');

    if (hqiRaw.isNotEmpty) {
      try {
        final List<dynamic> parsed = jsonDecode(hqiRaw);

        offlineHQIData = parsed.map<List<OfflineHQIData>>((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        log('✅ Offline HQI Data loaded: ${offlineHQIData.length} flats');
        log('✅ Full offlineHQIData: ${jsonEncode(offlineHQIData)}');
      } catch (e) {
        log('❌ Error decoding offline HQI data: $e');
      }
    }

    setState(() {
      showLoader = false;
    });
  }

  /// Delete Offline Flat functionality
  Future<void> _deleteOfflineFlat(OfflineHQIData flatData) async {
    try {
      // Show confirmation dialog
      bool? shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Offline Data'),
            content: Text('Are you sure you want to delete offline data for flat "${flatData.flatName}"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        setState(() {
          showLoader = true;
        });

        // Get current offline data
        String? hqiRaw = preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
        if (hqiRaw.isNotEmpty) {
          List<List<OfflineHQIData>> allOfflineData = [];
          try {
            final List<dynamic> parsed = jsonDecode(hqiRaw);
            allOfflineData = parsed.map<List<OfflineHQIData>>((sublist) {
              if (sublist is List) {
                return sublist.map<OfflineHQIData>((item) {
                  return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
                }).toList();
              }
              return <OfflineHQIData>[];
            }).toList();

            // Remove the selected flat
            allOfflineData.removeWhere((flatList) => flatList.isNotEmpty && flatList.first.flatId == flatData.flatId);

            // Save updated data back to local storage
            String updatedData = jsonEncode(allOfflineData.map((sublist) => sublist.map((item) => item.toJson()).toList()).toList());
            await preferences.putString(SharedPreference.hqiFlatsOfflineData, updatedData);

            // Refresh the UI
            getData();
            successSnackBar("Success", "Offline data deleted successfully");
          } catch (e) {
            log('❌ Error deleting offline flat: $e');
            errorSnackBar("Error", "Failed to delete offline data");
          }
        }

        setState(() {
          showLoader = false;
        });
      }
    } catch (e) {
      log('❌ Error in _deleteOfflineFlat: $e');
      errorSnackBar("Error", "Failed to delete offline data");
      setState(() {
        showLoader = false;
      });
    }
  }

  /// Sync Data for selected flat functionality
  Future<void> _syncDataForFlat(OfflineHQIData flatData) async {
    // try {
    setState(() {
      showLoader = true;
    });

    // Get current offline data
    String? hqiRaw = preferences.getString(SharedPreference.hqiFlatsOfflineData) ?? '';
    if (hqiRaw.isEmpty) {
      errorSnackBar("Error", "No offline data found");
      setState(() {
        showLoader = false;
      });
      return;
    }

    List<List<OfflineHQIData>> allOfflineData = [];
    try {
      final List<dynamic> parsed = jsonDecode(hqiRaw);
      allOfflineData = parsed.map<List<OfflineHQIData>>((sublist) {
        if (sublist is List) {
          return sublist.map<OfflineHQIData>((item) {
            return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
          }).toList();
        }
        return <OfflineHQIData>[];
      }).toList();
    } catch (e) {
      log('❌ Error decoding offline data: $e');
      errorSnackBar("Error", "Failed to decode offline data");
      setState(() {
        showLoader = false;
      });
      return;
    }

    // Find the selected flat in offline data
    List<OfflineHQIData>? selectedFlatList;
    int flatIndex = -1;
    for (int i = 0; i < allOfflineData.length; i++) {
      if (allOfflineData[i].isNotEmpty && allOfflineData[i].first.flatId == flatData.flatId) {
        selectedFlatList = allOfflineData[i];
        flatIndex = i;
        break;
      }
    }

    if (selectedFlatList == null || flatIndex == -1) {
      errorSnackBar("Error", "Selected flat not found in offline data");
      setState(() {
        showLoader = false;
      });
      return;
    }

    // Collect all observations that need to be synced
    List<OfflineObservationData> observationsToSync = [];
    for (var flat in selectedFlatList) {
      for (var location in flat.locationData ?? []) {
        for (var observation in location.observations ?? []) {
          if ((observation.isNewlyAdded == true || observation.isUpdated == true) && observation.syncStatus == "pending") {
            observationsToSync.add(observation);
          }
        }
      }
    }

    if (observationsToSync.isEmpty) {
      successSnackBar("Info", "No observations to sync for this flat");
      setState(() {
        showLoader = false;
      });
      return;
    }

    log('🔹 Found ${observationsToSync.length} observations to sync');

    // Submit each observation one by one
    int successCount = 0;
    int totalCount = observationsToSync.length;

    for (var observation in observationsToSync) {
      // try {
      // Convert images to files
      List<File> imageFiles = [];
      List<File> imageFiles2 = [];
      for (var imgData in observation.imgData ?? []) {
        // afterImageList Convert images to files

        for (var imgData in observation.imgData ?? []) {
          // Checker image
          final checkerPath = imgData.checkerUploadedImg;
          if (checkerPath != null && checkerPath.isNotEmpty && !checkerPath.contains('http://')) {
            final file = File(checkerPath);
            if (file.existsSync()) {
              imageFiles.add(file);
            }
          }

          // Maker image
          final makerPath = imgData.makerUploadedImg;
          if (makerPath != null && makerPath.isNotEmpty && !makerPath.contains('http://')) {
            final file = File(makerPath);
            if (file.existsSync()) {
              imageFiles2.add(file);
            }
          }
        }
      }

      // Submit observation using AddObservationController
      await addObservationController.submitObservation(
        category: observation.issueCategoryId?.toString() ?? "",
        issueType: observation.issueTypeId?.toString() ?? "",
        description: observation.description ?? "",
        impact: observation.impact ?? "low",
        date: observation.date?.toIso8601String() ?? DateTime.now().toIso8601String(),
        locationId: observation.locationId ?? 0,
        name: observation.name ?? "",
        remark: observation.remark ?? "",
        observationId: observation.observationId,
        targetDate: observation.targetDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        state: observation.state,
        userId: observation.userId?.toString() ?? "",
        beforeImages: imageFiles,
        afterImages: imageFiles2,
        impactType: observation.impactType,
      );

      if (addObservationController.submitObservationResponse.status == Status.COMPLETE) {
        successCount++;
        log('✅ Observation ${observation.observationId} synced successfully');

        // Update observation status in local storage
        await _updateObservationStatusInLocalStorage(
            allOfflineData, flatData.flatId!, observation.locationId!, observation.observationId!, "synced");
      } else {
        log('❌ Failed to sync observation ${observation.observationId}: ${addObservationController.submitObservationResponse.message}');
      }
      // } catch (e) {
      //   log('❌ Error syncing observation ${observation.observationId}: $e');
      // }
    }

    // After all observations are processed, call API to refresh data
    if (successCount > 0) {
      try {
        log('🔹 Calling API to refresh flat data after sync');
        final response = await addObservationController.getHQIFlatsOfflineRepo(
          body: {
            "flat_id": flatData.flatId.toString(),
            "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
          },
        );

        if (response.status == "SUCCESS" && response.data != null && response.data!.isNotEmpty) {
          // Update local storage with fresh data from API
          await _updateLocalStorageWithAPIData(allOfflineData, response.data!, flatIndex);
          log('✅ Local storage updated with fresh API data');
        }
      } catch (e) {
        log('⚠️ Warning: Failed to refresh data from API: $e');
      }
    }

    // Show success message
    if (successCount == totalCount) {
      successSnackBar("Success", "All observations synced successfully for flat ${flatData.flatName}");
    } else if (successCount > 0) {
      successSnackBar("Partial Success", "$successCount out of $totalCount observations synced successfully");
    } else {
      errorSnackBar("Error", "Failed to sync any observations");
    }

    // Refresh the UI
    getData();
    setState(() {
      showLoader = false;
    });
    /*  } catch (e) {
      log('❌ Error in _syncDataForFlat: $e');
      errorSnackBar("Error", "Failed to sync data: $e");
    } finally {
      setState(() {
        showLoader = false;
      });
    }*/
  }

  /// Update observation status in local storage
  Future<void> _updateObservationStatusInLocalStorage(
    List<List<OfflineHQIData>> allOfflineData,
    int flatId,
    int locationId,
    int observationId,
    String newStatus,
  ) async {
    try {
      for (var flatList in allOfflineData) {
        for (var flat in flatList) {
          if (flat.flatId == flatId) {
            for (var location in flat.locationData ?? []) {
              if (location.locationId == locationId) {
                for (int i = 0; i < (location.observations ?? []).length; i++) {
                  var observation = location.observations![i];
                  if (observation.observationId == observationId) {
                    location.observations![i] = observation.copyWith(
                      isNewlyAdded: false,
                      isUpdated: false,
                      syncStatus: newStatus,
                      syncErrorMessage: null,
                    );
                    break;
                  }
                }
                break;
              }
            }
            break;
          }
        }
      }

      // Save updated data back to local storage
      String updatedData = jsonEncode(allOfflineData.map((sublist) => sublist.map((item) => item.toJson()).toList()).toList());
      await preferences.putString(SharedPreference.hqiFlatsOfflineData, updatedData);
      log('✅ Observation status updated in local storage');
    } catch (e) {
      log('❌ Error updating observation status: $e');
    }
  }

  /// Update local storage with fresh API data
  Future<void> _updateLocalStorageWithAPIData(
    List<List<OfflineHQIData>> allOfflineData,
    List<OfflineHQIData> apiData,
    int flatIndex,
  ) async {
    try {
      // Replace the flat data at the specified index
      allOfflineData[flatIndex] = apiData;

      // Save updated data back to local storage
      String updatedData = jsonEncode(allOfflineData.map((sublist) => sublist.map((item) => item.toJson()).toList()).toList());
      await preferences.putString(SharedPreference.hqiFlatsOfflineData, updatedData);
      log('✅ Local storage updated with fresh API data');
    } catch (e) {
      log('❌ Error updating local storage with API data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    log('offlineHQIData.length::::::::::::::::${offlineHQIData.length}');
    return GetBuilder<NetworkController>(
      builder: (netController) {
        return Container(
          color: backGroundColor,
          child: Scaffold(
            backgroundColor: const Color(0xffFDFDFD),
            appBar: AppBarWidget(
              centerTitle: true,
              backGroundColor: const Color(0xFF3498DB),
              title: AppString.savedActivity.boldRobotoTextStyle(fontSize: 20,  fontColor: Colors.white,),
              action: [
                /// Sync Button
                /*      offlineHQIData.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(h * 0.003),
                        child: MaterialButton(
                          onPressed: () async {
                            // await controller.syncData();
                            // setState(() {});
                          },
                          color: appColor,
                          height: h * 0.058,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppString.syncData.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                              (w * 0.02).addWSpace(),
                              const Icon(Icons.sync, color: Colors.white),
                            ],
                          ),
                        ).paddingSymmetric(vertical: h * 0.005, horizontal: w * 0.015),
                      )
                    : const SizedBox()*/
              ],
            ),
            body: showLoader
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05).copyWith(
                      top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (offlineHQIData.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 300),
                            child: Center(child: Text('No saved Flat found!')),
                          ),
                        if (offlineHQIData.isNotEmpty)
                          ...List.generate(offlineHQIData.length, (index) {
                            final item = offlineHQIData[index];
                            log('item::::::::::::$index::::$item');
                            var issueType = "-";

                            if (item.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            if (item.first.locationData?.isNotEmpty == true) {
                              if (item.first.locationData?.first.observations?.isNotEmpty == true) {
                                issueType = item.first.locationData?.first.observations?.first.issueTypeName ?? "-";
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                log('item.first::::::::::::::::$item');

                                List<FlatVisitDataOffline> visitData = item.map(FlatVisitDataOffline.fromOffline).toList();

                                log('visitData::::::::::::::::$visitData');
                                Get.toNamed(
                                  Routes.siteVisitListViewScreen,
                                  arguments: {
                                    "project_id": item.first.projectId.toString(),
                                    "tower_id": item.first.towerId.toString(),
                                    "tower_name": item.first.towerName ?? "",
                                    "flat_id": item.first.flatId.toString(),
                                    "flat_name": item.first.flatName ?? "",
                                    "count": null, // or item.count if available
                                    "progress": null, // or item.progress if available
                                    "data": visitData,
                                    "offline": true, // you can add this if needed in your screen logic
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.017,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 12,
                                        ),
                                        (w * 0.03).addWSpace(),
                                        Expanded(
                                          child: "Flat Number : ${item.first.flatName ?? ''}".boldRobotoTextStyle(
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (h * 0.01).addHSpace(),
                                    Container(
                                      // height: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                        vertical: h * 0.008,
                                        horizontal: w * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: greyTextColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Tower Name: ${item.first.towerName ?? ''}"),
                                                Text("Project Name: ${item.first.projectName ?? ''}"),
                                              ],
                                            ),
                                            PopupMenuButton<String>(
                                              icon: const Icon(Icons.more_vert, size: 20),
                                              onSelected: (value) async {
                                                if (value == 'delete_offline') {
                                                  await _deleteOfflineFlat(item.first);
                                                }

                                                // Sync Button
                                                /*        else {
                                                          if (netController.isResult == false) {
                                                            if (value == 'sync_data') {
                                                              await _syncDataForFlat(item.first);
                                                            }
                                                          } else {
                                                            errorSnackBar("Error!", "no internet connection");
                                                          }
                                                        }*/
                                              },
                                              itemBuilder: (context) => [
                                                /*       const PopupMenuItem<String>(
                                                          value: 'sync_data',
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.sync, color: appColor, size: 18),
                                                              SizedBox(width: 6),
                                                              Text("Sync Data", style: TextStyle(fontSize: 13)),
                                                            ],
                                                          ),
                                                        ),*/
                                                const PopupMenuItem<String>(
                                                  value: 'delete_offline',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, color: appColor, size: 18),
                                                      SizedBox(width: 6),
                                                      Text("Delete Offline", style: TextStyle(fontSize: 13)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
