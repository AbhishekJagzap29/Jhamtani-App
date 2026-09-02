import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_flat_list_hqi_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/pdf_view_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_flat_list_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_tower_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HQITowerDetailsScreen extends StatefulWidget {
  const HQITowerDetailsScreen({super.key});

  @override
  State<HQITowerDetailsScreen> createState() => _HQITowerDetailsScreenState();
}

class _HQITowerDetailsScreenState extends State<HQITowerDetailsScreen> {
  HQITowerController hqitowerController = Get.put(HQITowerController());
  DownloadPdfController downloadPdfController = Get.put(DownloadPdfController());
  final HQIFlatListController hqiFlatListController = Get.put(HQIFlatListController());

  String? towerId;
  String? projectId;
  String? towerName;

  HQITower? selectedTower;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    towerId = args['towerId']?.toString();
    projectId = args['projectId']?.toString();
    towerName = args['towerName']?.toString();

    if (towerId != null && projectId != null) {
      hqitowerController.getHQIFlatListController(
        towerId: towerId!,
        projectId: projectId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        floatingActionButton: const CommonBackToHomeButton(),
        backgroundColor: backGroundColor,
        appBar: AppBarWidget(
          backGroundColor: const Color(0xFF3498DB),
          title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
        ),
        body: SafeArea(
          child: GetBuilder<HQITowerController>(
            builder: (controller) {
              if (controller.getFlatApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.getFlatApiResponse.status == Status.COMPLETE) {
                // final selectedTower = controller.towerres?.data?.firstWhere(
                //   (tower) => tower.id?.toString() == towerId,
                //   orElse: () => HQITower(name: 'Unknown'),
                // );
                final selectedTower = controller.towerres?.data?.towerData?.firstWhere(
                  (tower) => tower.id?.toString() == towerId,
                  orElse: () => HQITower(name: 'Unknown'),
                );

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (h * 0.03).addHSpace(),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.045),
                          decoration: BoxDecoration(
                            color: containerColor,
                            border: Border.all(color: const Color(0xffE6E6E6)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: w * 0.55,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (towerName ?? 'Tower').boldRobotoTextStyle(fontSize: 22),
                                          SizedBox(
                                            width: w * 0.42,
                                            child: AppString.projectAddress.regularBarlowTextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    CircularStepProgressIndicator(
                                      totalSteps: 10,
                                      stepSize: 10,
                                      currentStep: (controller.hqiFlatListRes?.data
                                                  ?.firstWhere(
                                                    (flat) => flat.id?.toString() == towerId,
                                                    orElse: () => HQIFlatData(flatHQIProgressPercentage: 0),
                                                  )
                                                  .flatHQIProgressPercentage ??
                                              0)
                                          .toInt(),

                                      // currentStep: controller.flatFloorRes?.towerData?.progress?.toInt() ?? 0,
                                      padding: 0.05,
                                      height: Responsive.isDesktop(context) ? h * 0.13 : h * 0.1,
                                      width: Responsive.isDesktop(context) ? h * 0.13 : h * 0.1,
                                      selectedColor: greenColor,
                                      unselectedColor: const Color(0xffBCCCBF),
                                      child: Center(
                                        child: "${(controller.hqiFlatListRes?.data?.firstWhere(
                                                  (flat) => flat.id?.toString() == towerId,
                                                  orElse: () => HQIFlatData(flatHQIProgressPercentage: 0),
                                                ).flatHQIProgressPercentage ?? 0).toInt()}%"
                                            .boldRobotoTextStyle(fontSize: 18),

                                        // "${controller.flatFloorRes?.towerData?.progress?.toInt()}%".boldRobotoTextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                // Divider(color: const Color(0xffE6E6E6), thickness: 2, height: h * 0.02),
                                // Row(
                                //   children: [
                                //     'Total Points                    : '.boldRobotoTextStyle(fontSize: 12),
                                //     ((controller.select == 0 ? (controller.flatFloorRes?.towerData?.flatTotalCount ?? 0) : 0))
                                //         .toString()
                                //         .regularRobotoTextStyle(fontSize: 10),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     'Maker Submitted         : '.boldRobotoTextStyle(fontSize: 12),
                                //     ((controller.select == 0 ? (controller.flatFloorRes?.towerData?.flatMakerCount ?? 0) : 0))
                                //         .toString()
                                //         .regularRobotoTextStyle(fontSize: 10),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     'Checker Submitted     : '.boldRobotoTextStyle(fontSize: 12),
                                //     ((controller.select == 0 ? (controller.flatFloorRes?.towerData?.flatCheckerCount ?? 0) : 0))
                                //         .toString()
                                //         .regularRobotoTextStyle(fontSize: 10),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     'Approver Submitted   : '.boldRobotoTextStyle(fontSize: 12),
                                //     ((controller.select == 0 ? (controller.flatFloorRes?.towerData?.flatApproverCount ?? 0) : 0))
                                //         .toString()
                                //         .regularRobotoTextStyle(fontSize: 10),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Responsive.isDesktop(context) ? h * 0.028 : h * 0.014),
                          child: SearchAndFilterRow(
                            onChanged: (p0) {
                              controller.searchData();
                            },
                            controller: controller.searchController,
                            hintText: "Search Flats",
                          ),
                        ),

                        // Flat Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.searchController.clear();
                                controller.selectFlatFloor(0);
                              },
                              child: Container(
                                height: Responsive.isDesktop(context) ? h * 0.068 : h * 0.048,
                                width: w * 0.20,
                                decoration: BoxDecoration(
                                  color: controller.select == 0 ? appColor : containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: AppString.flats.boldRobotoTextStyle(
                                    fontSize: 13,
                                    fontColor: controller.select == 0 ? backGroundColor : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: Responsive.isTablet(context) ? w * 0.00322 : w * 0.00512,
                            crossAxisSpacing: w * 0.045,
                            mainAxisSpacing: h * 0.02,
                          ),
                          shrinkWrap: true,
                          itemCount: controller.searchHQIFlatList.length,
                          itemBuilder: (context, index) {
                            var responseData = controller.searchHQIFlatList[index];

                            double per = double.tryParse(responseData.progress ?? "0.0") ?? 0.0;

                            final count = per < 20
                                ? 0
                                : per < 40
                                    ? 1
                                    : per < 60
                                        ? 2
                                        : per < 80
                                            ? 3
                                            : per == 100
                                                ? 5
                                                : 4;

                            return GestureDetector(
                              onTap: () {
                                final flatData = controller.searchHQIFlatList[index];

                                Get.toNamed(
                                  Routes.siteVisitListViewScreen,
                                  arguments: {
                                    'flat_name': flatData.name,
                                    'tower_name': towerName ?? "",
                                    'progress': flatData.flatHQIProgressPercentage?.toString() ?? "0",
                                    'count': count,
                                    'project_id': projectId,
                                    'tower_id': towerId,
                                    'flat_id': flatData.id.toString(),
                                    'data': flatData,
                                    'searchHQIFlatList': controller.searchHQIFlatList,
                                    "offline": false,
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffE6E6E6)),
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          (h * 0.015).addHSpace(),
                                          const Spacer(),
                                          '${responseData.name}'.boldRobotoTextStyle(fontSize: 14),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: h * 0.012).copyWith(bottom: h * 0.015),
                                            child: StepProgressIndicator(
                                              totalSteps: 3,
                                              roundedEdges: const Radius.circular(10),
                                              currentStep: count,
                                              unselectedSize: h * 0.007,
                                              size: h * 0.007,
                                              selectedColor: responseData.isHQICompleted ? greenColor : appColor,
                                              unselectedColor: responseData.isHQICompleted ? greenColor : lightGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 3-dot menu

                                    // Positioned(
                                    //   right: h * 0.01,
                                    //   child: PopupMenuButton<int>(
                                    //     icon: const Icon(Icons.more_vert,
                                    //         size: 20),
                                    //     onSelected: (value) {
                                    //       if (value == 0) {
                                    //       } else if (value == 1) {
                                    //         downloadPdfController
                                    //             .downloadAndOpenPdf(visitId: 0
                                    //                 );
                                    //       } else if (value == 2) {}
                                    //     },
                                    //     itemBuilder: (context) => [
                                    //       if (preferences.getString(
                                    //               SharedPreference.userType) ==
                                    //           "checker")
                                    //         const PopupMenuItem(
                                    //           value: 0,
                                    //           child: Row(
                                    //             children: [
                                    //               Icon(Icons.check_circle,
                                    //                   color: Colors.blue,
                                    //                   size: 20),
                                    //               SizedBox(width: 8),
                                    //               Text("Complete For HQI"),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       const PopupMenuItem(
                                    //         value: 1,
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(Icons.download,
                                    //                 color: Colors.blue,
                                    //                 size: 20),
                                    //             SizedBox(width: 8),
                                    //             Text("Download PDF"),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       const PopupMenuItem(
                                    //         value: 2,
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(Icons.cancel_outlined,
                                    //                 color: Colors.red,
                                    //                 size: 20),
                                    //             SizedBox(width: 8),
                                    //             Text("Close"),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    Positioned(
                                      right: h * 0.01,
                                      child: PopupMenuButton<int>(
                                        icon: const Icon(Icons.more_vert, size: 20),
                                        onSelected: (value) async {
                                          if (value == 0) {
                                            final flatData = controller.searchHQIFlatList[index];
                                            final flatId = flatData.id;

                                            if (flatId != null) {
                                              if (flatData.isHQICompleted) {
                                                errorSnackBar("Info", "Flat is already marked as HQI completed");
                                                return;
                                              }

                                              await hqitowerController.completeHQIFlat(flatId: flatId);
                                            } else {
                                              Get.snackbar("Error", "Flat ID is missing.", snackPosition: SnackPosition.BOTTOM);
                                            }
                                          } else if (value == 1) {
                                            // Download PDF
                                            final flatData = controller.searchHQIFlatList[index];
                                            final flatId = flatData.id?.toString();
                                            if (flatId != null && flatId.isNotEmpty) {
                                              await downloadPdfController.downloadAndOpenPdfForFlat(flatId: flatId);
                                            }
                                          } else if (value == 2) {
                                            print('ON_TAP::::::::::::::::::::::::OFFLINE::::::::::::::::}');
                                            Future.delayed(const Duration(milliseconds: 200)).then(
                                              (value) async {
                                                await controller.storeForOfflineUse(
                                                    w: w, context: context, h: h, flatId: '${responseData.id}');
                                              },
                                            );

                                            ///
                                            /*  Future.delayed(const Duration(milliseconds: 200)).then(
                                                    (value) async {
                                                  final flatData = controller.locationdata[index];
                                                  final locationId = flatData.locationId ?? 0;

                                                  if (locationId == 0) {
                                                    errorSnackBar(
                                                        "Error", "Location ID is missing for this flat");
                                                    return;
                                                  }
                                                  controller.getFlatLocationObservationOffline(
                                                    locationId: locationId,
                                                    w: w,
                                                    context: context,
                                                    h: h,
                                                  );
                                                },
                                              );*/
                                          } else if (value == 3) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          if (preferences.getString(SharedPreference.userType) == "hqi_approver")
                                            const PopupMenuItem(
                                              value: 0,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                                                  SizedBox(width: 8),
                                                  Text("Complete For HQI"),
                                                ],
                                              ),
                                            ),
                                          const PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(Icons.download, color: Colors.blue, size: 20),
                                                SizedBox(width: 8),
                                                Text("Download PDF"),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 2,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.save, color: appColor),
                                                (w * 0.02).addWSpace(),
                                                AppString.saveAsOffline.regularRobotoTextStyle(fontSize: 16),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 3,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                                                (w * 0.02).addWSpace(),
                                                const Text("Close"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        (controller.flatLength == controller.searchHQIFlatList.length && controller.select == 0)
                            ? const SizedBox()
                            : Center(
                                child: controller.load
                                    ? showCircular()
                                    : TextButton(
                                        onPressed: () {
                                          if (controller.select == 0) {
                                            controller.setFlatLength(false);
                                          }
                                        },
                                        child: "Load more".semiBoldBarlowTextStyle(fontColor: appColor),
                                      ),
                              ),
                      ],
                    ),
                  ),
                );
              } else if (controller.getFlatApiResponse.status == Status.ERROR) {
                return const Center(child: Text('Server Error'));
              } else {
                return const Center(child: Text('Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}
