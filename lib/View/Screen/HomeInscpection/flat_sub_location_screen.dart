import 'dart:convert';
import 'dart:developer';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/attachment_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/flat_sub_location_controller.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FlatSubLocationScreen extends StatefulWidget {
  const FlatSubLocationScreen({super.key});

  @override
  State<FlatSubLocationScreen> createState() => _FlatSubLocationScreenState();
}

class _FlatSubLocationScreenState extends State<FlatSubLocationScreen>
    with WidgetsBindingObserver {
  final FlatSubLocationController controller =
      Get.put(FlatSubLocationController());

  String? locationName;
  String? towerName;
  int? locationId;
  String? category;
  bool isOffline = false;
  bool isFlatExistOffline = false;
  // int? observationId;

  //int observationId = Get.arguments['observation_id'];

  int count = Get.arguments['count'] ?? 0;

  String progress = Get.arguments['progress']?.toString() ?? "0";
  String projectId = Get.arguments['project_id']?.toString() ?? "0";
  String towerId = Get.arguments['tower_id']?.toString() ?? "0";
  String flatId = Get.arguments['flat_id']?.toString() ?? "0";

  // LocationData? locationData = Get.arguments['data'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    locationId = Get.arguments['location_id'];
    locationName = Get.arguments['location_name'];
    towerName = Get.arguments['tower_name'];
    category = Get.arguments['name'];
    isOffline = Get.arguments['offline'] ?? false;
    projectId = Get.arguments['project_id']?.toString() ?? "0";
    towerId = Get.arguments['tower_id']?.toString() ?? "0";
    flatId = Get.arguments['flat_id']?.toString() ?? "0";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isFlatExistOffline = await _isFlatExistInOffline();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadData() {
    controller.getAndStoreData(
      projectId: projectId,
      towerId: towerId,
      locationId: locationId ?? 0,
      flatId: flatId,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app is resumed
      _refreshData();
    }
  }

  Future<bool> _isFlatExistInOffline() async {
    log('🔹 Checking if flat exists in localStorage...');

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
          if (location.locationId == locationId) {
            log('✅ Flat with ID ${locationId} exists in offline data');
            return true;
          }
        }
      }
    }

    log('❌ Flat with ID ${locationId} not found in offline data');
    return false;
  }

  // Method to refresh data when returning from Add Observation screen
  void _refreshData() {
    log('🔄 Refreshing observation data...');
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
        color: backGroundColor,
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBarWidget(
            backGroundColor: const Color(0xFF3498DB),
            title: AppString.observation
                .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
          ),
          floatingActionButton: const CommonBackToHomeButton(),
          body: SafeArea(
            child: GetBuilder<FlatSubLocationController>(builder: (controller) {
              if (controller.observationResponse.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (h * 0.03).addHSpace(),
                          Container(
                            padding: EdgeInsets.only(
                                left: w * 0.06,
                                right: w * 0.06,
                                top: h * 0.03,
                                bottom: h * 0.025),
                            decoration: BoxDecoration(
                              color: containerColor,
                              border: Border.all(
                                color: const Color(0xffE6E6E6),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         (locationName ?? 'Location')
                                //             .boldRobotoTextStyle(
                                //                 maxLine: 5, fontSize: 24),
                                //         (towerName ?? 'Tower')
                                //             .regularBarlowTextStyle(
                                //                 fontSize: 12),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (locationName ?? 'Location')
                                              .boldRobotoTextStyle(
                                            maxLine: 5,
                                            fontSize: 24,
                                          ),
                                          (towerName ?? 'Tower')
                                              .regularBarlowTextStyle(
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                (h * 0.01).addHSpace(),
                                // Column(
                                //   children: [
                                //     Divider(
                                //       color: const Color(0xffE6E6E6),
                                //       thickness: 2,
                                //       height: h * 0.02,
                                //     ),
                                //     Row(
                                //       children: [
                                //         'Total Count                :  '
                                //             .boldRobotoTextStyle(fontSize: 12),
                                //         (controller.selectedLocationData
                                //                     ?.observationCount ??
                                //                 0)
                                //             .toString()
                                //             .regularRobotoTextStyle(
                                //                 fontSize: 10),
                                //       ],
                                //     ),
                                //     Row(
                                //       children: [
                                //         'Pending Count          :  '
                                //             .boldRobotoTextStyle(fontSize: 12),
                                //         //   (preferences.getString(SharedPreference.userType) == "hqi_maker"
                                //         ((preferences
                                //                         .getString(
                                //                             SharedPreference
                                //                                 .userType)
                                //                         ?.contains(
                                //                             "hqi_maker") ??
                                //                     false)
                                //                 ? (controller
                                //                         .selectedLocationData
                                //                         ?.makerPendingCount ??
                                //                     0)
                                //                 : (controller
                                //                         .selectedLocationData
                                //                         ?.checkerPendingCount ??
                                //                     0))
                                //             .toString()
                                //             .regularRobotoTextStyle(
                                //                 fontSize: 10),
                                //       ],
                                //     ),
                                //     Row(
                                //       children: [
                                //         'Completed Count    :  '
                                //             .boldRobotoTextStyle(fontSize: 12),
                                //         //  (preferences.getString(SharedPreference.userType) == "hqi_maker"
                                //         ((preferences
                                //                         .getString(
                                //                             SharedPreference
                                //                                 .userType)
                                //                         ?.contains(
                                //                             "hqi_maker") ??
                                //                     false)
                                //                 ? (controller
                                //                         .selectedLocationData
                                //                         ?.makerCompletedCount ??
                                //                     0)
                                //                 : (controller
                                //                         .selectedLocationData
                                //                         ?.checkerCompletedCount ??
                                //                     0))
                                //             .toString()
                                //             .regularRobotoTextStyle(
                                //                 fontSize: 10),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.isDesktop(context)
                                  ? h * 0.028
                                  : h * 0.016,
                            ),
                            child: SearchAndFilterRow(
                              onChanged: (p0) {
                                // Search is handled by controller listener
                              },
                              controller: controller.searchController,
                              hintText: "Search observations...",
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: 1.0.appDivider(color: Colors.black)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AppString.observation
                                    .boldRobotoTextStyle(fontSize: 16),
                              ),
                              Expanded(
                                  child: 1.0.appDivider(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (preferences
                                  .getString(SharedPreference.userType) ==
                              "hqi_checker")

                            // if (preferences.getString(SharedPreference.hqiUserType) == "hqi_checker" ||
                            //     preferences.getString(SharedPreference.hqiUserType) == "hqi_approver")

                            GetBuilder<FlatSubLocationController>(
                                builder: (controller) {
                              final isSelection = controller.selectionMode;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // =========================
                                  // RIGHT SIDE BUTTONS
                                  // =========================
                                  Flexible(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          // =========================
                                          // SELECT / CANCEL BUTTON (MATCH UI)
                                          // =========================
                                          // ElevatedButton(
                                          //   style: ElevatedButton.styleFrom(
                                          //     backgroundColor: containerColor,
                                          //     foregroundColor: Colors.black,
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadius.circular(30),
                                          //     ),
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             horizontal: 18,
                                          //             vertical: 10),
                                          //   ),
                                          //   onPressed:
                                          //       controller.toggleSelectionMode,
                                          //   child: Text(isSelection
                                          //       ? "Cancel"
                                          //       : "Select"),
                                          // ),

                                          const SizedBox(width: 10),

                                          // =========================
                                          // SUBMIT BUTTON (MATCH STYLE TOO)
                                          // =========================
                                          if (isSelection)
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: containerColor,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 10),
                                              ),
                                              onPressed: controller
                                                      .selectedObservations
                                                      .isEmpty
                                                  ? null
                                                  : () {
                                                      controller
                                                          .submitBulkReturnToMaker();
                                                    },
                                              child: Text(
                                                "Submit (${controller.selectedObservations.length})",
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ADD OBSERVATION BUTTON

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: containerColor,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 10),
                                    ),
                                    onPressed: () async {
                                      await Get.toNamed(
                                        Routes.addObservationScreen,
                                        arguments: {
                                          'location_id': locationId,
                                          'location_name': locationName,
                                          'project_id': projectId,
                                          'tower_id': towerId,
                                          'flat_id': flatId,
                                          'tower_name': towerName,
                                          'name': category,
                                          'offline': isOffline,
                                        },
                                      );
                                      _refreshData();
                                    },
                                    child: const Text('Add Observation'),
                                  ),
                                ],
                              );
                            }),

                          // Padding(
                          //   padding: const EdgeInsets.only(left: 200),
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: containerColor,
                          //       foregroundColor: Colors.black,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(30),
                          //       ),
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 16, vertical: 12),
                          //     ),
                          //     onPressed: () async {
                          //       await Get.toNamed(
                          //         Routes.addObservationScreen,
                          //         arguments: {
                          //           'location_id': locationId,
                          //           'location_name': locationName,
                          //           'project_id': projectId,
                          //           'tower_id': towerId,
                          //           'flat_id': flatId,
                          //           'tower_name': towerName,
                          //           'name': category,
                          //           'offline': isOffline,
                          //         },
                          //       );

                          //       // Refresh data when returning from Add Observation screen
                          //       _refreshData();
                          //     },
                          //     child: const Text('Add Observation'),
                          //   ),
                          // ),

                          SizedBox(
                            height: 20,
                          ),
                          if (preferences
                                      .getString(SharedPreference.userType) ==
                                  "hqi_checker" ||
                              (preferences
                                      .getString(SharedPreference.userType)
                                      ?.contains("hqi_maker") ??
                                  false) ||

                              //   preferences.getString(SharedPreference.userType) == "hqi_maker" ||
                              preferences
                                      .getString(SharedPreference.userType) ==
                                  "hqi_approver")
                            if (controller.filteredObservationList.isEmpty)
                              SizedBox(
                                height: h * 0.3,
                                child: const Center(
                                  child: Text(
                                    "No observation data found!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.filteredObservationList.length,
                                  itemBuilder: (context, index) {
                                    final obs = controller
                                        .filteredObservationList[index];

                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print(
                                                'obs:::::::::::::sequence:::${obs.visitDetails?.sequence}   :   ${obs.state}');
                                            print(
                                                'obs:::::::::::::observationList:::${obs.toJson()}');
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  AttachmentDialogPopup(
                                                observationData: obs,
                                                observationId:
                                                    obs.observationId ?? 0,
                                                locationId: obs.locationId ?? 0,
                                                state: obs.state ?? '',
                                                sequence: obs.sequence ?? 0,
                                                visitDetails: obs.visitDetails!,
                                                projectId: int.parse(
                                                    projectId.toString()),
                                                flatId: int.parse(
                                                    flatId.toString()),
                                                observationCategory:
                                                    obs.observationCategory ??
                                                        '',
                                                isOffline: isOffline || isFlatExistOffline,
                                              ),
                                            ).then(
                                              (value) {
                                                log('isFlatExistOffline:::::::value:::::::::${isFlatExistOffline} : ${value}');
                                                // if (isFlatExistOffline) {
                                                if (isFlatExistOffline || isOffline || value == true) {
                                                  _refreshData();
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: h * 0.015,
                                                horizontal: w * 0.035),
                                            decoration: BoxDecoration(
                                              color: containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                // ✅ CHECKBOX (only in selection mode)
                                                if (controller.selectionMode)
                                                  Obx(() {
                                                    final isChecked =
                                                        controller.isSelected(
                                                            obs.observationId ??
                                                                0);

                                                    return Checkbox(
                                                      value: isChecked,
                                                      onChanged: (_) {
                                                        controller.toggleSelection(
                                                            obs.observationId ??
                                                                0);
                                                      },
                                                    );
                                                  }),

                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: obs.color ==
                                                          'green'
                                                      ? greenColor
                                                      : obs.color == 'orange'
                                                          ? orangeColor
                                                          : obs.color ==
                                                                  'yellow'
                                                              ? yellowColor
                                                              : redColor,
                                                ),
                                                SizedBox(width: w * 0.03),

                                                // 👆 Issue Category Name - tappable
                                                Expanded(
                                                  child: Text(
                                                    obs.issueCategoryName ??
                                                        "No Activity",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.done_all,
                                                  size: 16,
                                                  color: obs.color == 'green'
                                                      ? greenColor
                                                      : obs.color == 'orange'
                                                          ? orangeColor
                                                          : obs.color ==
                                                                  'yellow'
                                                              ? yellowColor
                                                              : redColor,
                                                ),

                                                // 🎯 Impact Tag
                                                // Container(
                                                //   margin: const EdgeInsets
                                                //       .symmetric(horizontal: 6),
                                                //   padding: const EdgeInsets
                                                //       .symmetric(
                                                //       horizontal: 10,
                                                //       vertical: 3),
                                                //   decoration: BoxDecoration(
                                                //     color: containerColor,
                                                //     border: Border.all(
                                                //         color: Colors.black),
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             8),
                                                //   ),
                                                //   // child: Text(
                                                //   //   obs.impact
                                                //   //           ?.capitalizeFirst ??
                                                //   //       'Impact',
                                                //   //   style: const TextStyle(
                                                //   //       fontSize: 13,
                                                //   //       fontWeight:
                                                //   //           FontWeight.w500),
                                                //   // ),
                                                // ),

                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    final observation = controller
                                                            .filteredObservationList[
                                                        index];
                                                    final obsId = observation
                                                        .observationId;

                                                    if (obsId != null) {
                                                      debugPrint(
                                                          "✅ observationId passed: $obsId");
                                                      Get.toNamed(
                                                        Routes
                                                            .observationHistoryScreen,
                                                        arguments: {
                                                          "observation_id":
                                                              obsId,
                                                          "state":
                                                              observation.state,
                                                        },
                                                      );
                                                    } else {
                                                      debugPrint(
                                                          "❌ observationId is null for selected item.");
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: h * 0.01),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: h * 0.008,
                                              bottom: h * 0.017),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              // children: [
                                              //   AppString.lastUpdateTime
                                              //       .semiBoldBarlowTextStyle(
                                              //           fontSize: 11),
                                              //   Text(
                                              //     DateFormat('dd/MM/yyyy')
                                              //         .format(
                                              //       obs.date != null
                                              //           ? DateTime.tryParse(
                                              //                   obs.date!) ??
                                              //               DateTime.now()
                                              //           : DateTime.now(),
                                              //     )
                                              //   ),
                                              // ],

                                              children: [
                                                AppString.lastUpdateTime
                                                    .semiBoldBarlowTextStyle(
                                                        fontSize: 11),
                                                DateFormat('dd/MM/yyyy hh:mm')
                                                    .format(DateTime.now())
                                                    .regularRobotoTextStyle(
                                                        fontSize: 11),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                        ],
                      ),
                    ),

                    /// Last Updated Times
                  ],
                ),
              );
            }),
          ),
        ));
  }

  Future<void> saveForOfflineUse(BuildContext context, double h, double w) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: "Saved Activity".semiBoldBarlowTextStyle(
                fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This activity data saved successfully for offline use. You can store a maximum of 5 activity data for offline use"
                    .regularRobotoTextStyle(
                        fontSize: 15, textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Get.back();
              },
              color: appColor,
              height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: "Okay".boldRobotoTextStyle(
                    fontSize: 16, fontColor: backGroundColor),
              ),
            )
          ],
        );
      },
    );
  }
}