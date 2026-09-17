import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_flat_list_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
class HQLFlatScreen extends StatefulWidget {
  const HQLFlatScreen({super.key});

  @override
  State<HQLFlatScreen> createState() => _HQLFlatScreenState();
}

class _HQLFlatScreenState extends State<HQLFlatScreen> {
  final HQIFlatListController hqiFlatListController = Get.put(HQIFlatListController());

  int count = Get.arguments['count'] ?? 0;
  String progress = Get.arguments['progress']?.toString() ?? "0";
  String projectId = Get.arguments['project_id']?.toString() ?? "";
  String towerId = Get.arguments['tower_id']?.toString() ?? "";
  String flatId = Get.arguments['flat_id']?.toString() ?? "";
  String flatName = Get.arguments['flat_name']?.toString() ?? "Flat";
  String towerName = Get.arguments['tower_name']?.toString() ?? "Tower";
  int visitId = Get.arguments['visit_id'] ?? 0;
  String visitName = Get.arguments['visit_name']?.toString() ?? "Site Visit";
  int locationId = Get.arguments['location_id'] ?? 0;
  bool isOffline = Get.arguments['offline'] ?? false;

  // FlatVisitData flatVisitlist = Get.arguments['data'];
  // List<OfflineHQIData> flatVisitlist = Get.arguments['offline_data'] ?? [];

