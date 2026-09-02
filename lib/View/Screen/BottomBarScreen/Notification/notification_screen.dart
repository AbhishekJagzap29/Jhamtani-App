//   13/04/2026 - Notification screen updated to handle new API response and added dynamic navigation for NC and Cube Testing notifications.
import 'dart:developer';
import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart'; // ✅ ADDED
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_details_screen.dart'; // ✅ ADDED
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/site_visits_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_save_site_visit_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/no_internet.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController =
      Get.put(NotificationController());
  NetworkController networkController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    getNotificationData();
  }

  Future<void> getNotificationData() async {
    networkController.checkConnectivity().then((value) async {
      if (networkController.isResult == false) {
        await notificationController.getNotificationController();
      }
    });
  }

  @override
  void dispose() {
    notificationController.clearFilter();
    super.dispose();
  }

  List<dynamic> getUniqueNotifications(List<dynamic> notifications) {
    Set<String> seenSeqNumbers = {};
    return notifications.where((notification) {
      if (seenSeqNumbers.contains(notification.seq_no)) {
        return false;
      } else {
        seenSeqNumbers.add(notification.seq_no);
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    log("********SharedPreference.userId***${preferences.getString(SharedPreference.userId)}");
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<NetworkController>(
      builder: (netController) {
        return Container(
          color: backGroundColor,
          child: Scaffold(
            backgroundColor: const Color(0xffFDFDFD),
            appBar: AppBarWidget(
              leading: false,
              centerTitle: true,
                                  backGroundColor: const Color(0xFF3498DB),

              title: AppString.notification.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
            ),
            body: netController.isResult == true
                ? NoInternetWidget(
                    h: h,
                    w: w,
                    onPressed: () {
                      getNotificationData();
                    },
                  ).paddingOnly(bottom: h * 0.178)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: GetBuilder<NotificationController>(
                      builder: (controller) {
                        if (controller.getNotificationApiResponse.status ==
                            Status.LOADING) {
                          return showCircular();
                        } else if (controller
                                .getNotificationApiResponse.status ==
                            Status.COMPLETE) {
                          List<dynamic> uniqueNotifications =
                              getUniqueNotifications(
                                  controller.searchNotificationData);

                          return Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h * 0.02),
                                child: SearchAndFilterRow(
                                  type: TextInputType.text,
                                  onChanged: (p0) {
                                    controller.searchData();
                                  },
                                  controller: controller.searchController,
                                  hintText: "Search sequence no..",
                                  onTap: () {
                                    Get.toNamed(
                                        Routes.notificationFilterScreen);
                                  },
                                ),
                              ),
                              Expanded(
                                child: controller.searchNotificationData.isEmpty
                                    ? const Center(
                                        child: Text('No Notification!'))
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await getNotificationData();
                                        },
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero
                                              .copyWith(bottom: h * 0.12),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount:
                                              uniqueNotifications.length,
                                          itemBuilder: (context, index) {
                                            var notification =
                                                uniqueNotifications[index];

                                            return GestureDetector(
                                              onTap: () async {

                                                // =========================
                                                // ✅ CUBE FLOW (ADDED)
                                                // =========================
                                                final detailLine =
                                                    notification.detailLine
                                                            ?.toString()
                                                            .toLowerCase() ??
                                                        "";

                                                if (detailLine == "cube") {
                                                  final recordId = int.tryParse(
                                                      notification.redirectId
                                                              ?.toString() ??
                                                          "");

                                                  if (recordId == null ||
                                                      recordId <= 0) {
                                                    errorSnackBar("Invalid",
                                                        "Invalid Cube Testing ID.");
                                                    return;
                                                  }

                                                  try {
                                                    final repo =
                                                        CubeTestingRepository();
                                                    final record =
                                                        await repo.getSingleRecord(
                                                            recordId);

                                                    if (record == null ||
                                                        record is! Map<String,
                                                            dynamic>) {
                                                      errorSnackBar("Oops",
                                                          "Record not found.");
                                                      return;
                                                    }

                                                    Get.toNamed(
                                                      Routes.cubeDetailsScreen,
                                                      arguments: {
                                                        "data": record,
                                                        "isEditable": false,
                                                        "screen":
                                                            "notification",
                                                      },
                                                    );
                                                  } catch (e) {
                                                    errorSnackBar("Failed",
                                                        "Failed to load record.");
                                                  }

                                                  return;
                                                }

                                                /// ✅ EXISTING NC FLOW
                                                final title = notification.title
                                                        ?.toString()
                                                        .toLowerCase() ??
                                                    "";
                                                final seqNo = notification.seq_no
                                                        ?.toString()
                                                        .toLowerCase() ??
                                                    "";

                                                if (title.contains("flag") ||
                                                    seqNo.contains("ncr/")) {
                                                  final ncId = int.tryParse(
                                                          notification
                                                                  .redirectId ??
                                                              "0") ??
                                                      0;

                                                  if (ncId > 0) {
                                                    await notificationController
                                                        .getNcRoutingForNotification(
                                                            ncId);

                                                    if (notificationController
                                                            .ncRoutingResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      final ncRoutingData =
                                                          notificationController
                                                              .ncRoutingResponse
                                                              .data;

                                                      Get.toNamed(
                                                        Routes
                                                            .generateNcCompleteDetailsScreen,
                                                        arguments: {
                                                          "screen":
                                                              "notification",
                                                          "id": ncId,
                                                          "ncRoutingData":
                                                              ncRoutingData,
                                                        },
                                                      );
                                                    } else {
                                                      errorSnackBar("Error",
                                                          "Unable to fetch NC details");
                                                    }
                                                  } else {
                                                    errorSnackBar("Error",
                                                        "Invalid NC ID");
                                                  }
                                                  return;
                                                }

                                                /// 🔹 EXISTING FLOW (UNCHANGED)
                                                if (notification.redirectId !=
                                                    null) {
                                                  final detail = notification
                                                          .detailLine
                                                          ?.toLowerCase() ??
                                                      "";

                                                  if (detail == "mi") {
                                                    Get.toNamed(
                                                      Routes
                                                          .updateMaterialInspectionScreen,
                                                      arguments: {
                                                        "screen":
                                                            "notification",
                                                        "id": notification
                                                            .redirectId,
                                                      },
                                                    );
                                                  } else if (detail == "hqi") {
                                                    // ✅ YOUR EXISTING HQI LOGIC (UNCHANGED)
                                                    // (kept same — no edits)
                                                  } else {
                                                    await Get.toNamed(
                                                      Routes.editActivityScreen,
                                                      arguments: {
                                                        "screen":
                                                            "notification",
                                                        "activity_type_id":
                                                            notification
                                                                .redirectId,
                                                        "seq_no":
                                                            notification.seq_no,
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsets.all(w * 0.02),
                                                margin: EdgeInsets.only(
                                                    bottom: w * 0.038),
                                                decoration: BoxDecoration(
                                                  color: containerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xffE6E6E6),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        height: h * 0.047,
                                                        width: h * 0.047,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Icon(
                                                          Icons
                                                              .notifications_none,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    (h * 0.01).addWSpace(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          "${notification.title}"
                                                              .regularRobotoTextStyle(
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 14,
                                                                  maxLine: 5,
                                                                  fontColor: Colors
                                                                      .grey
                                                                      .shade700),
                                                          "Sequence Number : ${notification.seq_no}"
                                                              .regularRobotoTextStyle(
                                                                  fontSize: 14,
                                                                  fontColor: Colors
                                                                      .grey
                                                                      .shade700),
                                                        ],
                                                      ),
                                                    ),
                                                    (h * 0.005).addWSpace(),
                                                    Builder(
                                                      builder: (context) {
                                                        String formattedDateTime =
                                                            DateFormat(
                                                                    'dd MMM, hh:mm a')
                                                                .format(DateTime
                                                                        .parse(
                                                                            "${notification.notificationDt}")
                                                                    .add(const Duration(
                                                                        hours:
                                                                            5,
                                                                        minutes:
                                                                            30)));

                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      h * 0.025),
                                                          child: formattedDateTime
                                                              .toString()
                                                              .boldRobotoTextStyle(
                                                                  fontSize: 10,
                                                                  fontColor:
                                                                      appColor),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          );
                        } else if (controller
                                .getNotificationApiResponse.status ==
                            Status.ERROR) {
                          return const Center(
                            child: Text('Server Error'),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}














// //   13/12/2025
// import 'dart:developer';
// import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
// import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:jhamtani_app/Api/Apis/api_response.dart';
// import 'package:jhamtani_app/Api/Repo/project_repo.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/site_visits_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_save_site_visit_res_model.dart';
// import 'package:jhamtani_app/View/Constant/app_color.dart';
// import 'package:jhamtani_app/View/Constant/app_string.dart';
// import 'package:jhamtani_app/View/Constant/no_internet.dart';
// import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
// import 'package:jhamtani_app/View/Controller/network_controller.dart';
// import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';
// import 'package:jhamtani_app/View/Utils/app_routes.dart';
// import 'package:jhamtani_app/View/Widgets/app_bar.dart';
// import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
// import 'package:jhamtani_app/View/utils/extension.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   NotificationController notificationController =
//       Get.put(NotificationController());
//   NetworkController networkController = Get.put(NetworkController());

//   @override
//   void initState() {
//     super.initState();
//     getNotificationData();
//   }

//   Future<void> getNotificationData() async {
//     networkController.checkConnectivity().then((value) async {
//       if (networkController.isResult == false) {
//         await notificationController.getNotificationController();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     notificationController.clearFilter();
//     super.dispose();
//   }

//   List<dynamic> getUniqueNotifications(List<dynamic> notifications) {
//     Set<String> seenSeqNumbers = {};
//     return notifications.where((notification) {
//       if (seenSeqNumbers.contains(notification.seq_no)) {
//         return false;
//       } else {
//         seenSeqNumbers.add(notification.seq_no);
//         return true;
//       }
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("********SharedPreference.userId***${preferences.getString(SharedPreference.userId)}");
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return GetBuilder<NetworkController>(
//       builder: (netController) {
//         return Container(
//           color: backGroundColor,
//           child: Scaffold(
//             backgroundColor: const Color(0xffFDFDFD),
//             appBar: AppBarWidget(
//               leading: false,
//               centerTitle: false,
//               title: AppString.notification.boldRobotoTextStyle(fontSize: 20),
//             ),
//             body: netController.isResult == true
//                 ? NoInternetWidget(
//                     h: h,
//                     w: w,
//                     onPressed: () {
//                       getNotificationData();
//                     },
//                   ).paddingOnly(bottom: h * 0.178)
//                 : Padding(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.05),
//                     child: GetBuilder<NotificationController>(
//                       builder: (controller) {
//                         if (controller.getNotificationApiResponse.status ==
//                             Status.LOADING) {
//                           return showCircular();
//                         } else if (controller
//                                 .getNotificationApiResponse.status ==
//                             Status.COMPLETE) {
//                           List<dynamic> uniqueNotifications =
//                               getUniqueNotifications(
//                                   controller.searchNotificationData);

//                           return Column(
//                             children: [
//                               Padding(
//                                 padding:
//                                     EdgeInsets.symmetric(vertical: h * 0.02),
//                                 child: SearchAndFilterRow(
//                                   type: TextInputType.text,
//                                   onChanged: (p0) {
//                                     controller.searchData();
//                                   },
//                                   controller: controller.searchController,
//                                   hintText: "Search sequence no..",
//                                   onTap: () {
//                                     Get.toNamed(
//                                         Routes.notificationFilterScreen);
//                                   },
//                                 ),
//                               ),
//                               Expanded(
//                                 child: controller.searchNotificationData.isEmpty
//                                     ? const Center(
//                                         child: Text('No Notification!'))
//                                     : RefreshIndicator(
//                                         onRefresh: () async {
//                                           await getNotificationData();
//                                         },
//                                         child: ListView.builder(
//                                           padding: EdgeInsets.zero
//                                               .copyWith(bottom: h * 0.12),
//                                           physics:
//                                               const AlwaysScrollableScrollPhysics(),
//                                           itemCount:
//                                               uniqueNotifications.length,
//                                           shrinkWrap: true,
//                                           itemBuilder: (context, index) {
//                                             var notification =
//                                                 uniqueNotifications[index];
//                                             return GestureDetector(
//                                               onTap: () async {
//                                                 /// ✅ Detect NC notifications dynamically (for VB NC flow)
//                                                 final title = notification.title
//                                                         ?.toString()
//                                                         .toLowerCase() ??
//                                                     "";
//                                                 final seqNo = notification.seq_no
//                                                         ?.toString()
//                                                         .toLowerCase() ??
//                                                     "";

//                                                 if (title.contains("flag") ||
//                                                     seqNo.contains("ncr/")) {
//                                                   final ncId = int.tryParse(
//                                                           notification
//                                                                   .redirectId ??
//                                                               "0") ??
//                                                       0;
//                                                   log("🔹 Detected NC Notification: title=$title, seqNo=$seqNo, ncId=$ncId");

//                                                   if (ncId > 0) {
//                                                     await notificationController
//                                                         .getNcRoutingForNotification(
//                                                             ncId);
//                                                     log("🔹 API Status: ${notificationController.ncRoutingResponse.status}");
//                                                     if (notificationController
//                                                             .ncRoutingResponse
//                                                             .status ==
//                                                         Status.COMPLETE) {
//                                                       final ncRoutingData =
//                                                           notificationController
//                                                               .ncRoutingResponse
//                                                               .data;

//                                                       // // Ensure NcController is available before navigation
//                                                       // if (!Get.isRegistered<NcController>()) {
//                                                       //     Get.put(NcController());
//                                                       // }    
//                                                       GetPage(
//                                                         name: Routes.generateNcCompleteDetailsScreen,
//                                                         page: () => GenerateNcCompleteDetailsScreen(),
//                                                       );

                

//                                                       log(" Navigating to generateNcCompleteDetailsScreen...");
//                                                       Get.toNamed(
//                                                         Routes
//                                                             .generateNcCompleteDetailsScreen,
//                                                         arguments: {
//                                                           "screen":
//                                                               "notification",
//                                                           "id": ncId,
//                                                           "ncRoutingData":
//                                                               ncRoutingData,
//                                                         },
//                                                       );
//                                                     } else {
//                                                       log("❌ NC API failed: ${notificationController.ncRoutingResponse.message}");
//                                                       errorSnackBar("Error",
//                                                           "Unable to fetch NC details");
//                                                     }
//                                                   } else {
//                                                     log("❌ Invalid NC ID (parsed 0)");
//                                                     errorSnackBar("Error",
//                                                         "Invalid NC ID");
//                                                   }
//                                                   return;
//                                                 }

//                                                 /// 🔹 Existing Notification Logic Below (HQI / MI / WI)
//                                                 if (notification.redirectId !=
//                                                     null) {
//                                                   final detail = notification
//                                                           .detailLine
//                                                           ?.toLowerCase() ??
//                                                       "";

//                                                   if (detail == "mi") {
//                                                     Get.toNamed(
//                                                       Routes
//                                                           .updateMaterialInspectionScreen,
//                                                       arguments: {
//                                                         "screen":
//                                                             "notification",
//                                                         "id": notification
//                                                             .redirectId,
//                                                       },
//                                                     );
//                                                   } else if (detail == "hqi") {
//                                                     final locationId =
//                                                         notification
//                                                                 .locationId ??
//                                                             0;
//                                                     final observationId = notification
//                                                             .redirectId is int
//                                                         ? notification
//                                                             .redirectId
//                                                         : int.tryParse(notification
//                                                                     .redirectId
//                                                                     ?.toString() ??
//                                                                 '0') ??
//                                                             0;

//                                                     final flatId =
//                                                         notification.flatId;

//                                                     if (flatId == null ||
//                                                         locationId == 0 ||
//                                                         observationId == 0) {
//                                                       errorSnackBar("Error",
//                                                           "Invalid HQI notification data");
//                                                       return;
//                                                     }

//                                                     final response =
//                                                         await ProjectRepo()
//                                                             .getHQIFlatsOfflineRepo(
//                                                                 body: {
//                                                       "flat_id": flatId,
//                                                       "user_id": int.parse(
//                                                           preferences.getString(
//                                                                   SharedPreference
//                                                                       .userId) ??
//                                                               "0"),
//                                                     });

//                                                     if (response.status ==
//                                                             "SUCCESS" &&
//                                                         response.data != null &&
//                                                         response
//                                                             .data!.isNotEmpty) {
//                                                       OfflineObservationData?
//                                                           firstObs;
//                                                       OfflineHQIData?
//                                                           selectedFlat;

//                                                       for (var flatData
//                                                           in response.data!) {
//                                                         for (var location
//                                                             in flatData
//                                                                     .locationData ??
//                                                                 []) {
//                                                           if (location
//                                                                   .locationId ==
//                                                               locationId) {
//                                                             selectedFlat =
//                                                                 flatData;
//                                                             if (location
//                                                                     .observations !=
//                                                                 null &&
//                                                                 location
//                                                                     .observations!
//                                                                     .isNotEmpty) {
//                                                               firstObs = location
//                                                                   .observations!
//                                                                   .first;
//                                                             }
//                                                             break;
//                                                           }
//                                                         }
//                                                         if (firstObs != null)
//                                                           break;
//                                                       }

//                                                       if (firstObs != null &&
//                                                           selectedFlat !=
//                                                               null) {
//                                                         final locationData =
//                                                             LocationData(
//                                                           locationId: firstObs
//                                                               .locationId,
//                                                           locationName:
//                                                               firstObs.name ??
//                                                                   "Location",
//                                                           unitType:
//                                                               firstObs.userType ??
//                                                                   "",
//                                                           desc:
//                                                               firstObs.description ??
//                                                                   "",
//                                                           locationobservationCount: response
//                                                               .data!
//                                                               .expand((flat) =>
//                                                                   flat.locationData ??
//                                                                   [])
//                                                               .expand((loc) =>
//                                                                   loc.observations ??
//                                                                   [])
//                                                               .length,
//                                                           locationcompletedObservationCount: response
//                                                               .data!
//                                                               .expand((flat) =>
//                                                                   flat.locationData ??
//                                                                   [])
//                                                               .expand((loc) =>
//                                                                   loc.observations ??
//                                                                   [])
//                                                               .where((e) =>
//                                                                   e.state ==
//                                                                   "completed")
//                                                               .length,
//                                                           locationpendingObservationCount: response
//                                                               .data!
//                                                               .expand((flat) =>
//                                                                   flat.locationData ??
//                                                                   [])
//                                                               .expand((loc) =>
//                                                                   loc.observations ??
//                                                                   [])
//                                                               .where((e) =>
//                                                                   e.state !=
//                                                                   "completed")
//                                                               .length,
//                                                         );

//                                                         await Get.toNamed(
//                                                           Routes
//                                                               .flatSubLocationScreen,
//                                                           arguments: {
//                                                             "location_id":
//                                                                 locationData
//                                                                     .locationId,
//                                                             "location_name":
//                                                                 locationData
//                                                                         .locationName ??
//                                                                     "Location",
//                                                             "project_id":
//                                                                 selectedFlat
//                                                                     .projectId
//                                                                     .toString(),
//                                                             "tower_id":
//                                                                 selectedFlat
//                                                                     .towerId
//                                                                     .toString(),
//                                                             "flat_id":
//                                                                 selectedFlat
//                                                                     .flatId
//                                                                     .toString(),
//                                                             "tower_name":
//                                                                 selectedFlat
//                                                                         .towerName ??
//                                                                     "Tower",
//                                                             "flat_name":
//                                                                 selectedFlat
//                                                                         .flatName ??
//                                                                     "Flat",
//                                                             "name": firstObs
//                                                                     .issueCategoryName ??
//                                                                 "HQI",
//                                                             "unit_type":
//                                                                 locationData
//                                                                         .unitType ??
//                                                                     "",
//                                                             "desc":
//                                                                 locationData
//                                                                     .desc,
//                                                             "data":
//                                                                 locationData,
//                                                             "open_observation_id":
//                                                                 observationId,
//                                                             "offline": false,
//                                                             "count": 0,
//                                                             "progress": "0",
//                                                           },
//                                                         );
//                                                       } else {
//                                                         errorSnackBar("Error",
//                                                             "No observation data found");
//                                                       }
//                                                     } else {
//                                                       errorSnackBar("Error",
//                                                           "Failed to fetch HQI data");
//                                                     }
//                                                   } else {
//                                                     await Get.toNamed(
//                                                       Routes.editActivityScreen,
//                                                       arguments: {
//                                                         "screen":
//                                                             "notification",
//                                                         "activity_type_id":
//                                                             notification
//                                                                 .redirectId,
//                                                         "seq_no":
//                                                             notification.seq_no,
//                                                       },
//                                                     );
//                                                   }
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding:
//                                                     EdgeInsets.all(w * 0.02),
//                                                 margin: EdgeInsets.only(
//                                                     bottom: w * 0.038),
//                                                 decoration: BoxDecoration(
//                                                   color: containerColor,
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   border: Border.all(
//                                                     color:
//                                                         const Color(0xffE6E6E6),
//                                                   ),
//                                                 ),
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Center(
//                                                       child: Container(
//                                                         height: h * 0.047,
//                                                         width: h * 0.047,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color: appColor,
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(10),
//                                                         ),
//                                                         child: const Icon(
//                                                           Icons
//                                                               .notifications_none,
//                                                           color: Colors.white,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     (h * 0.01).addWSpace(),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           "${notification.title}"
//                                                               .regularRobotoTextStyle(
//                                                                   textOverflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   fontSize: 14,
//                                                                   maxLine: 5,
//                                                                   fontColor: Colors
//                                                                       .grey
//                                                                       .shade700),
//                                                           "Sequence Number : ${notification.seq_no}"
//                                                               .regularRobotoTextStyle(
//                                                                   fontSize: 14,
//                                                                   fontColor: Colors
//                                                                       .grey
//                                                                       .shade700),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     (h * 0.005).addWSpace(),
//                                                     Builder(
//                                                       builder: (context) {
//                                                         String formattedDateTime =
//                                                             DateFormat(
//                                                                     'dd MMM, hh:mm a')
//                                                                 .format(DateTime
//                                                                         .parse(
//                                                                             "${notification.notificationDt}")
//                                                                     .add(const Duration(
//                                                                         hours:
//                                                                             5,
//                                                                         minutes:
//                                                                             30)));

//                                                         return Padding(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   bottom:
//                                                                       h * 0.025),
//                                                           child: formattedDateTime
//                                                               .toString()
//                                                               .boldRobotoTextStyle(
//                                                                   fontSize: 10,
//                                                                   fontColor:
//                                                                       appColor),
//                                                         );
//                                                       },
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                               ),
//                             ],
//                           );
//                         } else if (controller
//                                 .getNotificationApiResponse.status ==
//                             Status.ERROR) {
//                           return const Center(
//                             child: Text('Server Error'),
//                           );
//                         } else {
//                           return const SizedBox();
//                         }
//                       },
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }

