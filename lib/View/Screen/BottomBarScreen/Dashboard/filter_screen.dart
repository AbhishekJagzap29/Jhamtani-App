import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_activity_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_activity_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_flat_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_floor_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_project_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/nc_tower_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  NcController ncController = Get.find();

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
            child: GetBuilder<NcController>(
              builder: (controller) {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (h * 0.02).addHSpace(),

                          /// TOWER
                          AppString.selectTower
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.towerList.isEmpty) {
                                errorSnackBar("No tower available",
                                    "No tower data for ${controller.projectName} project!");
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
                                        controller.selectedTower?.towerName ??
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
                                    items: controller.towerList
                                        .map((NCTowerDataList items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: "${items.towerName}"
                                            .regularBarlowTextStyle(
                                                maxLine: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 16),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller
                                          .selectTower(newValue?.towerId ?? 0);
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),

                          /// FLAT FLOOR

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.selectFlatFloor(0);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.23,
                                  decoration: BoxDecoration(
                                    color: controller.select == 0
                                        ?const Color(0xFF3498DB)

                                        : containerColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppString.flat.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor: controller.select == 0
                                            ? backGroundColor
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selectFlatFloor(1);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.23,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: controller.select == 1
                                        ? const Color(0xFF3498DB)
                                        : containerColor,
                                  ),
                                  child: Center(
                                    child: AppString.floor.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor: controller.select == 1
                                            ? backGroundColor
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          (h * 0.02).addHSpace(),

                          /// FLOOR FLAT

                          (controller.select == 0
                                  ? AppString.selectFlat
                                  : AppString.selectFloor)
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.selectedTower == null) {
                                errorSnackBar(
                                    "Required", "Please select tower first!");
                              } else if (controller.select == 0 &&
                                  controller.flatList.isEmpty) {
                                errorSnackBar("No flats available",
                                    "No flats for ${controller.selectedTower?.towerName} tower!");
                              } else if (controller.select == 1 &&
                                  controller.floorList.isEmpty) {
                                errorSnackBar("No floors available",
                                    "No floors for ${controller.selectedTower?.towerName} tower!");
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
                                        controller.select == 0
                                            ? controller.selectedFlatData
                                                    ?.flatName ??
                                                "Select Flat"
                                            : controller.selectedFloorData
                                                    ?.floorName ??
                                                "Select Floor",
                                        style: (controller.select == 0
                                                ? controller.selectedFlatData !=
                                                    null
                                                : controller
                                                        .selectedFloorData !=
                                                    null)
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
                                    items: controller.select == 0
                                        ? controller.flatList
                                            .map((NcFlatData items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.flatName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList()
                                        : controller.floorList
                                            .map((NcFloorData items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.floorName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      if (controller.select == 0) {
                                        NcFlatData data =
                                            newValue as NcFlatData;
                                        controller.selectFlat(data.flatId ?? 0);
                                      } else {
                                        NcFloorData data =
                                            newValue as NcFloorData;
                                        controller
                                            .selectFloor(data.floorId ?? 0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),

                          /// ACTIVITY

                          AppString.selectActivity
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.select == 0 &&
                                      controller.selectedFlatData == null ||
                                  controller.select == 1 &&
                                      controller.selectedFloorData == null) {
                                errorSnackBar("Required",
                                    "Please select ${controller.select == 0 ? "flat" : "floor"} first!");
                              } else if (controller.select == 0 &&
                                  controller.flatActivityList.isEmpty) {
                                errorSnackBar("No activity available",
                                    "No activity for ${controller.selectedFlatData?.flatName} flat!");
                              } else if (controller.select == 1 &&
                                  controller.floorActivityList.isEmpty) {
                                errorSnackBar("No activity available",
                                    "No activity for ${controller.selectedFloorData?.floorName} floor!");
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
                                      controller.select == 0
                                          ? controller.selectedFlatActivity
                                                  ?.activityName ??
                                              "Select Activity"
                                          : controller.selectedFloorActivity
                                                  ?.activityName ??
                                              "Select Activity",
                                      style: (controller.select == 0
                                              ? controller
                                                      .selectedFlatActivity !=
                                                  null
                                              : controller
                                                      .selectedFloorActivity !=
                                                  null)
                                          ? textFieldTextStyle
                                          : textFieldHintTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.select == 0
                                        ? controller.flatActivityList
                                            .map((FlatActivityNcData items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.activityName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList()
                                        : controller.floorActivityList
                                            .map((FloorActivityNcData items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.activityName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      if (controller.select == 0) {
                                        FlatActivityNcData data =
                                            newValue as FlatActivityNcData;
                                        controller.selectFlatActivity(
                                            data.activityId ?? 0);
                                      } else {
                                        FloorActivityNcData data =
                                            newValue as FloorActivityNcData;
                                        controller.selectFloorActivity(
                                            data.activityId ?? 0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),

                          /// ACTIVITY TYPE

                          AppString.selectActivityType
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.select == 0 &&
                                      controller.selectedFlatActivity == null ||
                                  controller.select == 1 &&
                                      controller.selectedFloorActivity ==
                                          null) {
                                errorSnackBar("Required",
                                    "Please select activity first!");
                              } else if (controller.select == 0 &&
                                  controller.flatActivityTypeList.isEmpty) {
                                errorSnackBar("No activity types available",
                                    "No activity types for ${controller.selectedFlatActivity?.activityName} activity!");
                              } else if (controller.select == 1 &&
                                  controller.flatActivityTypeList.isEmpty) {
                                errorSnackBar("No activity types available",
                                    "No activity types for ${controller.selectedFloorActivity?.activityName} activity!");
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
                                      controller.select == 0
                                          ? controller.selectedFlatActivityType
                                                  ?.activityTypeName ??
                                              "Select Activity Type"
                                          : controller.selectedFloorActivityType
                                                  ?.activityTypeName ??
                                              "Select Activity Type",
                                      style: (controller.select == 0
                                              ? controller
                                                      .selectedFlatActivityType !=
                                                  null
                                              : controller
                                                      .selectedFloorActivityType !=
                                                  null)
                                          ? textFieldTextStyle
                                          : textFieldHintTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.select == 0
                                        ? controller.flatActivityTypeList
                                            .map((NcActivityTypeList items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.activityTypeName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList()
                                        : controller.floorActivityTypeList
                                            .map((NcActivityTypeList items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.activityTypeName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      if (controller.select == 0) {
                                        NcActivityTypeList data =
                                            newValue as NcActivityTypeList;
                                        controller.selectFlatActivityType(
                                            data.activityTypeId ?? 0);
                                      } else {
                                        NcActivityTypeList data =
                                            newValue as NcActivityTypeList;
                                        controller.selectFloorActivityType(
                                            data.activityTypeId ?? 0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),

                          /// CHECKLIST

                          AppString.selectChecklist
                              .regularRobotoTextStyle(fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              if (controller.select == 0 &&
                                      controller.selectedFlatActivityType ==
                                          null ||
                                  controller.select == 1 &&
                                      controller.selectedFloorActivityType ==
                                          null) {
                                errorSnackBar("Required",
                                    "Please select activity type first!");
                              } else if (controller.select == 0 &&
                                  controller.flatChecklistList.isEmpty) {
                                errorSnackBar("No checklist available",
                                    "No checklist for ${controller.selectedFlatActivityType?.activityTypeName} activity type!");
                              } else if (controller.select == 1 &&
                                  controller.floorChecklistList.isEmpty) {
                                errorSnackBar("No checklist available",
                                    "No checklist for ${controller.selectedFloorActivityType?.activityTypeName} activity type!");
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
                                      controller.select == 0
                                          ? controller.selectedFlatChecklist
                                                  ?.checklistName ??
                                              "Select Checklist"
                                          : controller.selectedFloorChecklist
                                                  ?.checklistName ??
                                              "Select Checklist",
                                      style: (controller.select == 0
                                              ? controller
                                                      .selectedFlatChecklist !=
                                                  null
                                              : controller
                                                      .selectedFloorChecklist !=
                                                  null)
                                          ? textFieldTextStyle
                                          : textFieldHintTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: blackColor,
                                      size: Responsive.isTablet(context)
                                          ? h * 0.031
                                          : h * 0.025,
                                    ),
                                    items: controller.select == 0
                                        ? controller.flatChecklistList
                                            .map((NcChecklist items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.checklistName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList()
                                        : controller.floorChecklistList
                                            .map((NcChecklist items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: "${items.checklistName}"
                                                  .regularBarlowTextStyle(
                                                      maxLine: 2,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      if (controller.select == 0) {
                                        NcChecklist data =
                                            newValue as NcChecklist;
                                        controller.selectFlatChecklist(
                                            data.checklistId ?? 0);
                                      } else {
                                        NcChecklist data =
                                            newValue as NcChecklist;
                                        controller.selectFloorChecklist(
                                            data.checklistId ?? 0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ).paddingOnly(bottom: h * 0.02),
                          ),
                          (h * 0.032).addHSpace(),
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
                                  onPressed: () async {
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
                    controller.getTowerNCApiResponse.status == Status.LOADING ||
                            controller.getFlatNcApiResponse.status ==
                                Status.LOADING ||
                            controller.getFloorNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFloorAcNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFloorAcTypeNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFloorChecklistNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFlatAcNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFlatAcTypeNCApiResponse.status ==
                                Status.LOADING ||
                            controller.getFlatChecklistNcApiResponse.status ==
                                Status.LOADING
                        ? Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: showCircular(),
                          )
                        : const SizedBox()
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
