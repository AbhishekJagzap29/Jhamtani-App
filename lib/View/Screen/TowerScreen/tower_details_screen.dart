
// //14/04/2026  UPDATE - CUBE TESTING MODULE INTEGRATION
// import 'dart:developer';

// import 'package:jhamtani_app/Api/Apis/api_response.dart';
// import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
// import 'package:jhamtani_app/View/Constant/app_color.dart';
// import 'package:jhamtani_app/View/Constant/app_string.dart';
// import 'package:jhamtani_app/View/Constant/responsive.dart';
// import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';
// import 'package:jhamtani_app/View/Screen/TowerScreen/tower_controller.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';
// import 'package:jhamtani_app/View/Utils/app_routes.dart';
// import 'package:jhamtani_app/View/Utils/extension.dart';
// import 'package:jhamtani_app/View/Widgets/app_bar.dart';
// import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
// import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';


// class TowerDetailsScreen extends StatefulWidget {
//   const TowerDetailsScreen({super.key});

//   @override
//   State<TowerDetailsScreen> createState() => _TowerDetailsScreenState();
// }

// class _TowerDetailsScreenState extends State<TowerDetailsScreen> {
//   TowerController towerController = Get.put(TowerController());
//   //13/03/2026
//   var cName = Get.arguments['cName'] ?? "";
//   final bool isCubeTesting = (Get.arguments['cName'] ?? "") == "Cube Testing";

//   @override
//   void initState() {
//     super.initState();
//     if (isCubeTesting) {
//       // Force floor view for Cube Testing
//       towerController.selectFlatFloor(1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         floatingActionButton: const CommonBackToHomeButton(),
//         backgroundColor: backGroundColor,
//         appBar: AppBarWidget(
//           title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20),
//         ),
//         body: SafeArea(
//           child: GetBuilder<TowerController>(
//             builder: (controller) {
//               if (controller.getFlatFlorApiResponse.status == Status.LOADING) {
//                 return showCircular();
//               } else if (controller.getFlatFlorApiResponse.status ==
//                   Status.COMPLETE) {
//                 log('controller.flatFloorRes?.towerData!.progress==========>>>>>${controller.flatFloorRes?.towerData!.progress}');

//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         (h * 0.03).addHSpace(),

