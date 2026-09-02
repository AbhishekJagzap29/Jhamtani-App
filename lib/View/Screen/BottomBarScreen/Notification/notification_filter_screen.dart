import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class NotificationFilterScreen extends StatefulWidget {
  const NotificationFilterScreen({super.key});

  @override
  State<NotificationFilterScreen> createState() =>
      _NotificationFilterScreenState();
}

class _NotificationFilterScreenState extends State<NotificationFilterScreen> {
  NotificationController notificationController = Get.find();
  @override
  void initState() {
    super.initState();
    notificationController.getProjectData();
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
          title: AppString.filter.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
        ),
        body: SafeArea(
          child: SizedBox(
            width: w,
            child: GetBuilder<NotificationController>(
              builder: (controller) {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (h * 0.03).addHSpace(),
                          /// Work - Material Inspection
                          (AppString.selectInspection)
                              .regularRobotoTextStyle(fontSize: 16),
                          (h * 0.01).addHSpace(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.selectInspections(0);
                                  controller.selectedProject = null;
                                  controller.selectedTower = null;
                                  controller.towerList = [];
                                  controller.selectedCheckListStatus = '';
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.43,
                                  decoration: BoxDecoration(
                                    color: controller.selectInspection == 0
                                        ?  const Color(0xFF3498DB)
                                        : containerColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppString.work.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor:
                                            controller.selectInspection == 0
                                                ? backGroundColor
                                                : Colors.black),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selectInspections(1);
                                  controller.selectedProject = null;
                                  controller.selectedTower = null;
                                  controller.towerList = [];
                                  controller.selectedCheckListStatus = '';
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.43,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: controller.selectInspection == 1
                                        ?  const Color(0xFF3498DB)

                                        : containerColor,
                                  ),
                                  child: Center(
                                    child: AppString.material
                                        .boldRobotoTextStyle(
                                            fontSize: 16,
                                            fontColor:
                                                controller.selectInspection == 1
                                                    ? backGroundColor
                                                    : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          (h * 0.05).addHSpace(),
                          /// Project select
                          AppString.selectProject
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.projectList.isEmpty) {
                                errorSnackBar("No Project available",
                                    "No project data found!");
                              }
                            },
                            child: InnerShadowContainer(
                              radius: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.isDesktop(context)
                                        ? w * 0.0155
                                        : Responsive.isTablet(context)
                                            ? w * 0.035
                                            : w * 0.047),
                                child: Center(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                        controller.selectedProject?.name ??
                                            "Select Project",
                                        style:
                                            controller.selectedProject != null
                                                ? textFieldTextStyle
                                                : textFieldHintTextStyle),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.projectList.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: "${items.name}"
                                            .regularBarlowTextStyle(
                                                maxLine: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 16),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.selectProject(
                                          newValue?.projectId ?? 0);

                                      /// get/project_info
                                      /// checklist/tower
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),
                          (h * 0.03).addHSpace(),

                          /// TOWER
                          AppString.selectTower
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.selectedProject != null) {
                                if (controller.towerList.isEmpty) {
                                  errorSnackBar("No tower available",
                                      "No tower data for ${controller.selectedProject?.name ?? ''} project!");
                                }
                              } else {
                                errorSnackBar(
                                    "Required", 'Please Select Project first');
                              }
                            },
                            child: InnerShadowContainer(
                              radius: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.isDesktop(context)
                                        ? w * 0.0155
                                        : Responsive.isTablet(context)
                                            ? w * 0.035
                                            : w * 0.047),
                                child: Center(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                        controller.selectedTower?.name ??
                                            "Select Tower",
                                        style: controller.selectedTower != null
                                            ? textFieldTextStyle
                                            : textFieldHintTextStyle),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.towerList.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: "${items.name}"
                                            .regularBarlowTextStyle(
                                                maxLine: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 16),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      if (controller.selectedProject == null) {
                                        errorSnackBar("Required",
                                            'Please Select Project first');
                                      } else {
                                        controller.selectTower(
                                            newValue?.towerId ?? 0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),
                          (h * 0.03).addHSpace(),

                          /// Pending - Completed Status
                          (AppString.selectStatus)
                              .regularRobotoTextStyle(fontSize: 16),
                          (h * 0.01).addHSpace(),

                          GestureDetector(
                            onTap: () {
                              if (controller.checklistStatusList1.isEmpty) {
                                errorSnackBar("No status available",
                                    "No status data found!");
                              }
                            },
                            child: InnerShadowContainer(
                              radius: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.isDesktop(context)
                                        ? w * 0.0155
                                        : Responsive.isTablet(context)
                                            ? w * 0.035
                                            : w * 0.047),
                                child: Center(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                        controller.selectedCheckListStatus != ''
                                            ? controller.selectedCheckListStatus
                                            : "Select CheckList Status",
                                        style: controller
                                                    .selectedCheckListStatus !=
                                                ''
                                            ? textFieldTextStyle
                                            : textFieldHintTextStyle),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.checklistStatusList1
                                        .map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: "$items".regularBarlowTextStyle(
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontSize: 16),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller
                                          .selectCheckListStatus("$value");
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),

                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () async {
                                    controller.clearFilter();
                                    Get.back();
                                  },
                                  color: Colors.black,
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.078
                                      : h * 0.058,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppString.clear.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor: backGroundColor),
                                  ),
                                ),
                              ),
                              (w * 0.021).addWSpace(),
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    controller.applyFilter();
                                  },
                                  color: appColor,
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.078
                                      : h * 0.058,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppString.apply.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor: backGroundColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                          (h * 0.032).addHSpace(),
                        ],
                      ),
                    ),   
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

























































// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
// import 'package:jhamtani_app/View/Constant/app_color.dart';
// import 'package:jhamtani_app/View/Constant/app_string.dart';
// import 'package:jhamtani_app/View/Constant/responsive.dart';
// import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';
// import 'package:jhamtani_app/View/Widgets/app_bar.dart';
// import 'package:jhamtani_app/View/Widgets/text_field.dart';
// import 'package:jhamtani_app/View/utils/extension.dart';

// class NotificationFilterScreen extends StatefulWidget {
//   const NotificationFilterScreen({super.key});

//   @override
//   State<NotificationFilterScreen> createState() =>
//       _NotificationFilterScreenState();
// }

// class _NotificationFilterScreenState extends State<NotificationFilterScreen> {
//   NotificationController notificationController = Get.find();
//   @override
//   void initState() {
//     super.initState();
//     notificationController.getProjectData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         backgroundColor: backGroundColor,
//         appBar: AppBarWidget(
//           title: AppString.filter.boldRobotoTextStyle(fontSize: 20),
//         ),
//         body: SafeArea(
//           child: SizedBox(
//             width: w,
//             child: GetBuilder<NotificationController>(
//               builder: (controller) {
//                 return Stack(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           (h * 0.03).addHSpace(),

//                           /// Work - Material Inspection
//                           (AppString.selectInspection)
//                               .regularRobotoTextStyle(fontSize: 16),
//                           (h * 0.01).addHSpace(),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               for (int i = 0;
//                                   i < controller.inspectionTypes.length;
//                                   i++)
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.selectInspections(i);
//                                     controller.selectedProject = null;
//                                     controller.selectedTower = null;
//                                     controller.towerList = [];
//                                     controller.selectedCheckListStatus = '';
//                                   },
//                                   child: Container(
//                                     height: Responsive.isDesktop(context)
//                                         ? h * 0.068
//                                         : h * 0.048,
//                                     width: w * 0.29,
//                                     decoration: BoxDecoration(
//                                       color: controller.selectInspection == i
//                                           ? appColor
//                                           : containerColor,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft:
//                                             Radius.circular(i == 0 ? 10 : 0),
//                                         bottomLeft:
//                                             Radius.circular(i == 0 ? 10 : 0),
//                                         topRight: Radius.circular(i ==
//                                                 controller.inspectionTypes
//                                                         .length -
//                                                     1
//                                             ? 10
//                                             : 0),
//                                         bottomRight: Radius.circular(i ==
//                                                 controller.inspectionTypes
//                                                         .length -
//                                                     1
//                                             ? 10
//                                             : 0),
//                                       ),
//                                     ),
//                                     child: Center(
//                                       child: (i == 0
//                                               ? AppString.work
//                                               : i == 1
//                                                   ? AppString.material
//                                                   : "HQI")
//                                           .boldRobotoTextStyle(
//                                         fontSize: 16,
//                                         fontColor:
//                                             controller.selectInspection == i
//                                                 ? backGroundColor
//                                                 : Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),

