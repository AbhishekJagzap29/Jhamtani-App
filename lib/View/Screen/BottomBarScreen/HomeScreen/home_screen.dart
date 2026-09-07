import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/no_internet.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';
import '../../../Constant/shared_prefs.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController projectScreenController =
      Get.put(HomeScreenController());
  NetworkController networkController = Get.put(NetworkController());

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning, Team";
    } else if (hour < 17) {
      return "Good Afternoon, Team";
    } else if (hour < 21) {
      return "Good Evening, Team";
    } else {
      return "Good Night, Team";
    }
  }

  @override
  void initState() {
    getData();
    log('preferences.getString(SharedPreference.sessionId==========>>>>>${preferences.getString(SharedPreference.sessionId)}');
    super.initState();
  }

  getData() async {
    projectScreenController.changeSyncStatus();
    networkController.checkConnectivity().then((value) async {
      if (networkController.isResult == false) {
        await projectScreenController.getData();
        projectScreenController.fetchAndStoreIssueData();
        projectScreenController.fetchAndStoreImpactTypes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<NetworkController>(builder: (netController) {
      return GetBuilder<HomeScreenController>(
        builder: (controller) {
          return Stack(
            children: [
              Container(
                color: backGroundColor,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    backgroundColor: const Color(0xFF3498DB),
                    elevation: 0,
                    leading: const SizedBox(width: 48),
                
                    title: AppString.projects.boldRobotoTextStyle(
                        fontSize: 20, fontColor: Colors.white),
                    actions: [
                      Tooltip(
                        message: 'Offline',
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.showOfflineDataScreen);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Center(
                              child: Icon(
                                Icons.wifi_off_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: backGroundColor,
                  body: KeyboardVisibilityBuilder(
                    builder: (p0, isKeyboardVisible) {
                      return netController.isResult == true ||
                              controller.getAssignedProjectResponse.status ==
                                  Status.ERROR
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NoInternetWidget(
                                  h: h,
                                  w: w,
                                  onPressed: () {
                                    getData();
                                  },
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.showOfflineDataScreen);
                                    // Get.toNamed(Routes.saveActivityScreen);
                                  },
                                  color: appColor,
                                  minWidth: w * 0.65,
                                  height: h * 0.058,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: AppString.showSavedActivity
                                      .boldRobotoTextStyle(
                                          fontSize: 16,
                                          fontColor: backGroundColor),
                                ),
                                (h * 0.12).addHSpace()
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: h * 0.02),
  //                               Padding(
  //   padding: EdgeInsets.symmetric(horizontal: w * 0.06),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         getGreeting(),
  //         textAlign: TextAlign.left,
  //         style: const TextStyle(
  //           color: Color(0xFF3498DB),
  //           fontSize: 22,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       const Text(
  //         "Track quality. Build excellence.",
  //         textAlign: TextAlign.left,
  //         style: TextStyle(
  //           color: Colors.grey,
  //           fontSize: 14,
  //         ),
  //       ),
  //     ],
  //   ),
  // ),

  SizedBox(height: h * 0.02),

  /// Search Bar SECOND
  Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
    child: SearchAndFilterRow(
      onChanged: (p0) {
        projectScreenController.searchData();
      },
      controller: projectScreenController.searchController,
      hintText: AppString.searchProject,
    ),
  ),
                                SizedBox(height: h * 0.015),
                                Expanded(
                                  child: Builder(
                                    builder: (c) {
                                      if (controller.getAssignedProjectResponse
                                              .status ==
                                          Status.LOADING) {
                                        return showCircular();
                                      } else if (controller
                                                  .getAssignedProjectResponse
                                                  .status ==
                                              Status.COMPLETE ||
                                          controller
                                                  .networkController.isResult ==
                                              true) {
                                        if (controller.searchDataList.isEmpty) {
                                          return const Center(
                                            child: Text('No Projects'),
                                          );
                                        }
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.06),
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: MasonryGridView.count(
                                              crossAxisSpacing:
                                                  Responsive.isDesktop(context)
                                                      ? w * 0.03
                                                      : w * 0.05,
                                              mainAxisSpacing:
                                                  Responsive.isDesktop(context)
                                                      ? w * 0.03
                                                      : w * 0.05,
                                              crossAxisCount:
                                                  Responsive.isDesktop(context)
                                                      ? 3
                                                      : 2,
                                              padding: EdgeInsets.only(
                                                  top: h * 0.02),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: controller
                                                  .searchDataList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                double per = double.parse(
                                                    controller
                                                            .searchDataList[
                                                                index]
                                                            .progress ??
                                                        "0.00");
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
                                                    Get.toNamed(
                                                        Routes
                                                            .projectChecklistScreen,
                                                        arguments: {
                                                          "id": controller
                                                              .searchDataList[
                                                                  index]
                                                              .projectId
                                                              .toString(),
                                                          "name": controller
                                                              .searchDataList[
                                                                  index]
                                                              .name
                                                              .toString(),
                                                          "count": count,
                                                          "buId": controller
                                                              .searchDataList[
                                                                  index]
                                                              .buId
                                                        });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        w * 0.026),
                                                    decoration: BoxDecoration(
                                                      color: containerColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffE6E6E6),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                height: Responsive
                                                                        .isDesktop(
                                                                            context)
                                                                    ? h * 0.2
                                                                    : h * 0.12,
                                                                width: w * 0.35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child:
                                                                    networkImageShimmer(
                                                                  url: controller
                                                                      .searchDataList[
                                                                          index]
                                                                      .image
                                                                      .toString(),
                                                                  w: w * 0.35,
                                                                  h: h * 0.12,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(7),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        greenColor,
                                                                    radius: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: h *
                                                                      0.011),
                                                          child:
                                                              StepProgressIndicator(
                                                            totalSteps: 5,
                                                            roundedEdges:
                                                                const Radius
                                                                    .circular(
                                                                    10),
                                                            currentStep: count,
                                                            unselectedSize:
                                                                h * 0.007,
                                                            size: h * 0.007,
                                                            selectedColor:
                                                                greenColor,
                                                            unselectedColor:
                                                                lightGreyColor,
                                                          ),
                                                        ),
                                                        controller
                                                            .searchDataList[
                                                                index]
                                                            .name
                                                            .toString()
                                                            .boldRobotoTextStyle(
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: 14),
                                                        AppString.locationName
                                                            .regularRobotoTextStyle(
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: 13,
                                                                fontColor:
                                                                    greyTextColor)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: Text('Something went wrong'),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                isKeyboardVisible
                                    ? const SizedBox()
                                    : (h * 0.1).addHSpace(),
                              ],
                            );
                    },
                  ),
                ),
              ),
              controller.syncing
                  ? Container(
                      color: Colors.black26,
                      child: Center(child: showCircular()),
                    )
                  : const SizedBox(),
            ],
          );
        },
      );
    });
  }
}
































