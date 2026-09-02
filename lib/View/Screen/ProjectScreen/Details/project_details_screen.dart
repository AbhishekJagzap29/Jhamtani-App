// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:jhamtani_app/Api/Apis/api_response.dart';
// import 'package:jhamtani_app/View/Constant/app_assets.dart';
// import 'package:jhamtani_app/View/Constant/app_color.dart';
// import 'package:jhamtani_app/View/Constant/app_string.dart';
// import 'package:jhamtani_app/View/Constant/responsive.dart';
// import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_tower_screen.dart';
// import 'package:jhamtani_app/View/Screen/ProjectScreen/Details/project_details_controller.dart';
// import 'package:jhamtani_app/View/Screen/TowerScreen/tower_controller.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';
// import 'package:jhamtani_app/View/Utils/app_routes.dart';
// import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
// import 'package:jhamtani_app/View/utils/extension.dart';

// class ProjectDetailsScreen extends StatefulWidget {
// const ProjectDetailsScreen({super.key});
//   @override
//   State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
// }

// class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
//   ProjectDetailsController projectDetailsController =
//       Get.put(ProjectDetailsController());
//   var cName = Get.arguments['cName'];
//   var name = Get.arguments['name'];

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         backgroundColor: backGroundColor,
//         floatingActionButton: cName == "Material Inspection"
//             ? const SizedBox()
//             : const CommonBackToHomeButton(),
//         body: SafeArea(
//           child: GetBuilder<ProjectDetailsController>(
//             builder: (controller) {
//               if (controller.getTowerChecklistResponse.status ==
//                   Status.LOADING) {
//                 return showCircular();
//               } else if (controller.getTowerChecklistResponse.status ==
//                       Status.COMPLETE ||
//                   controller.networkController.isResult == true) {
//                 return SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Container(
//                             width: w * 1,
//                             height: Responsive.isDesktop(context)
//                                 ? h * 0.55
//                                 : h * 0.33,
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(25),
//                                 bottomRight: Radius.circular(25),
//                               ),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: const BorderRadius.only(
//                                 bottomLeft: Radius.circular(25),
//                                 bottomRight: Radius.circular(25),
//                               ),
//                               child: networkImageShimmer(
//                                   h: h * 0.33,
//                                   radius: 0,
//                                   w: w,
//                                   url: controller.towerDataRes?.projectData
//                                           ?.imageUrl ??
//                                       ""),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: -h * 0.07,
//                             left: w * 0.06,
//                             right: w * 0.06,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: Responsive.isDesktop(context)
//                                       ? h * 0.016
//                                       : h * 0.013,
//                                   horizontal: w * 0.06),
//                               decoration: BoxDecoration(
//                                 color: containerColor,
//                                 border: Border.all(
//                                   color: const Color(0xffE6E6E6),
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         "${controller.towerDataRes?.projectData!.checklistName}"
//                                             .toString()
//                                             .boldRobotoTextStyle(fontSize: 16),
//                                         (h * 0.005).addHSpace(),
//                                         SizedBox(
//                                           width: w * 0.42,
//                                           child: AppString.projectAddress
//                                               .regularBarlowTextStyle(
//                                                   fontSize: 12),
//                                         )
//                                       ],
//                                     ),
//                                     CircularStepProgressIndicator(
//                                       totalSteps: 10,
//                                       stepSize: 10,
//                                       currentStep: controller.towerDataRes
//                                               ?.projectData?.progress
//                                               ?.toInt() ??
//                                           0,
//                                       padding: 0.05,
//                                       height: Responsive.isDesktop(context)
//                                           ? h * 0.15
//                                           : h * 0.095,
//                                       width: Responsive.isDesktop(context)
//                                           ? h * 0.15
//                                           : h * 0.095,
//                                       selectedColor: greenColor,
//                                       unselectedColor: const Color(0xffBCCCBF),
//                                       child: Center(
//                                         child:
//                                             "${controller.towerDataRes?.projectData?.progress?.toInt()}%"
//                                                 .boldRobotoTextStyle(
//                                                     fontSize: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: w * 0.062)
//                                 .copyWith(top: h * 0.013),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Get.back();
//                                   },
//                                   child: const Icon(Icons.arrow_back_ios,
//                                       size: 22, color: Colors.black),
//                                 ),
//                                 const Spacer(),
//                                 Container(
//                                   alignment: Alignment.centerRight,
//                                   height: Responsive.isDesktop(context)
//                                       ? h * 0.07
//                                       : h * 0.04,
//                                   width: Responsive.isDesktop(context)
//                                       ? h * 0.07
//                                       : h * 0.04,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.white,
//                                   ),
//                                   child: Center(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         controller.favourite();
//                                       },
//                                       child: Icon(
//                                         controller.isFavorite
//                                             ? Icons.favorite_border
//                                             : Icons.favorite,
//                                         size: Responsive.isDesktop(context)
//                                             ? h * 0.038
//                                             : 22,
//                                         color: controller.isFavorite
//                                             ? Colors.black
//                                             : redColor,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                         child: Column(
//                           children: [
//                             (h * 0.09).addHSpace(),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: 1.0.appDivider(color: Colors.black)),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                   child: AppString.selectTower
//                                       .boldRobotoTextStyle(fontSize: 16),
//                                 ),
//                                 Expanded(
//                                     child: 1.0.appDivider(color: Colors.black)),
//                               ],
//                             ),
//                             (controller.towerDataRes?.projectData?.towerData
//                                         ?.isEmpty ??
//                                     false)
//                                 ? SizedBox(
//                                     height: h * 0.3,
//                                     child: const Center(
//                                       child: Text('No tower data available!'),
//                                     ),
//                                   )
//                                 : GridView.builder(
//                                     padding: EdgeInsets.only(top: h * 0.017),
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 2,
//                                       childAspectRatio:
//                                           Responsive.isTablet(context)
//                                               ? w * 0.00322
//                                               : w * 0.00512,
//                                       crossAxisSpacing: w * 0.045,
//                                       mainAxisSpacing: h * 0.02,
//                                     ),
//                                     shrinkWrap: true,
//                                     itemCount: controller.towerDataRes
//                                         ?.projectData?.towerData?.length,
//                                     itemBuilder: (context, index) {
//                                       return GestureDetector(
// onTap: () {
//   log('controller.towerDataRes?.projectData?.towerData?[index].towerId.toString()==========>>>>>> ${controller.towerDataRes?.projectData?.towerData?[index].towerId.toString()}');