//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.center,
//                           //   children: [
//                           //     GestureDetector(
//                           //       onTap: () {
//                           //         controller.selectInspections(0);
//                           //         controller.selectedProject = null;
//                           //         controller.selectedTower = null;
//                           //         controller.towerList = [];
//                           //         controller.selectedCheckListStatus = '';
//                           //       },
//                           //       child: Container(
//                           //         height: Responsive.isDesktop(context)
//                           //             ? h * 0.068
//                           //             : h * 0.048,
//                           //         width: w * 0.43,
//                           //         decoration: BoxDecoration(
//                           //           color: controller.selectInspection == 0
//                           //               ? appColor
//                           //               : containerColor,
//                           //           borderRadius: const BorderRadius.only(
//                           //             topLeft: Radius.circular(10),
//                           //             bottomLeft: Radius.circular(10),
//                           //           ),
//                           //         ),
//                           //         child: Center(
//                           //           child: AppString.work.boldRobotoTextStyle(
//                           //               fontSize: 16,
//                           //               fontColor:
//                           //                   controller.selectInspection == 0
//                           //                       ? backGroundColor
//                           //                       : Colors.black),
//                           //         ),
//                           //       ),
//                           //     ),
//                           //     GestureDetector(
//                           //       onTap: () {
//                           //         controller.selectInspections(1);
//                           //         controller.selectedProject = null;
//                           //         controller.selectedTower = null;
//                           //         controller.towerList = [];
//                           //         controller.selectedCheckListStatus = '';
//                           //       },
//                           //       child: Container(
//                           //         height: Responsive.isDesktop(context)
//                           //             ? h * 0.068
//                           //             : h * 0.048,
//                           //         width: w * 0.43,
//                           //         decoration: BoxDecoration(
//                           //           borderRadius: const BorderRadius.only(
//                           //             topRight: Radius.circular(10),
//                           //             bottomRight: Radius.circular(10),
//                           //           ),
//                           //           color: controller.selectInspection == 1
//                           //               ? appColor
//                           //               : containerColor,
//                           //         ),
//                           //         child: Center(
//                           //           child: AppString.material
//                           //               .boldRobotoTextStyle(
//                           //                   fontSize: 16,
//                           //                   fontColor:
//                           //                       controller.selectInspection == 1
//                           //                           ? backGroundColor
//                           //                           : Colors.black),
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           (h * 0.05).addHSpace(),