//                         // Tower summary card (same for all modules)
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             vertical: h * 0.015,
//                             horizontal: w * 0.045,
//                           ),
//                           decoration: BoxDecoration(
//                             color: containerColor,
//                             border: Border.all(color: const Color(0xffE6E6E6)),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: w * 0.55,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           "${controller.flatFloorRes?.towerData!.towerName}"
//                                               .toString()
//                                               .boldRobotoTextStyle(
//                                                   fontSize: 22),
//                                           (h * 0.005).addHSpace(),
//                                           SizedBox(
//                                             width: w * 0.42,
//                                             child: AppString.projectAddress
//                                                 .regularBarlowTextStyle(
//                                                     fontSize: 12),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     CircularStepProgressIndicator(
//                                       totalSteps: 10,
//                                       stepSize: 10,
//                                       currentStep: controller
//                                               .flatFloorRes?.towerData?.progress
//                                               ?.toInt() ??
//                                           0,
//                                       padding: 0.05,
//                                       height: Responsive.isDesktop(context)
//                                           ? h * 0.13
//                                           : h * 0.1,
//                                       width: Responsive.isDesktop(context)
//                                           ? h * 0.13
//                                           : h * 0.1,
//                                       selectedColor: greenColor,
//                                       unselectedColor: const Color(0xffBCCCBF),
//                                       child: Center(
//                                         child:
//                                             "${controller.flatFloorRes?.towerData?.progress?.toInt()}%"
//                                                 .boldRobotoTextStyle(
//                                                     fontSize: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   color: const Color(0xffE6E6E6),
//                                   thickness: 2,
//                                   height: h * 0.02,
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Total Checklist             :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerTotalCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                  if (!isCubeTesting) ...[
//                                  Row(
//                                   children: [
//                                     'Maker Submitted        :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerMakerCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Checker Submitted    :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerCheckerCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Approver Submitted  :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerApproverCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                  ]
//                                 // ... other count rows (maker, checker, approver) ...
//                               ],
//                             ),
//                           ),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: Responsive.isDesktop(context)
//                                 ? h * 0.028
//                                 : h * 0.014,
//                           ),
//                           child: SearchAndFilterRow(
//                             onChanged: (p0) => controller.searchData(),
//                             controller: controller.searchController,
//                             hintText: AppString.searchTower,
//                           ),
//                         ),

//                         // ── Hide tabs when in Cube Testing mode ────────────────────────
//                         if (!isCubeTesting) ...[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   controller.searchController.clear();
//                                   controller.selectFlatFloor(0);
//                                 },
//                                 child: Container(
//                                   height: Responsive.isDesktop(context)
//                                       ? h * 0.068
//                                       : h * 0.048,
//                                   width: w * 0.23,
//                                   decoration: BoxDecoration(
//                                     color: controller.select == 0
//                                         ? appColor
//                                         : containerColor,
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       bottomLeft: Radius.circular(10),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: AppString.flat.boldRobotoTextStyle(
//                                       fontSize: 16,
//                                       fontColor: controller.select == 0
//                                           ? backGroundColor
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   controller.searchController.clear();
//                                   controller.selectFlatFloor(1);
//                                 },
//                                 child: Container(
//                                   height: Responsive.isDesktop(context)
//                                       ? h * 0.068
//                                       : h * 0.048,
//                                   width: w * 0.23,
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                       topRight: Radius.circular(10),
//                                       bottomRight: Radius.circular(10),
//                                     ),
//                                     color: controller.select == 1
//                                         ? appColor
//                                         : containerColor,
//                                   ),
//                                   child: Center(
//                                     child: AppString.floor.boldRobotoTextStyle(
//                                       fontSize: 16,
//                                       fontColor: controller.select == 1
//                                           ? backGroundColor
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           (h * 0.015).addHSpace(),
//                         ],

//                         // ── Grid ───────────────────────────────────────────────────────
//                         if (isCubeTesting && controller.searchListFloorData.isEmpty) ...[
//                           SizedBox(
//                             height: h * 0.4,
//                             child: const Center(child: Text('No floor data available!')),
//                           ),
//                         ] else if (!isCubeTesting &&
//                             controller.select == 0 &&
//                             controller.searchListFlatData.isEmpty) ...[
//                           SizedBox(
//                             height: h * 0.4,
//                             child: const Center(child: Text('No flat data available!')),
//                           ),
//                         ] else if (!isCubeTesting &&
//                             controller.select == 1 &&
//                             controller.searchListFloorData.isEmpty) ...[
//                           SizedBox(
//                             height: h * 0.4,
//                             child: const Center(child: Text('No floor data available!')),
//                           ),
//                         ] else ...[
//                           GridView.builder(
//                             padding: EdgeInsets.symmetric(
//                               vertical: Responsive.isDesktop(context)
//                                   ? h * 0.03
//                                   : h * 0.017,
//                             ),
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: Responsive.isTablet(context)
//                                   ? w * 0.00322
//                                   : w * 0.00512,
//                               crossAxisSpacing: w * 0.045,
//                               mainAxisSpacing: h * 0.02,
//                             ),
//                             shrinkWrap: true,
//                             itemCount: isCubeTesting
//                                 ? controller.searchListFloorData.length
//                                 : (controller.select == 0
//                                     ? controller.searchListFlatData.length
//                                     : controller.searchListFloorData.length),
//                             itemBuilder: (context, index) {
//                               ListFloor responseData = isCubeTesting
//                                   ? controller.searchListFloorData[index]
//                                   : (controller.select == 0
//                                       ? controller.searchListFlatData[index]
//                                       : controller.searchListFloorData[index]);

//                               double per = double.parse(responseData.progress ?? "0.00");

//                               final count = per < 20
//                                   ? 0
//                                   : per < 40
//                                       ? 1
//                                       : per < 60
//                                           ? 2
//                                           : per < 80
//                                               ? 3
//                                               : per == 100
//                                                   ? 5
//                                                   : 4;

//                               return GestureDetector(
//                                 onTap: () {
//                                   final data = TowerIdDataModal(
//                                     id: responseData.floorId.toString(),
//                                     towerName:
//                                         controller.flatFloorRes!.towerData!.towerName,
//                                   );

//                                   if (isCubeTesting) {
//                                     Get.to(
//                                       () => CubeRecordsScreen(
//                                         floorId: responseData.floorId!,
//                                       ),
//                                       arguments: {
//                                         "floorId": responseData.floorId,
//                                         "towerId": controller
//                                             .flatFloorRes?.towerData?.towerId,
//                                         "towerName": controller
//                                             .flatFloorRes?.towerData?.towerName,
//                                         "floorName": responseData.name,
//                                       },
//                                     );
//                                   } else {
//                                     Get.toNamed(
//                                       controller.select == 0
//                                           ? Routes.flatActivityScreen
//                                           : Routes.floorActivityScreen,
//                                       arguments: {
//                                         "model": data,
//                                         "count": count,
//                                         "progress": responseData.progress ?? "0.00",
//                                         "tower_data": controller.flatFloorRes?.towerData,
//                                         "flat_floor_data": controller.select == 0
//                                             ? controller.flatFloorRes?.towerData
//                                                 ?.listFlatData![index]
//                                             : controller.flatFloorRes?.towerData
//                                                 ?.listFloorData![index],
//                                       },
//                                     );
//                                   }
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: const Color(0xffE6E6E6)),
//                                     color: containerColor,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         (h * 0.015).addHSpace(),
//                                         const Spacer(),
//                                         '${responseData.name}'
//                                             .toString()
//                                             .boldRobotoTextStyle(fontSize: 16),
//                                         const Spacer(),
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: h * 0.012,
//                                           ).copyWith(bottom: h * 0.015),
//                                           child: StepProgressIndicator(
//                                             totalSteps: 5,
//                                             roundedEdges: const Radius.circular(10),
//                                             currentStep: count,
//                                             unselectedSize: h * 0.007,
//                                             size: h * 0.007,
//                                             selectedColor: greenColor,
//                                             unselectedColor: lightGreyColor,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],

//                         // ── Load more ──────────────────────────────────────────────────
//                         if (isCubeTesting &&
//                             controller.floorLength ==
//                                 controller.searchListFloorData.length) ...[
//                           const SizedBox(),
//                         ] else if (!isCubeTesting &&
//                             ((controller.flatLength ==
//                                         controller.searchListFlatData.length &&
//                                     controller.select == 0) ||
//                                 (controller.floorLength ==
//                                         controller.searchListFloorData.length &&
//                                     controller.select == 1))) ...[
//                           const SizedBox(),
//                         ] else ...[
//                           Center(
//                             child: controller.load
//                                 ? showCircular()
//                                 : TextButton(
//                                     onPressed: () {
//                                       if (isCubeTesting || controller.select == 1) {
//                                         controller.setFloorLength(false);
//                                       } else {
//                                         controller.setFlatLength(false);
//                                       }
//                                     },
//                                     child: "Load more"
//                                         .semiBoldBarlowTextStyle(fontColor: appColor),
//                                   ),
//                           ),
//                         ],

//                         (h * 0.1).addHSpace(),
//                       ],
//                     ),
//                   ),
//                 );
//               } else if (controller.getFlatFlorApiResponse.status ==
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
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/common_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_tower_controller.dart';
import 'package:jhamtani_app/View/Screen/TowerScreen/tower_controller.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';

class TowerDetailsScreen extends StatefulWidget {
  const TowerDetailsScreen({super.key});

  @override
  State<TowerDetailsScreen> createState() => _TowerDetailsScreenState();
}

class _TowerDetailsScreenState extends State<TowerDetailsScreen> {
  TowerController towerController = Get.put(TowerController());
  var cName = "";
  bool isCubeTesting = false;

  @override
  void initState() {
    super.initState();
    cName = (Get.arguments is Map && Get.arguments.containsKey('cName'))
        ? Get.arguments['cName'] ?? ""
        : "";
    isCubeTesting = cName == "Cube Testing";
    if (isCubeTesting) {
      // Force floor view for Cube Testing
      towerController.selectFlatFloor(1);
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
            title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20,fontColor: Colors.white)),
        body: SafeArea(
          child: GetBuilder<TowerController>(
            builder: (controller) {
              if (controller.getFlatFlorApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.getFlatFlorApiResponse.status ==
                  Status.COMPLETE) {
                bool isDevelopmentTower =
                    controller.flatFloorRes?.towerData?.towerName ==
                        "DEVELOPMENT";

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (h * 0.03).addHSpace(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: h * 0.015, horizontal: w * 0.045),
                          decoration: BoxDecoration(
                            color: containerColor,
                            border: Border.all(
                              color: const Color(0xffE6E6E6),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: w * 0.55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          "${controller.flatFloorRes?.towerData!.towerName}"
                                              .toString()
                                              .boldRobotoTextStyle(
                                                  fontSize: 22),
                                          (h * 0.005).addHSpace(),
                                          SizedBox(
                                            width: w * 0.42,
                                            child: AppString.projectAddress
                                                .regularBarlowTextStyle(
                                                    fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    CircularStepProgressIndicator(
                                      totalSteps: 10,
                                      stepSize: 10,
                                      currentStep: controller
                                              .flatFloorRes?.towerData?.progress
                                              ?.toInt() ??
                                          0,
                                      padding: 0.05,
                                      height: Responsive.isDesktop(context)
                                          ? h * 0.13
                                          : h * 0.1,
                                      width: Responsive.isDesktop(context)
                                          ? h * 0.13
                                          : h * 0.1,
                                      selectedColor: greenColor,
                                      unselectedColor: const Color(0xffBCCCBF),
                                      child: Center(
                                        child:
                                            "${controller.flatFloorRes?.towerData?.progress?.toInt()}%"
                                                .boldRobotoTextStyle(
                                                    fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: const Color(0xffE6E6E6),
                                  thickness: 2,
                                  height: h * 0.02,
                                ),
                                Row(
                                  children: [
                                    'Total Checklists           : '
                                        .boldRobotoTextStyle(fontSize: 12),
                                    ((controller.select == 0
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.flatTotalCount ??
                                                    0)
                                                : controller.select == 1
                                                    ? (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.floorTotalCount ??
                                                        0)
                                                    : (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.comTotal ??
                                                        0)) +
                                            (controller.flatFloorRes?.towerData
                                                        ?.towerName
                                                        ?.toLowerCase() ==
                                                    'development'
                                                ? (controller.flatFloorRes
                                                        ?.towerData?.devTotal ??
                                                    0)
                                                : 0))
                                        .toString()
                                        .regularRobotoTextStyle(fontSize: 10),
                                  ],
                                ),
                                Row(
                                  children: [
                                    'Maker Submitted        :  '
                                        .boldRobotoTextStyle(fontSize: 12),
                                    ((controller.select == 0
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.flatMakerCount ??
                                                    0)
                                                : controller.select == 1
                                                    ? (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.floorMakerCount ??
                                                        0)
                                                    : (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.comMaker ??
                                                        0)) +
                                            (controller.flatFloorRes?.towerData
                                                        ?.towerName
                                                        ?.toLowerCase() ==
                                                    'development'
                                                ? (controller.flatFloorRes
                                                        ?.towerData?.devMaker ??
                                                    0)
                                                : 0))
                                        .toString()
                                        .regularRobotoTextStyle(fontSize: 10),
                                  ],
                                ),
                                Row(
                                  children: [
                                    'Checker Submitted    :  '
                                        .boldRobotoTextStyle(fontSize: 12),
                                    ((controller.select == 0
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.flatCheckerCount ??
                                                    0)
                                                : controller.select == 1
                                                    ? (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.floorCheckerCount ??
                                                        0)
                                                    : (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.comChecker ??
                                                        0)) +
                                            (controller.flatFloorRes?.towerData
                                                        ?.towerName
                                                        ?.toLowerCase() ==
                                                    'development'
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.devChecker ??
                                                    0)
                                                : 0))
                                        .toString()
                                        .regularRobotoTextStyle(fontSize: 10),
                                  ],
                                ),
                                Row(
                                  children: [
                                    'Approver Submitted  :  '
                                        .boldRobotoTextStyle(fontSize: 12),
                                    ((controller.select == 0
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.flatApproverCount ??
                                                    0)
                                                : controller.select == 1
                                                    ? (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.floorApproverCount ??
                                                        0)
                                                    : (controller
                                                            .flatFloorRes
                                                            ?.towerData
                                                            ?.comApprover ??
                                                        0)) +
                                            (controller.flatFloorRes?.towerData
                                                        ?.towerName
                                                        ?.toLowerCase() ==
                                                    'development'
                                                ? (controller
                                                        .flatFloorRes
                                                        ?.towerData
                                                        ?.devApprover ??
                                                    0)
                                                : 0))
                                        .toString()
                                        .regularRobotoTextStyle(fontSize: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.isDesktop(context)
                                ? h * 0.028
                                : h * 0.014,
                          ),
                          child: SearchAndFilterRow(
                            onChanged: (p0) {
                              controller.searchData();
                            },
                            controller: controller.searchController,
                            hintText: isDevelopmentTower
                                ? "Search Activity"
                                : controller.select == 0
                                    ? "Search Flat"
                                    : controller.select == 1
                                        ? "Search Floor"
                                        : "Search Activity",
                          ),
                        ),
                        if (!isDevelopmentTower && !isCubeTesting) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.searchController.clear();
                                  controller.selectFlatFloor(0);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.15,
                                  decoration: BoxDecoration(
                                    color: controller.select == 0
                                        ?  const Color(0xFF3498DB)

                                        : containerColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppString.flat.boldRobotoTextStyle(
                                      fontSize: 13,
                                      fontColor: controller.select == 0
                                          ? backGroundColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.searchController.clear();
                                  controller.selectFlatFloor(1);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.15,
                                  decoration: BoxDecoration(
                                    color: controller.select == 1
                                        ?  const Color(0xFF3498DB)

                                        : containerColor,
                                  ),
                                  child: Center(
                                    child: AppString.floor.boldRobotoTextStyle(
                                      fontSize: 13,
                                      fontColor: controller.select == 1
                                          ? backGroundColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.searchController.clear();
                                  controller.selectCommonTab(2);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.20,
                                  decoration: BoxDecoration(
                                    color: controller.select == 2
                                        ?  const Color(0xFF3498DB)

                                        : containerColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppString.common.boldRobotoTextStyle(
                                      fontSize: 13,
                                      fontColor: controller.select == 2
                                          ? backGroundColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (isDevelopmentTower) ...[
                          if (controller
                              .searchDevelopmentActivityCommonData.isEmpty) ...[
                            SizedBox(
                              height: h * 0.4,
                              child: const Center(
                                child: Text('No checklist data available!'),
                              ),
                            ),
                          ] else ...[
                            GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: Responsive.isDesktop(context)
                                      ? h * 0.03
                                      : h * 0.017),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: Responsive.isTablet(context)
                                    ? w * 0.00322
                                    : w * 0.01200,
                                crossAxisSpacing: h * 0.02,
                                mainAxisSpacing: h * 0.04,
                              ),
                              shrinkWrap: true,
                              itemCount: controller
                                  .searchDevelopmentActivityCommonData.length,
                              itemBuilder: (context, index) {
                                controller
                                    .searchDevelopmentActivityCommonData[index];

                                return GestureDetector(
                                    onTap: () async {
                                      final data = ActivityTypeItem(
                                        activityId: controller
                                            .searchDevelopmentActivityCommonData[
                                                index]
                                            .activityId,
                                        name: controller
                                            .searchDevelopmentActivityCommonData[
                                                index]
                                            .name,
                                        desc: controller
                                            .searchDevelopmentActivityCommonData[
                                                index]
                                            .desc,
                                        activityTypeStatus: controller
                                            .searchDevelopmentActivityCommonData[
                                                index]
                                            .activityTypeStatus,
                                        color: controller
                                            .searchDevelopmentActivityCommonData[
                                                index]
                                            .color,
                                      );
                                      await Get.toNamed(
                                        Routes.activityDetailsScreen,
                                        arguments: {
                                          "activityId": data.activityId,
                                          "model": ConstDataModel(
                                            data: data,
                                            screen: 'tower_details',
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: h * 0.015,
                                                    horizontal: w * 0.035),
                                                decoration: BoxDecoration(
                                                  color: containerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: CircleAvatar(
                                                          backgroundColor: controller
                                                                      .searchDevelopmentActivityCommonData[
                                                                          index]
                                                                      .color ==
                                                                  'red'
                                                              ? redColor
                                                              : controller
                                                                          .searchDevelopmentActivityCommonData[
                                                                              index]
                                                                          .color ==
                                                                      'green'
                                                                  ? greenColor
                                                                  : orangeColor,
                                                          radius: 12,
                                                        ),
                                                      ),
                                                      (w * 0.03).addWSpace(),
                                                      Expanded(
                                                        flex: 20,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: w * 0.68,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Flexible(
                                                                        child: "${controller.searchDevelopmentActivityCommonData[index].name}".toString().boldRobotoTextStyle(
                                                                            maxLine:
                                                                                2,
                                                                            textOverflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize: 15),
                                                                      ),
                                                                      controller.searchDevelopmentActivityCommonData[index].activityTypeStatus ==
                                                                              true
                                                                          ? Row(
                                                                              children: [
                                                                                const SizedBox(width: 5),
                                                                                Icon(Icons.done_all, color: greenColor)
                                                                              ],
                                                                            )
                                                                          : const SizedBox()
                                                                    ],
                                                                  ),
                                                                  (h * 0.005)
                                                                      .addHSpace(),
                                                                  controller
                                                                      .developmentActivityCommonData[
                                                                          index]
                                                                      .desc!
                                                                      .toString()
                                                                      .regularBarlowTextStyle(
                                                                          maxLine:
                                                                              3,
                                                                          textOverflow: TextOverflow
                                                                              .ellipsis,
                                                                          fontSize:
                                                                              11),
                                                                ],
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            SizedBox(
                                                              width: w * 0.075,
                                                              child:
                                                                  PopupMenuButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .more_vert_rounded),
                                                                itemBuilder:
                                                                    (context) {
                                                                  return [
                                                                    PopupMenuItem(
                                                                      onTap:
                                                                          () {
                                                                        Get.toNamed(
                                                                          Routes
                                                                              .viewPdf,
                                                                          arguments:
                                                                              "${controller.developmentActivityCommonData[index].name}".toString(),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.download,
                                                                              color: appColor),
                                                                          (w * 0.02)
                                                                              .addWSpace(),
                                                                          AppString
                                                                              .downloadPdf
                                                                              .regularRobotoTextStyle(fontSize: 16),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      onTap:
                                                                          () async {
                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                300));

                                                                        await controller
                                                                            .getReplicateActivityForCommonAndDevelopmentController(
                                                                          activityId:
                                                                              "${controller.developmentActivityCommonData[index].activityId}",
                                                                          type:
                                                                              "development",
                                                                        );

                                                                        await controller
                                                                            .fetchDevelopmentActivityChecklist();
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.copy,
                                                                              color: appColor),
                                                                          (w * 0.02)
                                                                              .addWSpace(),
                                                                          AppString
                                                                              .replicateAct
                                                                              .regularRobotoTextStyle(fontSize: 16),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    if (preferences
                                                                            .getBool(SharedPreference.del_activity_users) ==
                                                                        true)
                                                                      PopupMenuItem(
                                                                        onTap:
                                                                            () async {
                                                                          await Future.delayed(
                                                                              const Duration(milliseconds: 300));
                                                                          await controller
                                                                              .deleteActivityForCandDController(
                                                                            body: {
                                                                              "activity_id": "${controller.developmentActivityCommonData[index].activityId}".toString()
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.delete,
                                                                                color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.deleteActivity.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    PopupMenuItem(
                                                                      onTap:
                                                                          () {
                                                                        Future.delayed(const Duration(milliseconds: 200))
                                                                            .then(
                                                                          (value) async {
                                                                            await controller.storeForOfflineUseCommonAndDevelopment(
                                                                              w: w,
                                                                              context: context,
                                                                              h: h,
                                                                              index: index,
                                                                              activityType: 'tower',
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.save,
                                                                              color: appColor),
                                                                          (w * 0.02)
                                                                              .addWSpace(),
                                                                          AppString
                                                                              .saveAsOffline
                                                                              .regularRobotoTextStyle(fontSize: 16),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.cancel_outlined,
                                                                              color: redColor),
                                                                          (w * 0.02)
                                                                              .addWSpace(),
                                                                          AppString
                                                                              .close
                                                                              .regularRobotoTextStyle(fontSize: 16),
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
                                                padding: EdgeInsets.only(
                                                    top: h * 0.008,
                                                    bottom: h * 0.017,
                                                    left: w * 0.42),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      AppString.lastUpdateTime
                                                          .semiBoldBarlowTextStyle(
                                                              fontSize: 11),
                                                      (w * 0.01).addWSpace(),
                                                      DateFormat(
                                                              'dd/MM/yyyy hh:mm')
                                                          .format(
                                                            DateTime.parse(
                                                              controller
                                                                  .developmentActivityResponse!
                                                                  .developmentactivityData!
                                                                  .developmentActivityCommonData![
                                                                      index]
                                                                  .writeDate!,
                                                            ),
                                                          )
                                                          .regularRobotoTextStyle(
                                                              fontSize: 11),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ])));
                              },
                            ),
                          ]
                        ],
                        if (controller.select == 2 &&
                            controller.searchActivityCommonData.isEmpty)
                          SizedBox(
                            height: h * 0.4,
                            child: const Center(
                              child: Text('No checklist data available!'),
                            ),
                          )
                        else if (controller.select == 2) ...[
                          GridView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: Responsive.isDesktop(context)
                                    ? h * 0.03
                                    : h * 0.017),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: Responsive.isTablet(context)
                                  ? w * 0.00322
                                  : w * 0.01200,
                              crossAxisSpacing: 0.02,
                              mainAxisSpacing: h * 0.04,
                            ),
                            shrinkWrap: true,
                            itemCount:
                                controller.searchActivityCommonData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    final data = ActivityTypeItem(
                                      activityId: controller
                                          .searchActivityCommonData[index]
                                          .activityId,
                                      name: controller
                                          .searchActivityCommonData[index].name,
                                      desc: controller
                                          .searchActivityCommonData[index].desc,
                                      activityTypeStatus: controller
                                          .searchActivityCommonData[index]
                                          .activityTypeStatus,
                                      color: controller
                                          .searchActivityCommonData[index]
                                          .color,
                                    );
                                    await Get.toNamed(
                                      Routes.activityDetailsScreen,
                                      arguments: {
                                        "activityId": data.activityId,
                                        "model": ConstDataModel(
                                          data: data,
                                          screen: 'tower_details',
                                        ),
                                      },
                                    );
                                  },
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 0.015,
                                          horizontal: w * 0.035),
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: CircleAvatar(
                                                backgroundColor: controller
                                                            .searchActivityCommonData[
                                                                index]
                                                            .color ==
                                                        'red'
                                                    ? redColor
                                                    : controller
                                                                .searchActivityCommonData[
                                                                    index]
                                                                .color ==
                                                            'green'
                                                        ? greenColor
                                                        : orangeColor,
                                                radius: 12,
                                              ),
                                            ),
                                            (w * 0.03).addWSpace(),
                                            Expanded(
                                              flex: 20,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: w * 0.68,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: "${controller.searchActivityCommonData[index].name}"
                                                                  .toString()
                                                                  .boldRobotoTextStyle(
                                                                      maxLine:
                                                                          2,
                                                                      textOverflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            controller
                                                                        .searchActivityCommonData[
                                                                            index]
                                                                        .activityTypeStatus ==
                                                                    true
                                                                ? Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Icon(
                                                                          Icons
                                                                              .done_all,
                                                                          color:
                                                                              greenColor)
                                                                    ],
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                        (h * 0.005).addHSpace(),
                                                        controller
                                                            .activityCommonData[
                                                                index]
                                                            .desc!
                                                            .toString()
                                                            .regularBarlowTextStyle(
                                                                maxLine: 3,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: 11),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  SizedBox(
                                                    width: w * 0.075,
                                                    child: PopupMenuButton(
                                                      icon: const Icon(Icons
                                                          .more_vert_rounded),
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem(
                                                            onTap: () {
                                                              Get.toNamed(
                                                                Routes.viewPdf,
                                                                arguments:
                                                                    "${controller.activityCommonData[index].name}"
                                                                        .toString(),
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .download,
                                                                    color:
                                                                        appColor),
                                                                (w * 0.02)
                                                                    .addWSpace(),
                                                                AppString
                                                                    .downloadPdf
                                                                    .regularRobotoTextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            onTap: () async {
                                                              await Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300));

                                                              await controller
                                                                  .getReplicateActivityForCommonAndDevelopmentController(
                                                                activityId:
                                                                    "${controller.activityCommonData[index].activityId}",
                                                                type: "common",
                                                              );

                                                              await controller
                                                                  .fetchCommonActivityChecklist();
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.copy,
                                                                    color:
                                                                        appColor),
                                                                (w * 0.02)
                                                                    .addWSpace(),
                                                                AppString
                                                                    .replicateAct
                                                                    .regularRobotoTextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ],
                                                            ),
                                                          ),
                                                          if (preferences.getBool(
                                                                  SharedPreference
                                                                      .del_activity_users) ==
                                                              true)
                                                            PopupMenuItem(
                                                              onTap: () async {
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300));
                                                                await controller
                                                                    .deleteActivityForCandDController(
                                                                  body: {
                                                                    "activity_id":
                                                                        "${controller.activityCommonData[index].activityId}"
                                                                            .toString()
                                                                  },
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color:
                                                                          appColor),
                                                                  (w * 0.02)
                                                                      .addWSpace(),
                                                                  AppString
                                                                      .deleteActivity
                                                                      .regularRobotoTextStyle(
                                                                          fontSize:
                                                                              16),
                                                                ],
                                                              ),
                                                            ),
                                                          PopupMenuItem(
                                                            onTap: () {
                                                              Future.delayed(const Duration(
                                                                      milliseconds:
                                                                          200))
                                                                  .then(
                                                                (value) async {
                                                                  await controller
                                                                      .storeForOfflineUseCommonAndDevelopment(
                                                                    w: w,
                                                                    context:
                                                                        context,
                                                                    h: h,
                                                                    index:
                                                                        index,
                                                                    activityType:
                                                                        'tower',
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.save,
                                                                    color:
                                                                        appColor),
                                                                (w * 0.02)
                                                                    .addWSpace(),
                                                                AppString
                                                                    .saveAsOffline
                                                                    .regularRobotoTextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .cancel_outlined,
                                                                    color:
                                                                        redColor),
                                                                (w * 0.02)
                                                                    .addWSpace(),
                                                                AppString.close
                                                                    .regularRobotoTextStyle(
                                                                        fontSize:
                                                                            16),
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
                                      padding: EdgeInsets.only(
                                          top: h * 0.008,
                                          bottom: h * 0.017,
                                          left: w * 0.42),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AppString.lastUpdateTime
                                                .semiBoldBarlowTextStyle(
                                                    fontSize: 11),
                                            (w * 0.01).addWSpace(),
                                            DateFormat('dd/MM/yyyy hh:mm')
                                                .format(
                                                  controller
                                                      .commonActivityResponse!
                                                      .activityData!
                                                      .activityCommonData![
                                                          index]
                                                      .writeDate!,
                                                )
                                                .regularRobotoTextStyle(
                                                    fontSize: 11),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]));
                            },
                          ),
                        ] else
                          GridView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: Responsive.isDesktop(context)
                                    ? h * 0.03
                                    : h * 0.017),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: Responsive.isTablet(context)
                                  ? w * 0.00322
                                  : w * 0.00512,
                              crossAxisSpacing: w * 0.045,
                              mainAxisSpacing: h * 0.02,
                            ),
                            shrinkWrap: true,
                            itemCount: controller.select == 0
                                ? controller.flatLength
                                : controller.floorLength,
                            itemBuilder: (context, index) {
                              ListFloor responseData = controller.select == 0
                                  ? controller.searchListFlatData[index]
                                  : controller.searchListFloorData[index];

                              double per =
                                  double.parse(responseData.progress ?? "0.00");

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
                                  final data = TowerIdDataModal(
                                      id: responseData.floorId.toString(),
                                      towerName: controller
                                          .flatFloorRes!.towerData!.towerName);

                                  if (isCubeTesting) {
                                    Get.to(
                                      () => CubeRecordsScreen(
                                        floorId: responseData.floorId ?? 0,
                                      ),
                                      arguments: {
                                        "floorId": responseData.floorId,
                                        "towerId": controller
                                            .flatFloorRes?.towerData?.towerId,
                                        "towerName": controller
                                            .flatFloorRes?.towerData?.towerName,
                                        "floorName": responseData.name,
                                      },
                                    );
                                  } else {
                                    Get.toNamed(
                                        controller.select == 0
                                            ? Routes.flatActivityScreen
                                            : Routes.floorActivityScreen,
                                        arguments: {
                                          "model": data,
                                          "count": count,
                                          "progress":
                                              responseData.progress ?? "0.00",
                                          "tower_data":
                                              controller.flatFloorRes?.towerData,
                                          "flat_floor_data":
                                              controller.select == 0
                                                  ? controller
                                                      .flatFloorRes
                                                      ?.towerData
                                                      ?.listFlatData![index]
                                                  : controller
                                                      .flatFloorRes
                                                      ?.towerData
                                                      ?.listFloorData![index],
                                        });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffE6E6E6),
                                    ),
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (h * 0.015).addHSpace(),
                                          const Spacer(),
                                          '${responseData.name}'
                                              .toString()
                                              .boldRobotoTextStyle(
                                                  fontSize: 14),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                    horizontal: h * 0.012)
                                                .copyWith(bottom: h * 0.015),
                                            child: StepProgressIndicator(
                                              totalSteps: 5,
                                              roundedEdges:
                                                  const Radius.circular(10),
                                              currentStep: count,
                                              unselectedSize: h * 0.007,
                                              size: h * 0.007,
                                              selectedColor: greenColor,
                                              unselectedColor: lightGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // if (preferences.getString(
                                      //             SharedPreference.userType) ==
                                      //         "hqi_maker" &&
                                      //     controller.select == 0)


if ((preferences.getString(SharedPreference.userType)?.contains("hqi_maker") == true ) &&
// ||
    // preferences.getString(SharedPreference.userType)?.contains("maker") == true) &&
    controller.select == 0)
                                        Positioned(
                                          top: h * 0.01,
                                          right: h * 0.01,
                                          child: PopupMenuButton<int>(
                                            icon: const Icon(Icons.more_vert,
                                                size: 20),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 0,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.send,
                                                        color: greenColor,
                                                        size: 20),
                                                    SizedBox(width: 8),
                                                    Text("Call for HQI"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) async {
                                              if (value == 0) {
                                                int flatId =
                                                    responseData.floorId ?? 0;

                                                if (flatId == 0) {
                                                  errorSnackBar("Error",
                                                      "Invalid flat ID");
                                                  return;
                                                }

                                                HQITowerController
                                                    hqitowerController =
                                                    Get.put(
                                                        HQITowerController());
                                                await hqitowerController
                                                    .submitFlatForHQI(
                                                        flatId: flatId);

                                                if (hqitowerController
                                                        .submitFlatResponse
                                                        .status ==
                                                    Status.COMPLETE) {
                                                  successSnackBar("Success",
                                                      "Flat submitted for HQI");
                                                } else if (hqitowerController
                                                        .submitFlatResponse
                                                        .status ==
                                                    Status.ERROR) {
                                                  errorSnackBar("Error",
                                                      "Already Submitted");
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        (controller.flatLength ==
                                        controller.searchListFlatData.length &&
                                    controller.select == 0) ||
                                (controller.floorLength ==
                                        controller.searchListFloorData.length &&
                                    controller.select == 1) ||
                                (controller.commonLength ==
                                        controller
                                            .searchActivityCommonData.length &&
                                    controller.select == 2) ||
                                (controller.developmentLength ==
                                        controller
                                            .searchDevelopmentActivityCommonData
                                            .length &&
                                    controller.select == 3)
                            ? const SizedBox()
                            : Center(
                                child: controller.load
                                    ? showCircular()
                                    : TextButton(
                                        onPressed: () {
                                          if (controller.select == 0) {
                                            controller.setFlatLength(false);
                                          } else if (controller.select == 1) {
                                            controller.setFloorLength(false);
                                          } else if (controller.select == 2) {
                                            controller.setCommonLength(false);
                                          } else if (controller.select == 3) {
                                            controller
                                                .setDevelopmentLength(false);
                                          }
                                        },
                                        child: "Load more"
                                            .semiBoldBarlowTextStyle(
                                                fontColor: appColor),
                                      ),
                              ),
                      ],
                    ),
                  ),
                );
              } else if (controller.getFlatFlorApiResponse.status ==
                  Status.ERROR) {
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
