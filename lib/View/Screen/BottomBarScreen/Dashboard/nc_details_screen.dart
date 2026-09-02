// //Working 24/11
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:get/get.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_assets.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_details_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';
// import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

// class NcDetailsScreen extends StatefulWidget {
//   const NcDetailsScreen({super.key});

//   @override
//   State<NcDetailsScreen> createState() => _NcDetailsScreenState();
// }

// class _NcDetailsScreenState extends State<NcDetailsScreen> {
//   NcController ncController = Get.put(NcController());

//   GenerateNcController controller = Get.put(GenerateNcController());

//   int? selectedProject;
//   int? selectedTower;
//   int? selectedFlat;
//   int? selectedFloor;
//   int? selectedActivity;
//   int? selectedActivityType;
//   int? selectedChecklistLine;
//   String? selectedFlagCategory;
//   String? descriptionController;

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         backgroundColor: backGroundColor,
//         floatingActionButton: SpeedDial(
//           visible:
//               preferences.getString(SharedPreference.userType) == "approver" ||
//                   preferences.getString(SharedPreference.userType) == "checker",
//           label: Text('NC Details'),
//           icon: Icons.add,
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           childPadding: EdgeInsets.all(16),
//           shape: CircleBorder(),
//           elevation: 6,
//           childrenButtonSize: Size(80, 80),
//           children: [
//             SpeedDialChild(
//              // child: Icon(Icons.add),
//               label: 'Generate NC',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => GenerateNcScreen(
//                       project_id: controller.project_id ?? 0,
//                       tower_id: controller.tower_id ?? 0,
//                       flat_id: controller.flat_id ?? 0,
//                       floor_id: controller.floor_id ?? 0,
//                       activity_id: controller.activity_id ?? 0,
//                       patn_id: controller.patn_id ?? 0,
//                       id: controller.id ?? 0,
//                       projectresId: controller.projectresId ?? 0,
//                       flag_category: controller.flag_category ?? '',
//                       description: controller.description ?? '',
//                       status:controller.status ?? '',
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SpeedDialChild(
//            //   child: Icon(Icons.visibility),
//               label: 'NC Details',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => GenerateNcDetailsScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: GetBuilder<NcController>(
//               builder: (controller) {
//                 return Column(
//                   children: [
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           width: w * 1,
//                           height: Responsive.isDesktop(context)
//                               ? h * 0.55
//                               : h * 0.33,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(25),
//                               bottomRight: Radius.circular(25),
//                             ),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(25),
//                               bottomRight: Radius.circular(25),
//                             ),
//                             child: networkImageShimmer(
//                                 h: h * 0.33,
//                                 radius: 0,
//                                 w: w,
//                                 url: controller.projectImage),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: -h * 0.07,
//                           left: w * 0.06,
//                           right: w * 0.06,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: h * 0.013, horizontal: w * 0.06),
//                             decoration: BoxDecoration(
//                               color: containerColor,
//                               border: Border.all(
//                                 color: const Color(0xffE6E6E6),
//                               ),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       controller.projectName
//                                           .boldRobotoTextStyle(fontSize: 16),
//                                       (h * 0.005).addHSpace(),
//                                       SizedBox(
//                                         width: w * 0.42,
//                                         child: AppString.projectAddress
//                                             .regularBarlowTextStyle(
//                                                 fontSize: 12),
//                                       )
//                                     ],
//                                   ),
//                                   CircularStepProgressIndicator(
//                                     totalSteps: 10,
//                                     stepSize: 10,
//                                     currentStep: 7,
//                                     padding: 0.05,
//                                     height: h * 0.095,
//                                     width: h * 0.095,
//                                     selectedColor: greenColor,
//                                     unselectedColor: const Color(0xffBCCCBF),
//                                     child: Center(
//                                       child:
//                                           "${controller.projectNcResponseModel?.projectData?.progress?.toInt()}%"
//                                               .boldRobotoTextStyle(
//                                                   fontSize: 18),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: w * 0.06)
//                               .copyWith(top: h * 0.025),
//                           child: GestureDetector(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Icon(Icons.arrow_back_ios,
//                                 size: 22, color: blackColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Builder(
//                       builder: (context) {
//                         if (controller.getProjectNCApiResponse.status ==
//                             Status.LOADING) {
//                           return Column(
//                             children: [
//                               (h * 0.3).addHSpace(),
//                               showCircular(),
//                             ],
//                           );
//                         } else if (controller.getProjectNCApiResponse.status ==
//                             Status.COMPLETE) {
//                           List<Map<String, dynamic>> data = [
//                             {
//                               "title": AppString.totalNc,
//                               "value": '${controller.ncModel.totalNc}',
//                               "color": blackColor
//                             },
//                             {
//                               "title": AppString.yellowCard,
//                               "value": '${controller.ncModel.yellow}',
//                               "color": Colors.yellow,
//                             },
//                             {
//                               "title": AppString.orangeCard,
//                               "value": '${controller.ncModel.orange}',
//                               "color": orangeColor
//                             },
//                             {
//                               "title": AppString.redCard,
//                               "value": '${controller.ncModel.red}',
//                               "color": redColor
//                             },
//                             {
//                               "title": AppString.greenCard,
//                               "value": '${controller.ncModel.green}',
//                               "color": greenColor
//                             },
//                           ];

//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                             child: Column(
//                               children: [
//                                 (h * 0.097).addHSpace(),
//                                 SearchAndFilterRow(
//                                   controller: controller.searchController,
//                                   hintText: AppString.searchParameter,
//                                   onChanged: (p0) {
//                                     setState(() {});
//                                   },
//                                   onTap: () {
//                                     Get.toNamed(Routes.filterScreen);
//                                   },
//                                 ),
//                                 if (controller.filterIndex != 0) ...[
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       "Filter applied for :  "
//                                           .boldRobotoTextStyle(
//                                               textAlign: TextAlign.center,
//                                               fontSize: 15,
//                                               fontColor: appColor),
//                                       Flexible(
//                                         child:
//                                             "${controller.filterIndex == 1 ? controller.selectedTower?.towerName : controller.filterIndex == 2 ? controller.selectedFlatData?.flatName : controller.filterIndex == 3 ? controller.selectedFlatActivity?.activityName : controller.filterIndex == 4 ? controller.selectedFlatActivityType?.activityTypeName : controller.filterIndex == 5 ? controller.selectedFlatChecklist?.checklistName : controller.filterIndex == 6 ? controller.selectedFloorData?.floorName : controller.filterIndex == 7 ? controller.selectedFloorActivity?.activityName : controller.filterIndex == 8 ? controller.selectedFloorActivityType?.activityTypeName : controller.selectedFloorChecklist?.checklistName}"
//                                                 .regularRobotoTextStyle(
//                                                     maxLine: 10,
//                                                     textAlign: TextAlign.start,
//                                                     fontSize: 14,
//                                                     textOverflow:
//                                                         TextOverflow.ellipsis,
//                                                     fontColor: blackColor),
//                                       ),
//                                     ],
//                                   ).paddingSymmetric(vertical: h * 0.017)
//                                 ],
//                                 (controller.filterIndex != 0
//                                         ? h * 0
//                                         : h * 0.025)
//                                     .addHSpace(),
//                                 Builder(builder: (context) {
//                                   int index = data.indexWhere(
//                                     (element) => element['title']
//                                         .toString()
//                                         .toLowerCase()
//                                         .contains(
//                                           controller.searchController.text
//                                               .toString()
//                                               .toLowerCase(),
//                                         ),
//                                   );

//                                   return index >= 0
//                                       ? ListView.builder(
//                                           physics:
//                                               const NeverScrollableScrollPhysics(),
//                                           itemCount: data.length,
//                                           shrinkWrap: true,
//                                           itemBuilder: (context, index) {
//                                             return data[index]['title']
//                                                     .toString()
//                                                     .toLowerCase()
//                                                     .contains(
//                                                       controller
//                                                           .searchController.text
//                                                           .toString()
//                                                           .toLowerCase(),
//                                                     )
//                                                 ? buildContainer(
//                                                     h: h,
//                                                     w: w,
//                                                     color: data[index]['color'],
//                                                     count: data[index]['value'],
//                                                     title: data[index]['title'],
//                                                     // onTap: () {
//                                                     //   Navigator.push(
//                                                     //     context,
//                                                     //     MaterialPageRoute(
//                                                     //         builder: (context) =>
//                                                     //             GenerateNcScreen()),
//                                                     //   );
//                                                     // }
//                                                   )
//                                                 : const SizedBox();
//                                           },
//                                         )
//                                       : const Text('No search data!')
//                                           .paddingOnly(top: h * 0.15);
//                                 }),
//                               ],
//                             ),
//                           );
//                         } else if (controller.getProjectNCApiResponse.status ==
//                             Status.ERROR) {
//                           return const Center(
//                             child: Text('Server Error'),
//                           );
//                         } else {
//                           return const Center(
//                             child: Text('Something went wrong'),
//                           );
//                         }
//                       },
//                     )
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildContainer({
//     required double h,
//     required double w,
//     required String count,
//     required Color color,
//     required String title,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: h * 0.06,
//         width: w,
//         margin: EdgeInsets.only(bottom: h * 0.015),
//         padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: const Color(0xffE6E6E6),
//           ),
//           color: containerColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             title.regularRobotoTextStyle(fontSize: 18),
//             const Spacer(),
//             count.semiBoldBarlowTextStyle(fontSize: 18, fontColor: color),
//           ],
//         ),
//       ),
//     );
//   }
// }

//NEW NC FLOW 24/11
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class NcDetailsScreen extends StatefulWidget {
  const NcDetailsScreen({super.key});

  @override
  State<NcDetailsScreen> createState() => _NcDetailsScreenState();
}

class _NcDetailsScreenState extends State<NcDetailsScreen> {
  NcController ncController = Get.put(NcController());
  GenerateNcController controller = Get.put(GenerateNcController());

  int? selectedProject;
  int? selectedTower;
  int? selectedFlat;
  int? selectedFloor;
  int? selectedActivity;
  int? selectedActivityType;
  int? selectedChecklistLine;
  String? selectedFlagCategory;
  String? descriptionController;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final userType = preferences.getString(SharedPreference.userType);

    return Container(
      color: backGroundColor,
      child: Scaffold(
        backgroundColor: backGroundColor,

        // FAB visible only for checker/approver
        // floatingActionButton: SpeedDial(
        //   // visible: userType == "approver" || userType == "checker",
        //   visible: userType == "maker" ||
        //       userType == "approver" ||
        //       userType == "checker",
        //   label: Text('NC Details'),
        //   icon: Icons.add,
        //   backgroundColor: Colors.black,
        //   foregroundColor: Colors.white,
        //   elevation: 6,
        //   childrenButtonSize: Size(80, 80),
        //   children: [
        //     SpeedDialChild(
        //       label: 'Generate NC',
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => GenerateNcScreen(
        //               project_id: controller.project_id ?? 0,
        //               tower_id: controller.tower_id ?? 0,
        //               flat_id: controller.flat_id ?? 0,
        //               floor_id: controller.floor_id ?? 0,
        //               activity_id: controller.activity_id ?? 0,
        //               patn_id: controller.patn_id ?? 0,
        //               id: controller.id ?? 0,
        //               projectresId: controller.projectresId ?? 0,
        //               flag_category: controller.flag_category ?? '',
        //               description: controller.description ?? '',
        //               status: controller.status ?? '',
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //     // SpeedDialChild(
        //     //   label: 'NC Details',

        //     //   onTap: () {
        //     //     Navigator.push(
        //     //       context,
        //     //       MaterialPageRoute(
        //     //         builder: (context) => GenerateNcDetailsScreen(
        //     //           fromMaker: userType == "maker" ? true : false,
        //     //         ),
        //     //       ),
        //     //     );
        //     //   },
        //     // ),
        //     SpeedDialChild(
        //       label: 'NC Details',
        //       onTap: () {
        //         if (userType == "maker") {
        //           // maker goes directly to NC Details screen
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => GenerateNcDetailsScreen(
        //                 fromMaker: true,
        //               ),
        //             ),
        //           );
        //         } else {
        //           // checker + approver see submenu (existing behavior)
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => GenerateNcDetailsScreen(),
        //             ),
        //           );
        //         }
        //       },
        //     ),
        //   ],
        // ),
        //24/11
        // floatingActionButton: SpeedDial(
        //   visible: true,
        //   label: Text('NC Details'),
        //   icon: Icons.add,
        //   backgroundColor: Colors.black,
        //   foregroundColor: Colors.white,
        //   elevation: 6,
        //   childrenButtonSize: Size(80, 80),

        //   // ⭐ MAKER → Direct navigation (NO submenu)
        //   onPress: () {
        //     if (userType == "maker") {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => GenerateNcDetailsScreen(
        //             fromMaker: true,
        //           ),
        //         ),
        //       );
        //     }
        //   },

        //   // ⭐ CHECKER & APPROVER → submenu remains same
        //   children: userType == "maker"
        //       ? []
        //       : [
        //           SpeedDialChild(
        //             label: 'Generate NC',
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => GenerateNcScreen(
        //                     project_id: controller.project_id ?? 0,
        //                     tower_id: controller.tower_id ?? 0,
        //                     flat_id: controller.flat_id ?? 0,
        //                     floor_id: controller.floor_id ?? 0,
        //                     activity_id: controller.activity_id ?? 0,
        //                     patn_id: controller.patn_id ?? 0,
        //                     id: controller.id ?? 0,
        //                     projectresId: controller.projectresId ?? 0,
        //                     flag_category: controller.flag_category ?? '',
        //                     description: controller.description ?? '',
        //                     status: controller.status ?? '',
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //           SpeedDialChild(
        //             label: 'NC Details',
        //             onTap: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => GenerateNcDetailsScreen(),
        //                 ),
        //               );
        //             },
        //           ),
        //         ],
        // ),

//===================================
        //25/11
        floatingActionButton: userType == "maker"
            // Simple FAB for maker — tap goes directly to GenerateNcDetailsScreen
            ? FloatingActionButton.extended(
                backgroundColor:  const Color(0xFF3498DB),
                icon: Icon(Icons.add, color: Colors.white),
                label:
                    Text('NC Details', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GenerateNcDetailsScreen(fromMaker: true),
                    ),
                  );
                },
              )
            // SpeedDial for checker / approver — no onPress that returns a value
            : SpeedDial(
                visible: true,
                label: Text('NC Details'),
                icon: Icons.add,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 6,
                childrenButtonSize: Size(80, 80),
                children: [
                  SpeedDialChild(
                    label: 'Generate NC',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenerateNcScreen(
                            project_id: controller.project_id ?? 0,
                            tower_id: controller.tower_id ?? 0,
                            flat_id: controller.flat_id ?? 0,
                            floor_id: controller.floor_id ?? 0,
                            activity_id: controller.activity_id ?? 0,
                            patn_id: controller.patn_id ?? 0,
                            id: controller.id ?? 0,
                            projectresId: controller.projectresId ?? 0,
                            flag_category: controller.flag_category ?? '',
                            description: controller.description ?? '',
                            status: controller.status ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                  SpeedDialChild(
                    label: 'NC Details',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenerateNcDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
        //=============================

        body: SafeArea(
          child: SingleChildScrollView(
            child: GetBuilder<NcController>(
              builder: (controller) {
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: w,
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
                                url: controller.projectImage),
                          ),
                        ),
                        Positioned(
                          bottom: -h * 0.07,
                          left: w * 0.06,
                          right: w * 0.06,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.013, horizontal: w * 0.06),
                            decoration: BoxDecoration(
                              color: containerColor,
                              border: Border.all(color: Color(0xffE6E6E6)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.projectName
                                        .boldRobotoTextStyle(fontSize: 16),
                                    (h * 0.005).addHSpace(),
                                    SizedBox(
                                      width: w * 0.42,
                                      child: AppString.projectAddress
                                          .regularBarlowTextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                CircularStepProgressIndicator(
                                  totalSteps: 10,
                                  stepSize: 10,
                                  currentStep: 7,
                                  padding: 0.05,
                                  height: h * 0.095,
                                  width: h * 0.095,
                                  selectedColor: greenColor,
                                  unselectedColor: Color(0xffBCCCBF),
                                  child: Center(
                                    child:
                                        "${controller.projectNcResponseModel?.projectData?.progress?.toInt()}%"
                                            .boldRobotoTextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: h * 0.025,
                          left: w * 0.06,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back_ios,
                                size: 22, color: blackColor),
                          ),
                        ),
                      ],
                    ),
                    Builder(builder: (context) {
                      if (controller.getProjectNCApiResponse.status ==
                          Status.LOADING) {
                        return Column(
                          children: [
                            (h * 0.3).addHSpace(),
                            showCircular(),
                          ],
                        );
                      }

                      if (controller.getProjectNCApiResponse.status ==
                          Status.ERROR) {
                        return const Center(child: Text('Server Error'));
                      }

                      if (controller.getProjectNCApiResponse.status !=
                          Status.COMPLETE) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }

                      // MAKER vs APPROVER/CHECKER UI

                      List<Map<String, dynamic>> data = [];

                      //08/12
                      // if (userType == "maker") {
                      //   data = []; // maker will see no cards
                      // } else {
                      // Existing cards for checker/approver
                      data = [
                        {
                          "title": AppString.totalNc,
                          "value": '${controller.ncModel.totalNc}',
                          "color": blackColor
                        },
                        {
                          "title": AppString.yellowCard,
                          "value": '${controller.ncModel.yellow}',
                          "color": Colors.yellow,
                        },
                        {
                          "title": AppString.orangeCard,
                          "value": '${controller.ncModel.orange}',
                          "color": orangeColor
                        },
                        {
                          "title": AppString.redCard,
                          "value": '${controller.ncModel.red}',
                          "color": redColor
                        },
                        {
                          "title": AppString.greenCard,
                          "value": '${controller.ncModel.green}',
                          "color": greenColor
                        },
                      ];
                      //  }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: Column(
                          children: [
                            (h * 0.097).addHSpace(),

                            // Search bar ONLY for checker/approver
                            //08/12
                            // if (userType != "maker")
                            SearchAndFilterRow(
                              controller: controller.searchController,
                              hintText: AppString.searchParameter,
                              onChanged: (p0) => setState(() {}),
                              onTap: () {
                                Get.toNamed(Routes.filterScreen);
                              },
                            ),
                            //Adding space
                            if (userType != "maker" &&
                                controller.filterIndex != 0)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "Filter applied for :  ".boldRobotoTextStyle(
                                      fontSize: 15, fontColor: appColor),
                                  Flexible(
                                    child:
                                        "${controller.filterIndex == 1 ? controller.selectedTower?.towerName : controller.filterIndex == 2 ? controller.selectedFlatData?.flatName : controller.filterIndex == 3 ? controller.selectedFlatActivity?.activityName : controller.filterIndex == 4 ? controller.selectedFlatActivityType?.activityTypeName : controller.filterIndex == 5 ? controller.selectedFlatChecklist?.checklistName : controller.filterIndex == 6 ? controller.selectedFloorData?.floorName : controller.filterIndex == 7 ? controller.selectedFloorActivity?.activityName : controller.selectedFloorChecklist?.checklistName}"
                                            .regularRobotoTextStyle(
                                                maxLine: 10,
                                                fontSize: 14,
                                                textAlign: TextAlign.start,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                  ),
                                ],
                              ).paddingSymmetric(vertical: h * 0.017),

                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildContainer(
                                    h: h,
                                    w: w,
                                    color: data[index]["color"],
                                    count: data[index]["value"],
                                    title: data[index]["title"],

                                    // onTap: () {
                                    //   if (userType == "maker") {
                                    //     // TEMP: Open NC details for both cards
                                    //     Get.to(() => GenerateNcDetailsScreen());
                                    //   }
                                    // },
                                    onTap: () {
                                      if (userType == "maker") {
                                        Get.to(() => GenerateNcDetailsScreen(
                                              fromMaker: true, // 👈 ADD THIS
                                            ));
                                      }
                                    });
                              },
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer({
    required double h,
    required double w,
    required String count,
    required Color color,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h * 0.06,
        width: w,
        margin: EdgeInsets.only(bottom: h * 0.015),
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE6E6E6)),
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            title.regularRobotoTextStyle(fontSize: 18),
            Spacer(),
            count.semiBoldBarlowTextStyle(fontSize: 18, fontColor: color),
          ],
        ),
      ),
    );
  }
}