//                           /// Project select
//                           AppString.selectProject
//                               .regularRobotoTextStyle(fontSize: 16),
//                           GestureDetector(
//                             onTap: () {
//                               if (controller.projectList.isEmpty) {
//                                 errorSnackBar("No Project available",
//                                     "No project data found!");
//                               }
//                             },
//                             child: InnerShadowContainer(
//                               radius: 7,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Responsive.isDesktop(context)
//                                         ? w * 0.0155
//                                         : Responsive.isTablet(context)
//                                             ? w * 0.035
//                                             : w * 0.047),
//                                 child: Center(
//                                   child: DropdownButton(
//                                     isExpanded: true,
//                                     hint: Text(
//                                         controller.selectedProject?.name ??
//                                             "Select Project",
//                                         style:
//                                             controller.selectedProject != null
//                                                 ? textFieldTextStyle
//                                                 : textFieldHintTextStyle),
//                                     underline: const SizedBox(),
//                                     icon: Icon(
//                                       Icons.keyboard_arrow_down,
//                                       color: blackColor,
//                                       size: Responsive.isTablet(context)
//                                           ? h * 0.031
//                                           : h * 0.025,
//                                     ),
//                                     // items: controller.projectList.map((items) {
//                                     //   return DropdownMenuItem(
//                                     //     value: items,
//                                     //     child: "${items.name}"
//                                     //         .regularBarlowTextStyle(
//                                     //             maxLine: 2,
//                                     //             textOverflow:
//                                     //                 TextOverflow.ellipsis,
//                                     //             fontSize: 16),
//                                     //   );
//                                     // }).toList(),
//                                     items: controller.selectInspection == 2
//                                         ? controller.hqiTowersList.map((items) {
//                                             return DropdownMenuItem(
//                                               value: HQITower(
//                                                   id: items.id,
//                                                   name: items.name),
//                                               child: "${items.name}"
//                                                   .regularBarlowTextStyle(
//                                                       maxLine: 2,
//                                                       textOverflow:
//                                                           TextOverflow.ellipsis,
//                                                       fontSize: 16),
//                                             );
//                                           }).toList()
//                                         : controller.towerList.map((items) {
//                                             return DropdownMenuItem(
//                                               value: items,
//                                               child: "${items.name}"
//                                                   .regularBarlowTextStyle(
//                                                       maxLine: 2,
//                                                       textOverflow:
//                                                           TextOverflow.ellipsis,
//                                                       fontSize: 16),
//                                             );
//                                           }).toList(),

//                                     // onChanged: (newValue) {
//                                     //   controller.selectProject(
//                                     //       newValue?.projectId ?? 0);
//                                     onChanged: (newValue) {
//                                       if (controller.selectInspection == 2) {
//                                         // HQI tower selected (cast as HQITower)
//                                         final hqiTower = newValue as HQITower;
//                                         controller.selectTower(hqiTower.id);
//                                       } else {
//                                         // Work or Material tower selected (cast as TowerData)
//                                         final tower = newValue as TowerData;
//                                         controller
//                                             .selectTower(tower.towerId ?? 0);
//                                       }

//                                       /// get/project_info
//                                       /// checklist/tower
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ).paddingOnly(bottom: h * 0.02),
//                           ),
//                           (h * 0.03).addHSpace(),

//                           /// TOWER
//                           AppString.selectTower
//                               .regularRobotoTextStyle(fontSize: 16),
//                           GestureDetector(
//                             onTap: () {
//                               if (controller.selectedProject != null) {
//                                 if (controller.towerList.isEmpty) {
//                                   errorSnackBar("No tower available",
//                                       "No tower data for ${controller.selectedProject?.name ?? ''} project!");
//                                 }
//                               } else {
//                                 errorSnackBar(
//                                     "Required", 'Please Select Project first');
//                               }
//                             },
//                             child: InnerShadowContainer(
//                               radius: 7,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Responsive.isDesktop(context)
//                                         ? w * 0.0155
//                                         : Responsive.isTablet(context)
//                                             ? w * 0.035
//                                             : w * 0.047),
//                                 child: Center(
//                                   child: DropdownButton(
//                                     isExpanded: true,
//                                     hint: Text(
//                                         controller.selectedTower?.name ??
//                                             "Select Tower",
//                                         style: controller.selectedTower != null
//                                             ? textFieldTextStyle
//                                             : textFieldHintTextStyle),
//                                     underline: const SizedBox(),
//                                     icon: Icon(
//                                       Icons.keyboard_arrow_down,
//                                       color: blackColor,
//                                       size: Responsive.isTablet(context)
//                                           ? h * 0.031
//                                           : h * 0.025,
//                                     ),
//                                     items: controller.towerList.map((items) {
//                                       return DropdownMenuItem(
//                                         value: items,
//                                         child: "${items.name}"
//                                             .regularBarlowTextStyle(
//                                                 maxLine: 2,
//                                                 textOverflow:
//                                                     TextOverflow.ellipsis,
//                                                 fontSize: 16),
//                                       );
//                                     }).toList(),
//                                     onChanged: (newValue) {
//                                       if (controller.selectedProject == null) {
//                                         errorSnackBar("Required",
//                                             'Please Select Project first');
//                                       } else {
//                                         controller.selectTower(
//                                             newValue?.towerId ?? 0);
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ).paddingOnly(bottom: h * 0.02),
//                           ),
//                           (h * 0.03).addHSpace(),