  @override
  void initState() {
    super.initState();
    visitId = Get.arguments['visit_id'] ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFlatData();
    });
  }

  void getFlatData() {
    hqiFlatListController.getAndStoreData(
      projectId: projectId,
      towerId: towerId,
      flatId: flatId,
      visitId: visitId,

      // flatVisitData: [flatVisitlist],
    );
    // hqiFlatListController.getFlatVisitsController(
    //   projectId: projectId,
    //   towerId: towerId,
    //   flatId: flatId,
    //   visitId: visitId,
    // );
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
          title: visitName.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
        ),
        floatingActionButton: const CommonBackToHomeButton(),
        body: SafeArea(
          child: GetBuilder<HQIFlatListController>(
            builder: (controller) {
              if (controller.flatVisitsApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.flatVisitsApiResponse.status == Status.COMPLETE) {
                return Stack(
                  children: [
                    SingleChildScrollView(
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
                                      top: isOffline ? h * 0.02 : h * 0.03,
                                      bottom: isOffline ? h * 0.015 : h * 0.025),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    border: Border.all(
                                      color: const Color(0xffE6E6E6),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              flatName.boldRobotoTextStyle(fontSize: 22),
                                              Text(towerName, style: const TextStyle(fontSize: 12)),
                                              if (isOffline) ...[
                                                SizedBox(height: h * 0.01),
                                                const Text("Offline", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                              ]
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              '$progress%'.boldRobotoTextStyle(fontSize: 30),
                                              5.0.addHSpace(),
                                              StepProgressIndicator(
                                                totalSteps: 5,
                                                roundedEdges: const Radius.circular(10),
                                                currentStep: count,
                                                unselectedSize: h * 0.007,
                                                size: h * 0.007,
                                                selectedColor: greenColor,
                                                unselectedColor: lightGreyColor,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      (h * 0.01).addHSpace(),
                                      Column(
                                        children: [
                                          Divider(
                                            color: const Color(0xffE6E6E6),
                                            thickness: 2,
                                            height: h * 0.02,
                                          ),
                                          Row(
                                            children: [
                                              'Total Observations              :  '.boldRobotoTextStyle(fontSize: 12),
                                              (controller.flatVisitList.isNotEmpty
                                                      ? controller.flatVisitList.first.totalObservationCount ?? 0
                                                      : 0)
                                                  .toString()
                                                  .regularRobotoTextStyle(fontSize: 10),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     'Pending Count        :  '
                                          //         .boldRobotoTextStyle(
                                          //             fontSize: 12),
                                          //     (flatVisitlist
                                          //                 ?.pendingObservationCount ??
                                          //             0)
                                          //         .toString()
                                          //         .regularRobotoTextStyle(
                                          //             fontSize: 10),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     'Completed Count  :  '
                                          //         .boldRobotoTextStyle(
                                          //             fontSize: 12),
                                          //     (flatVisitlist
                                          //                 ?.completedObservationCount ??
                                          //             0)
                                          //         .toString()
                                          //         .regularRobotoTextStyle(
                                          //             fontSize: 10),
                                          //   ],
                                          // ),
                                          Row(
                                            children: [
                                              'Pending Observations        :  '.boldRobotoTextStyle(fontSize: 12),
                                              // (preferences.getString(SharedPreference.userType) == "hqi_maker"
                                                  ((preferences.getString(SharedPreference.userType)?.contains("hqi_maker") ?? false)

                                                      ? (controller.flatVisitList.isNotEmpty
                                                          ? controller.flatVisitList.first.makerPendingCount ?? 0
                                                          : 0)
                                                      : (controller.flatVisitList.isNotEmpty
                                                          ? controller.flatVisitList.first.checkerPendingCount ?? 0
                                                          : 0))
                                                  .toString()
                                                  .regularRobotoTextStyle(fontSize: 10),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              'Completed Observations  :  '.boldRobotoTextStyle(fontSize: 12),
                                              // (preferences.getString(SharedPreference.userType) == "hqi_maker"
                                                  ((preferences.getString(SharedPreference.userType)?.contains("hqi_maker") ?? false)

                                                      ? (controller.flatVisitList.isNotEmpty
                                                          ? controller.flatVisitList.first.makerCompletedCount ?? 0
                                                          : 0)
                                                      : (controller.flatVisitList.isNotEmpty
                                                          ? controller.flatVisitList.first.checkerCompletedCount ?? 0
                                                          : 0))
                                                  .toString()
                                                  .regularRobotoTextStyle(fontSize: 10),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Responsive.isDesktop(context) ? h * 0.028 : h * 0.016),
                                  child: SearchAndFilterRow(
                                    onChanged: (p0) {
                                      controller.searchActivity();
                                    },
                                    controller: controller.searchController,
                                    hintText: AppString.searchLocation,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: 1.0.appDivider(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: AppString.locations.boldRobotoTextStyle(fontSize: 16),
                                    ),
                                    Expanded(child: 1.0.appDivider(color: Colors.black)),
                                  ],
                                ),
                                controller.locationdata.isEmpty
                                    ? SizedBox(
                                        height: h * 0.45,
                                        child: const Center(
                                          child: Text('No activity data available!'),
                                        ),
                                      )
                                    // : ListView.builder(
                                    //     padding: EdgeInsets.only(top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017),
                                    //     physics: const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemCount: controller.locationdata.length,
                                    //     itemBuilder: (context, index) {
                                    //       var activityData = controller.locationdata[index];
                                    //       var visitId = controller.flatVisitList;
                                    //       return GestureDetector(
                                    //         onTap: () {
                                    //           log('Tapped on ${activityData.locationName}');
                                    //           Get.toNamed(
                                    //             Routes.flatSubLocationScreen,
                                    //             arguments: {
                                    //               'location_id': activityData.locationId,
                                    //               'location_name': activityData.locationName,
                                    //               'unit_type': activityData.unitType,
                                    //               'tower_name': towerName,
                                    //               // 'desc': activityData.desc,
                                    //               'data': activityData,
                                    //               'offline': isOffline,

                                    //               "project_id": projectId,
                                    //               "tower_id": towerId,
                                    //               "flat_id": flatId,
                                                  
                                    //             },
                                    //           );
                                    //         },



                                   :ListView.builder(
  padding: EdgeInsets.only(
    top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017,
  ),
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount: controller.locationdata.length,
  itemBuilder: (context, index) {
    final activityData = controller.locationdata[index];

    // Find which Site Visit contains this location.
    dynamic currentVisit;

    for (final visit in controller.flatVisitList) {
      final locations = visit.locationData ?? [];

      final locationExists = locations.any(
        (location) =>
            location.locationId == activityData.locationId,
      );

      if (locationExists) {
        currentVisit = visit;
        break;
      }
    }

    final int visitId = currentVisit?.visitId ?? 0;
    final String visitName = currentVisit?.visitName ?? "";
    final int visitSequence = currentVisit?.sequence ?? 0;

    log('----------------------------------------');
    log('Tapped Location: ${activityData.locationName}');
    log('Location ID: ${activityData.locationId}');
    log('Visit ID: $visitId');
    log('Visit Name: $visitName');
    log('Visit Sequence: $visitSequence');
    log('----------------------------------------');

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.flatSubLocationScreen,
          arguments: {
            'location_id': activityData.locationId,
            'location_name': activityData.locationName,
            'unit_type': activityData.unitType,
            'tower_name': towerName,
            'data': activityData,
            'offline': isOffline,
            'project_id': projectId,
            'tower_id': towerId,
            'flat_id': flatId,

            // Correct visit information
            'visit_id': visitId,
            'visit_name': visitName,
            'sequence': visitSequence,
          },
        );
      },
   
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.035),
                                                  decoration: BoxDecoration(
                                                    color: containerColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: CircleAvatar(
                                                            radius: 8,
                                                            backgroundColor: controller.locationdata[index].color == 'green'
                                                                ? greenColor
                                                                : controller.locationdata[index].color == 'orange'
                                                                    ? orangeColor
                                                                    : controller.locationdata[index].color == 'yellow'
                                                                        ? yellowColor
                                                                        : redColor,
                                                          ),
                                                        ),
                                                        (w * 0.03).addWSpace(),
                                                        Expanded(
                                                          flex: 20,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                width: w * 0.62,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Flexible(
                                                                          child: "${controller.locationdata[index].locationName}"
                                                                              .toString()
                                                                              .boldRobotoTextStyle(
                                                                                  maxLine: 2,
                                                                                  textOverflow: TextOverflow.ellipsis,
                                                                                  fontSize: 15),
                                                                        ),
                                                                        controller.locationdata[index].activity_type_status == true
                                                                            ? Row(
                                                                                children: [
                                                                                  const SizedBox(width: 5),
                                                                                  Icon(Icons.done_all, color: greenColor)
                                                                                ],
                                                                              )
                                                                            : const SizedBox()
                                                                      ],
                                                                    ),
                                                                    (h * 0.005).addHSpace(),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              SizedBox(
                                                                width: w * 0.075,
                                                                child: PopupMenuButton(
                                                                  icon: const Icon(Icons.more_vert_rounded),
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem(
                                                                        onTap: () {
                                                                          if (NetworkController().isResult == false) {
                                                                            errorSnackBar("Error!", "no internet connection");
                                                                          } else {
                                                                            Get.toNamed(Routes.viewPdf, arguments: {
                                                                              "title": "${controller.locationdata[index].locationName}"
                                                                                  .toString(),
                                                                              // "visitId": "".toString(),
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(Icons.download, color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.downloadPdf.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        onTap: () async {
                                                                          if (NetworkController().isResult == false) {
                                                                            errorSnackBar("Error!", "no internet connection");
                                                                          } else {
                                                                            await Future.delayed(const Duration(milliseconds: 300));
                                                                            await controller.replicatelocationforhqi(body: {
                                                                              "location_id": controller.locationdata[index].locationId,
                                                                              "user_id": int.parse(
                                                                                  preferences.getString(SharedPreference.userId) ?? "0"),
                                                                            });
                                                                            getFlatData();
                                                                          }
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(Icons.copy, color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.replicateAct.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      if (preferences.getBool(SharedPreference.del_activity_users) == true)

                                                                        /// delete
                                                                        PopupMenuItem(
                                                                          onTap: () async {
                                                                            if (NetworkController().isResult == false) {
                                                                              errorSnackBar("Error!", "no internet connection");
                                                                            } else {
                                                                              await Future.delayed(const Duration(milliseconds: 300));
                                                                              await controller.deleteActivityController(body: {
                                                                                "activity_id":
                                                                                    "${controller.locationdata[index].locationId}"
                                                                                        .toString()
                                                                              });

                                                                              getFlatData();
                                                                            }
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              const Icon(Icons.delete, color: appColor),
                                                                              (w * 0.02).addWSpace(),
                                                                              AppString.deleteActivity.regularRobotoTextStyle(fontSize: 16),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      // PopupMenuItem(
                                                                      //   onTap: () {
                                                                      //     print('ON_TAP::::::::::::::::::::::::::::::::::::::::}');
                                                                      //     Future.delayed(const Duration(milliseconds: 200)).then(
                                                                      //       (value) async {
                                                                      //         final flatData = controller.locationdata[index];
                                                                      //         final locationId = flatData.locationId ?? 0;
                                                                      //
                                                                      //         if (locationId == 0) {
                                                                      //           errorSnackBar(
                                                                      //               "Error", "Location ID is missing for this flat");
                                                                      //           return;
                                                                      //         }
                                                                      //         // controller.getFlatLocationObservationOffline(
                                                                      //         //   locationId: locationId,
                                                                      //         //   w: w,
                                                                      //         //   context: context,
                                                                      //         //   h: h,
                                                                      //         // );
                                                                      //       },
                                                                      //     );
                                                                      //   },
                                                                      //   child: Row(
                                                                      //     children: [
                                                                      //       const Icon(Icons.save, color: appColor),
                                                                      //       (w * 0.02).addWSpace(),
                                                                      //       AppString.saveAsOffline.regularRobotoTextStyle(fontSize: 16),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      PopupMenuItem(
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.cancel_outlined, color: redColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.close.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: h * 0.008, bottom: h * 0.017),
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      // children: [
                                                      //   AppString.lastUpdateTime
                                                      //       .semiBoldBarlowTextStyle(
                                                      //           fontSize: 11),
                                                      //    DateFormat(
                                                      //          'dd/MM/yyyy hh:mm')
                                                      //   .format(controller
                                                      //       .locationdata![index]
                                                      //       .writeDate!)
                                                      //   .regularRobotoTextStyle(
                                                      //       fontSize: 11),
                                                      // ],

                                                      children: [
                                                        AppString.lastUpdateTime.semiBoldBarlowTextStyle(fontSize: 11),
                                                        DateFormat('dd/MM/yyyy hh:mm')
                                                            .format(DateTime.now())
                                                            .regularRobotoTextStyle(fontSize: 11),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                (h * 0.1).addHSpace()
                                //   );
                                // }
                                //  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    controller.flatVisitsApiResponse.status == Status.LOADING
                        ? Container(
                            color: Colors.black12,
                            child: Center(
                              child: showCircular(),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              } else if (controller.flatVisitsApiResponse.status == Status.ERROR) {
                return const Center(child: Text('Server Error'));
              } else {
                getFlatData();
                return const Center(child: Text('Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> saveForOfflineUse(BuildContext context, double h, double w) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: "Saved Activity".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This activity data saved successfully for the offline use. You can store maximum 5 activity data for offline use"
                    .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
              ),
            )
          ],
        );
      },
    );
  }
}