//   String towerId = controller.towerDataRes?.projectData?.towerData?[index].towerId?.toString() ?? '';

//   if (cName == "Material Inspection") {
//     Get.toNamed(
//       Routes.materialInspectionScreen,
//       arguments: {
//         'towerId': towerId,
//         'projectId': "${controller.projectId}",
//         "projectName": "${controller.projectName}",
//         "buId": "${controller.buId}",
//         'name': controller.towerDataRes?.projectData?.towerData?[index].name ?? '',
//       },
//     );
//   }
// else if (cName == "Home Inspection") {
//  Get.toNamed(Routes.hqiTowerDetailsScreen,
//   arguments: {
//   'towerId': towerId,
//   'projectId': "${controller.projectId}",
// });
//   } else {
//     Get.toNamed(
//       Routes.towerDetailsScreen,
//       arguments: {
//         'towerId': towerId,
//         'projectId': "${controller.projectId}",
//       },
//     );
//   }
// },

//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: const Color(0xffE6E6E6),
//                                             ),
//                                             color: containerColor,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Center(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10,
//                                                       vertical: 5),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   const Spacer(),
//                                                   "${controller.towerDataRes?.projectData!.towerData![index].name}"
//                                                       .toString()
//                                                       .boldRobotoTextStyle(
//                                                           fontSize: 14),
//                                                   const Spacer(),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                                 horizontal:
//                                                                     h * 0.012)
//                                                             .copyWith(
//                                                                 bottom:
//                                                                     h * 0.015),
//                                                     child:
//                                                         StepProgressIndicator(
//                                                       totalSteps: 5,
//                                                       roundedEdges:
//                                                           const Radius.circular(
//                                                               10),
//                                                       currentStep: controller
//                                                               .towerDataRes
//                                                               ?.projectData!
//                                                               .towerData![index]
//                                                               .progress
//                                                               ?.toInt() ??
//                                                           0,
//                                                       unselectedSize: h * 0.007,
//                                                       size: h * 0.007,
//                                                       selectedColor: greenColor,
//                                                       unselectedColor:
//                                                           lightGreyColor,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               } else if (controller.getTowerChecklistResponse.status ==
//                   Status.ERROR) {
//                 return const Center(child: Text('Server Error'));
//               } else {
//                 return const Center(child: Text('Something went wrong'));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Screen/ProjectScreen/Details/project_details_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final ProjectDetailsController projectDetailsController =
      Get.put(ProjectDetailsController());

  var cName = Get.arguments['cName'];
  var name = Get.arguments['name'];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        backgroundColor: backGroundColor,
        floatingActionButton: cName == "Material Inspection"
            ? const SizedBox()
            : const CommonBackToHomeButton(),
        body: SafeArea(
          child: GetBuilder<ProjectDetailsController>(
            builder: (controller) {
              /// Handle LOADING state
              if ((cName == "Home Inspection" &&
                      controller.getHQITowersResponse.status ==
                          Status.LOADING) ||
                  (cName != "Home Inspection" &&
                      controller.getTowerChecklistResponse.status ==
                          Status.LOADING)) {
                return showCircular();
              }

              /// Handle COMPLETE state
              else if ((cName == "Home Inspection" &&
                      controller.getHQITowersResponse.status ==
                          Status.COMPLETE) ||
                  (cName != "Home Inspection" &&
                      controller.getTowerChecklistResponse.status ==
                          Status.COMPLETE) ||
                  controller.networkController.isResult == true) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: w * 1,
                            height: Responsive.isDesktop(context)
                                ? h * 0.55
                                : h * 0.33,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              child: networkImageShimmer(
                                  h: h * 0.33,
                                  radius: 0,
                                  w: w,
                                  // url: controller.towerDataRes?.projectData
                                  //         ?.imageUrl ??


url: cName == "Home Inspection"
    ? controller.hqiImageUrl
    : controller.towerDataRes?.projectData?.imageUrl ?? "",



                                      ),
                            ),
                          ),
                          Positioned(
                            bottom: -h * 0.07,
                            left: w * 0.06,
                            right: w * 0.06,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Responsive.isDesktop(context)
                                      ? h * 0.016
                                      : h * 0.013,
                                  horizontal: w * 0.06),
                              decoration: BoxDecoration(
                                color: containerColor,
                                border: Border.all(
                                  color: const Color(0xffE6E6E6),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (cName == "Home Inspection"
        ? controller.hqiChecklistName
        : controller.towerDataRes?.projectData?.checklistName ?? '')

                                       // "${controller.towerDataRes?.projectData!.checklistName}"
                                            .toString()
                                            .boldRobotoTextStyle(fontSize: 16),
                                        (h * 0.005).addHSpace(),
                                        SizedBox(
                                          width: w * 0.42,
                                          child: AppString.projectAddress
                                              .regularBarlowTextStyle(
                                                  fontSize: 12),
                                        )
                                      ],
                                    ),
                                    CircularStepProgressIndicator(
                                      totalSteps: 10,
                                      stepSize: 10,
                                      currentStep: controller.towerDataRes
                                              ?.projectData?.progress
                                              ?.toInt() ??
                                          0,
                                      padding: 0.05,
                                      height: Responsive.isDesktop(context)
                                          ? h * 0.15
                                          : h * 0.095,
                                      width: Responsive.isDesktop(context)
                                          ? h * 0.15
                                          : h * 0.095,
                                      selectedColor: greenColor,
                                      unselectedColor: const Color(0xffBCCCBF),
                                      child: Center(
                                        child:
                                          //  "${controller.towerDataRes?.projectData?.progress?.toInt()}%"
                                          "${cName == "Home Inspection" ? controller.hqiProgress.toInt() : controller.towerDataRes?.projectData?.progress?.toInt()}%"

                                                .boldRobotoTextStyle(
                                                    fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.062)
                                .copyWith(top: h * 0.013),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back_ios,
                                      size: 22, color: Colors.black),
                                ),
                                const Spacer(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.07
                                      : h * 0.04,
                                  width: Responsive.isDesktop(context)
                                      ? h * 0.07
                                      : h * 0.04,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.favourite();
                                      },
                                      child: Icon(
                                        controller.isFavorite
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        size: Responsive.isDesktop(context)
                                            ? h * 0.038
                                            : 22,
                                        color: controller.isFavorite
                                            ? Colors.black
                                            : redColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: Column(
                          children: [
                            (h * 0.09).addHSpace(),
                            Row(
                              children: [
                                Expanded(
                                    child: 1.0.appDivider(color: Colors.black)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: AppString.selectTower
                                      .boldRobotoTextStyle(fontSize: 16),
                                ),
                                Expanded(
                                    child: 1.0.appDivider(color: Colors.black)),
                              ],
                            ),

                            /// Show HQI Towers
                            if (cName == "Home Inspection")
                              controller.hqiTowersList.isEmpty
                                  ? SizedBox(
                                      height: h * 0.3,
                                      child: const Center(
                                        child: Text(
                                            'No HQI tower data available!'),
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: EdgeInsets.only(top: h * 0.017),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            Responsive.isTablet(context)
                                                ? w * 0.00322
                                                : w * 0.00512,
                                        crossAxisSpacing: w * 0.045,
                                        mainAxisSpacing: h * 0.02,
                                      ),
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.hqiTowersList.length,
                                      itemBuilder: (context, index) {
                                        final tower =
                                            controller.hqiTowersList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.hqiTowerDetailsScreen,
                                                arguments: {
                                                  'towerId':
                                                      tower.id.toString(),
                                                  'projectId':
                                                      "${controller.projectId}",
                                                  'towerName': tower.name,
                                                });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xffE6E6E6),
                                              ),
                                              color: containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Spacer(),
                                                    "${tower?.name ?? ''}"
                                                        .boldRobotoTextStyle(
                                                            fontSize: 14),
                                                    const Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      h * 0.012)
                                                          .copyWith(
                                                              bottom:
                                                                  h * 0.015),
                                                      child:
                                                          StepProgressIndicator(
                                                        totalSteps: 5,
                                                        roundedEdges:
                                                            const Radius
                                                                .circular(10),
                                                        // currentStep: tower
                                                        //        // ?.progress
                                                        //        // ?.toInt() ??
                                                        //     0,
                                                        unselectedSize:
                                                            h * 0.007,
                                                        size: h * 0.007,
                                                        selectedColor:
                                                            greenColor,
                                                        unselectedColor:
                                                            lightGreyColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )

                            /// Show Checklist Towers
                            else
                              (controller.towerDataRes?.projectData?.towerData
                                          ?.isEmpty ??
                                      false)
                                  ? SizedBox(
                                      height: h * 0.3,
                                      child: const Center(
                                        child: Text(
                                            'No checklist tower data available!'),
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: EdgeInsets.only(top: h * 0.017),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            Responsive.isTablet(context)
                                                ? w * 0.00322
                                                : w * 0.00512,
                                        crossAxisSpacing: w * 0.045,
                                        mainAxisSpacing: h * 0.02,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: controller
                                              .towerDataRes
                                              ?.projectData
                                              ?.towerData
                                              ?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final tower = controller.towerDataRes
                                            ?.projectData?.towerData?[index];

                                        return GestureDetector(
                                          onTap: () {
                                            String towerId =
                                                tower?.towerId?.toString() ??
                                                    '';

                                            if (cName ==
                                                "Material Inspection") {
                                              Get.toNamed(
                                                Routes.materialInspectionScreen,
                                                arguments: {
                                                  'towerId': towerId,
                                                  'projectId':
                                                      "${controller.projectId}",
                                                  "projectName":
                                                      "${controller.projectName}",
                                                  "buId": "${controller.buId}",
                                                  'name': tower?.name ?? '',
                                                },
                                              );
                                            } else {
                                              Get.toNamed(
                                                  Routes.towerDetailsScreen,
                                                  arguments: {
                                                    'towerId': towerId,
                                                    'projectId':
                                                        "${controller.projectId}",
                                                    'cName': cName,
                                                  });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xffE6E6E6),
                                              ),
                                              color: containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Spacer(),
                                                    "${tower?.name ?? ''}"
                                                        .boldRobotoTextStyle(
                                                            fontSize: 14),
                                                    const Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      h * 0.012)
                                                          .copyWith(
                                                              bottom:
                                                                  h * 0.015),
                                                      child:
                                                          StepProgressIndicator(
                                                        totalSteps: 5,
                                                        roundedEdges:
                                                            const Radius
                                                                .circular(10),
                                                        currentStep: tower
                                                                ?.progress
                                                                ?.toInt() ??
                                                            0,
                                                        unselectedSize:
                                                            h * 0.007,
                                                        size: h * 0.007,
                                                        selectedColor:
                                                            greenColor,
                                                        unselectedColor:
                                                            lightGreyColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }

              /// Handle ERROR state
              else if ((cName == "Home Inspection" &&
                      controller.getHQITowersResponse.status == Status.ERROR) ||
                  (cName != "Home Inspection" &&
                      controller.getTowerChecklistResponse.status ==
                          Status.ERROR)) {
                return const Center(child: Text('Server Error'));
              }

              /// Default fallback
              else {
                return const Center(child: Text('Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}