//                           /// Pending - Completed Status
//                           (AppString.selectStatus)
//                               .regularRobotoTextStyle(fontSize: 16),
//                           (h * 0.01).addHSpace(),

//                           GestureDetector(
//                             onTap: () {
//                               if (controller.checklistStatusList1.isEmpty) {
//                                 errorSnackBar("No status available",
//                                     "No status data found!");
//                               }
//                             },
//                             child: InnerShadowContainer(
//                               radius: 7,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Responsive.isDesktop(context)
//                                         ? w * 0.0155
//                                         : Responsive.isTablet(context)
//                                             ? w * 0.035
//                                             : w * 0.047),
//                                 child: Center(
//                                   child: DropdownButton(
//                                     isExpanded: true,
//                                     hint: Text(
//                                         controller.selectedCheckListStatus != ''
//                                             ? controller.selectedCheckListStatus
//                                             : "Select CheckList Status",
//                                         style: controller
//                                                     .selectedCheckListStatus !=
//                                                 ''
//                                             ? textFieldTextStyle
//                                             : textFieldHintTextStyle),
//                                     underline: const SizedBox(),
//                                     icon: Icon(
//                                       Icons.keyboard_arrow_down,
//                                       color: blackColor,
//                                       size: Responsive.isTablet(context)
//                                           ? h * 0.031
//                                           : h * 0.025,
//                                     ),
//                                     items: controller.checklistStatusList1
//                                         .map((items) {
//                                       return DropdownMenuItem(
//                                         value: items,
//                                         child: "$items".regularBarlowTextStyle(
//                                             maxLine: 2,
//                                             textOverflow: TextOverflow.ellipsis,
//                                             fontSize: 16),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       controller
//                                           .selectCheckListStatus("$value");
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ).paddingOnly(bottom: h * 0.02),
//                           ),

//                           const Spacer(),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: MaterialButton(
//                                   onPressed: () async {
//                                     controller.clearFilter();
//                                     Get.back();
//                                   },
//                                   color: Colors.black,
//                                   height: Responsive.isDesktop(context)
//                                       ? h * 0.078
//                                       : h * 0.058,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Center(
//                                     child: AppString.clear.boldRobotoTextStyle(
//                                         fontSize: 16,
//                                         fontColor: backGroundColor),
//                                   ),
//                                 ),
//                               ),
//                               (w * 0.021).addWSpace(),
//                               Expanded(
//                                 child: MaterialButton(
//                                   onPressed: () {
//                                     controller.applyFilter();
//                                   },
//                                   color: appColor,
//                                   height: Responsive.isDesktop(context)
//                                       ? h * 0.078
//                                       : h * 0.058,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Center(
//                                     child: AppString.apply.boldRobotoTextStyle(
//                                         fontSize: 16,
//                                         fontColor: backGroundColor),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           (h * 0.032).addHSpace(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
