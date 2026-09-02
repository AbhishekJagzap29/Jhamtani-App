import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/edit_activity_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';


import 'package:image_gallery_saver/image_gallery_saver.dart';

class EditActivityScreen extends StatefulWidget {
  const EditActivityScreen({super.key});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  EditActivityController editActivityController =
      Get.put(EditActivityController());

  final isCommonOrDevelopmentTab =
      Get.arguments["isCommonOrDevelopmentTab"] ?? false;

  @override
  void initState() {
    if (editActivityController.screen == "activity") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        editActivityController.changeStatus();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: GetBuilder<EditActivityController>(
        builder: (controller) {
          if (controller.isNotification == true) {
            return showCircular();
          } else {
            double per = double.parse(
                controller.activityData?.activityTypeProgress ?? "0.00");
            return Scaffold(
              backgroundColor: backGroundColor,
              appBar: AppBarWidget(
                title: (controller.constData?.activityName?.isNotEmpty ?? false
                        ? controller.constData?.activityName
                        : controller.activityData?.activity_name)
                    .toString()
                    .boldRobotoTextStyle(fontSize: 20,fontColor: Colors.white),
                     backGroundColor: const Color(0xFF3498DB),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          (h * 0.03).addHSpace(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.06, vertical: w * 0.026),
                            decoration: BoxDecoration(
                                color: containerColor,
                                border:
                                    Border.all(color: const Color(0xffE6E6E6)),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: w * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (!isCommonOrDevelopmentTab &&
                                          controller.constData?.flatFloorName !=
                                              "false" &&
                                          controller.constData?.flatFloorName
                                                  ?.isNotEmpty ==
                                              true)
                                        (controller.constData?.flatFloorName ??
                                                "")
                                            .toString()
                                            .boldRobotoTextStyle(fontSize: 25),
                                      (h * 0.005).addHSpace(),
                                      (controller.constData?.towerName
                                                      ?.isNotEmpty ??
                                                  false
                                              ? controller
                                                      .constData?.towerName ??
                                                  ""
                                              : controller
                                                  .activityData?.towerName)
                                          .toString()
                                          .regularBarlowTextStyle(fontSize: 14),
                                      (h * 0.007).addHSpace(),
                                      "Activity : ${controller.constData?.activityName ?? controller.activityData?.activity_name.toString()}"
                                          .toString()
                                          .regularBarlowTextStyle(fontSize: 14),
                                      (h * 0.007).addHSpace(),
                                      "Sub Activity : ${(controller.activityData?.name)}"
                                          .toString()
                                          .regularBarlowTextStyle(fontSize: 14)
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (per == 100.0) == true
                                          ? "${per.toStringAsFixed(0)}%"
                                              .boldRobotoTextStyle(fontSize: 25)
                                          : "${per.toStringAsFixed(1)}%"
                                              .boldRobotoTextStyle(
                                                  fontSize: 25),
                                      5.0.addHSpace(),
                                      StepProgressIndicator(
                                        totalSteps: 5,
                                        roundedEdges: const Radius.circular(10),
                                        currentStep: per < 20
                                            ? 0
                                            : per < 40
                                                ? 1
                                                : per < 60
                                                    ? 2
                                                    : per < 80
                                                        ? 3
                                                        : per == 100
                                                            ? 5
                                                            : 4,
                                        unselectedSize: h * 0.007,
                                        size: h * 0.007,
                                        selectedColor: greenColor,
                                        unselectedColor: lightGreyColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ((controller.isNetwork.isNotEmpty &&
                                      controller.savedLineData.isNotEmpty)
                                  ? (controller.savedLineData.isNotEmpty)
                                  : (controller
                                          .activityData?.lineData?.isNotEmpty ??
                                      false))
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return 1.0
                                            .appDivider(color: Colors.grey);
                                      },
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 0.02),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          (controller.isNetwork.isNotEmpty &&
                                                  controller
                                                      .savedLineData.isNotEmpty)
                                              ? controller.savedLineData.length
                                              : controller.activityData
                                                      ?.lineData?.length ??
                                                  0,
                                      itemBuilder: (context, index) {
                                        final data = (controller
                                                    .isNetwork.isNotEmpty &&
                                                controller
                                                    .savedLineData.isNotEmpty)
                                            ? controller.savedLineData[index]
                                            : controller
                                                .activityData?.lineData?[index];

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: data?.value
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "no" ||
                                                    data!.imageList.isNotEmpty
                                                ? Colors.blueGrey.shade100
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: h * 0.01,
                                              horizontal: w * 0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.012),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(CupertinoIcons
                                                                .arrow_right_square_fill)
                                                            .paddingOnly(
                                                                top: h * 0.002),
                                                        (w * 0.01).addWSpace(),
                                                        Expanded(
                                                          child: "${data?.name}"
                                                              .capitalizeFirst
                                                              .toString()
                                                              .regularBarlowTextStyle(
                                                                  fontSize: 16,
                                                                  maxLine: 10,
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                    (w * 0.02).addWSpace(),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  w * 0.05),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: w * 0.08,
                                                                child: Radio(
                                                                  activeColor:
                                                                      appColor,
                                                                  value: "yes",
                                                                  groupValue: data
                                                                      ?.value
                                                                      .toLowerCase(),
                                                                  onChanged: !controller
                                                                          .isEdit
                                                                      ? null
                                                                      : (value) {
                                                                          controller
                                                                              .changeDropDownValue(
                                                                            index,
                                                                            controller.activityData!,
                                                                            value.toString(),
                                                                          );
                                                                        },
                                                                ),
                                                              ),
                                                              (w * 0.02)
                                                                  .addWSpace(),
                                                              const Text("Yes")
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: w * 0.08,
                                                                child: Radio(
                                                                  activeColor:
                                                                      appColor,
                                                                  value: "no",
                                                                  groupValue: data
                                                                      ?.value
                                                                      .toLowerCase(),
                                                                  onChanged: !controller
                                                                          .isEdit
                                                                      ? null
                                                                      : (value) {
                                                                          controller
                                                                              .changeDropDownValue(
                                                                            index,
                                                                            controller.activityData!,
                                                                            value.toString(),
                                                                          );
                                                                        },
                                                                ),
                                                              ),
                                                              (w * 0.02)
                                                                  .addWSpace(),
                                                              const Text("No")
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: w * 0.08,
                                                                child: Radio(
                                                                  activeColor:
                                                                      appColor,
                                                                  value: "nop",
                                                                  groupValue:
                                                                      data?.value,
                                                                  onChanged: !controller
                                                                          .isEdit
                                                                      ? null
                                                                      : (value) {
                                                                          controller
                                                                              .changeDropDownValue(
                                                                            index,
                                                                            controller.activityData!,
                                                                            value.toString(),
                                                                          );
                                                                        },
                                                                ),
                                                              ),
                                                              (w * 0.02)
                                                                  .addWSpace(),
                                                              const Text("NA")
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              /// Selected Yes
                                              if (data?.value
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "yes" &&
                                                  data!.imageList
                                                      .isNotEmpty) ...[
                                                /// COMMENT REMARK TEXT

                                                commentRemarkText(
                                                    controller, index, h),

                                                /// COMMENT TEXT FILED

                                                commentTextField(
                                                  controller,
                                                  index,
                                                  w,
                                                  h,
                                                  // ((preferences
                                                  //                     .getString(
                                                  //                         SharedPreference
                                                  //                             .userType)
                                                  //                     .toString() ==
                                                  //                 "maker" &&

                                                  ((preferences
                                                                      .getString(
                                                                          SharedPreference
                                                                              .userType)
                                                                      ?.contains(
                                                                          "maker") ==
                                                                  true &&
                                                              controller
                                                                      .activityData
                                                                      ?.wiStatus ==
                                                                  "checker_reject") ||
                                                          (preferences
                                                                          .getString(SharedPreference
                                                                              .userType)
                                                                          .toString() ==
                                                                      "checker" &&
                                                                  controller
                                                                          .activityData
                                                                          ?.wiStatus ==
                                                                      "approver_reject") ==
                                                              true
                                                      ? false
                                                      : true),
                                                ),

                                                /// IMAGE GRID VIEW

                                                if (data.imageList.isNotEmpty ||
                                                    data.imageData
                                                        .isNotEmpty) ...[
                                                  AppString.images
                                                      .boldRobotoTextStyle(
                                                          fontSize: 16)
                                                      .paddingOnly(
                                                          top: h * 0.015),
                                                  imageGridView(controller,
                                                      index, h, context, w),

                                                  /// CAPTURE IMAGE BUTTON
                                                  if (controller.isEdit &&
                                                          // (preferences
                                                          //             .getString(
                                                          //                 SharedPreference
                                                          //                     .userType)
                                                          //             .toString() ==
                                                          //         "maker" &&

                                                          (preferences
                                                                      .getString(
                                                                          SharedPreference
                                                                              .userType)
                                                                      ?.contains(
                                                                          "maker") ==
                                                                  true &&
                                                              controller
                                                                      .activityData
                                                                      ?.wiStatus ==
                                                                  "checker_reject") ||
                                                      (preferences
                                                                  .getString(
                                                                      SharedPreference
                                                                          .userType)
                                                                  .toString() ==
                                                              "checker" &&
                                                          controller
                                                                  .activityData
                                                                  ?.wiStatus ==
                                                              "approver_reject"))
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      w * 0.18)
                                                              .copyWith(
                                                                  top:
                                                                      h * 0.03),
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          controller
                                                              .capturePhoto(
                                                                  index: index,
                                                                  context:
                                                                      context);
                                                        },
                                                        color: Colors.black,
                                                        height: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? h * 0.078
                                                            : h * 0.058,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: w *
                                                                          0.04),
                                                              child: assetImage(
                                                                  AppAssets
                                                                      .cameraIcon,
                                                                  scale: 2),
                                                            ),
                                                            AppString
                                                                .capturePhoto
                                                                .boldRobotoTextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontColor:
                                                                        backGroundColor),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ],

                                              /// Selected No
                                              if (data?.value
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "no") ...[
                                                /// COMMENT REMARK TEXT

                                                commentRemarkText(
                                                    controller, index, h),

                                                /// COMMENT TEXT FILED

                                                commentTextField(controller,
                                                    index, w, h, false),

                                                /// IMAGE GRID VIEW

                                                if (data!
                                                        .imageList.isNotEmpty ||
                                                    data.imageData
                                                        .isNotEmpty) ...[
                                                  AppString.images
                                                      .boldRobotoTextStyle(
                                                          fontSize: 16)
                                                      .paddingOnly(
                                                          top: h * 0.015),
                                                  imageGridView(controller,
                                                      index, h, context, w)
                                                ],

                                                /// CAPTURE IMAGE BUTTON

                                                controller.isEdit
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        w *
                                                                            0.18)
                                                            .copyWith(
                                                                top: h * 0.03),
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            controller
                                                                .capturePhoto(
                                                                    index:
                                                                        index,
                                                                    context:
                                                                        context);
                                                          },
                                                          color: Colors.black,
                                                          height: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? h * 0.078
                                                              : h * 0.058,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: w *
                                                                            0.04),
                                                                child: assetImage(
                                                                    AppAssets
                                                                        .cameraIcon,
                                                                    scale: 2),
                                                              ),
                                                              AppString
                                                                  .capturePhoto
                                                                  .boldRobotoTextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontColor:
                                                                          backGroundColor),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],

                                              /// SHOW HISTORY BUTTON

                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: data?.value
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "no" ||
                                                            data!.imageList
                                                                .isNotEmpty
                                                        ? 10
                                                        : 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.history =
                                                          data?.history ?? [];
                                                      Get.toNamed(
                                                          Routes.historyScreen);
                                                    },
                                                    child: "View History"
                                                        .semiBoldBarlowTextStyle(
                                                            fontColor:
                                                                appColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    /// OVERALL REMARK TEXT
                                    AppString.overAllRemark
                                        .boldRobotoTextStyle(fontSize: 18)
                                        .paddingOnly(bottom: h * 0.01),

                                    /// OVERALL REMARK TEXTFIELD
                                    overAllRemark(controller, w, h),

                                    /// OVERALL IMAGE == maker
                                    // if (preferences.getString(
                                    //             SharedPreference.userType) ==
                                    //         "maker" &&
                                    //     (controller.isEdit ||
                                    //         controller
                                    //             .activityData!
                                    //             .overallImagesList!
                                    //             .isNotEmpty)) ...[

                                      
if ((preferences.getString(SharedPreference.userType)?.contains("maker") ?? false) &&

    (controller.isEdit ||
     controller.activityData!.overallImagesList!.isNotEmpty)) ...[
       




// if ((preferences.getString(SharedPreference.userType)?.contains("maker") == true 
//     ) &&
//     (controller.isEdit || controller.activityData!.overallImagesList!.isNotEmpty)) ...[
//   (h * 0.03).addHSpace(),   
AppString.overAllImage     .boldRobotoTextStyle(fontSize: 18)
       .paddingOnly(bottom: h * 0.01),
                                     
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.02,
                                            horizontal: w * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// OVERALL IMAGE GRID VIEW

                                            if (controller.activityData
                                                    ?.overallImagesList !=
                                                null) ...[
                                              overallImageGridView(
                                                  controller, h, context, w)
                                            ],
                                            controller.isEdit &&
                                                    (controller
                                                            .activityData
                                                            ?.overallImagesList
                                                            ?.length)! <
                                                        2
                                                ? (controller.isNetwork ==
                                                            "no" &&
                                                        controller.offlineStatus
                                                            .isNotEmpty)
                                                    ? const SizedBox()
                                                    : Padding(
                                                        padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        w *
                                                                            0.18)
                                                            .copyWith(
                                                                top: h * 0.03),
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            controller
                                                                .captureOverallImage(
                                                                    context:
                                                                        context);
                                                          },
                                                          color: Colors.black,
                                                          height: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? h * 0.078
                                                              : h * 0.058,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: w *
                                                                            0.04),
                                                                child: assetImage(
                                                                    AppAssets
                                                                        .cameraIcon,
                                                                    scale: 2),
                                                              ),
                                                              AppString
                                                                  .capturePhoto
                                                                  .boldRobotoTextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontColor:
                                                                          backGroundColor),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                : const SizedBox(),

                                            ///
                                          ],
                                        ),
                                      ),
                                      (h * 0.03).addHSpace()
                                    ],

                                    /// OVERALL IMAGE == checker and approver
                                    // if (preferences.getString(
                                    //             SharedPreference.userType) !=
                                    //         "maker" &&
                                    //     controller.activityData!
                                    //         .overallImagesList!.isNotEmpty) ...[


if (!(preferences.getString(SharedPreference.userType)?.contains("maker") ?? false) &&
    controller.activityData!.overallImagesList!.isNotEmpty) ...[



                                      (h * 0.03).addHSpace(),
                                      AppString.overAllImage
                                          .boldRobotoTextStyle(fontSize: 18)
                                          .paddingOnly(bottom: h * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.02,
                                            horizontal: w * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            overallImageGridView(
                                                controller, h, context, w)
                                          ],
                                        ),
                                      ),
                                      (h * 0.03).addHSpace()
                                    ],
                                  ],
                                )
                              : noChecklist(h),
                          !controller.isEdit
                              ? alreadySubmitted(h, w)
                              : (controller.isNetwork == "no")
                                  ? controller.offlineStatus.isNotEmpty
                                      ? alreadySubmitted(h, w)
                                      : Row(
                                           children: [
                                          //   if (preferences.getString(
                                          //           SharedPreference
                                          //               .userType) !=
                                          //       "maker") ...[


  if (!(preferences.getString(SharedPreference.userType)?.contains("maker") ?? false)) ...[

                                            
                                              saveRejectButton(
                                                  h, controller, context),
                                              (w * 0.03).addWSpace()
                                            ],
                                            saveButton(h, controller, context),
                                          ],
                                        )
                                  : Column(
                                      children: [
                                        /// SAVE AS DRAFT
                                        saveAsDraftButton(
                                            h, controller, context),

                                        /// REJECT AND SUBMIT
                                        Row(
                                          children: [
                                            /// REJECT (SENT BACK)
                                            // if (preferences.getString(
                                            //         SharedPreference
                                            //             .userType) !=
                                            //     "maker") ...[

if (!(preferences.getString(SharedPreference.userType)?.contains("maker") ?? false)) ...[



                                              rejectButton(
                                                  controller, h, context),
                                              (w * 0.03).addWSpace()
                                            ],

                                            /// SUBMIT
                                            // preferences.getString(SharedPreference.userType) ==
                                            //             "maker" &&


                                            preferences.getString(SharedPreference.userType)?.contains("maker") == false &&

                                                    ((controller.isNetwork.isNotEmpty &&
                                                            controller
                                                                .savedLineData
                                                                .isNotEmpty)
                                                        ? controller.savedLineData.any((element) =>
                                                                element.value
                                                                    .toLowerCase()
                                                                    .toString() ==
                                                                "no") ==
                                                            true
                                                        : controller
                                                                .activityData!
                                                                .lineData!
                                                                .any((element) =>
                                                                    element.value
                                                                        .toLowerCase()
                                                                        .toString() ==
                                                                    "no") ==
                                                            true)
                                                ? (0.0).addHSpace()
                                                : submitButton(controller, h, context)
                                          ],
                                        ),
                                      ],
                                    ),
                          (h * 0.02).addHSpace(),
                        ],
                      ),
                    ),
                  ),
                  controller.uploadDataApiResponse.status == Status.LOADING ||
                          controller.rejectDataApiResponse.status ==
                              Status.LOADING
                      ? Container(
                          color: blackColor.withOpacity(0.2),
                          child: Center(
                            child: CircularProgressIndicator(color: blackColor),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// IMAGE GRIDVIEW

  Widget imageGridView(EditActivityController controller, int index, double h,
      BuildContext context, double w) {
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData[index]
            : controller.activityData?.lineData?[index];
    print('data?.imageData==============>>>${data?.imageData.length}');
    print('data?.imageList==============>>>${data?.imageList.length}');
    return GridView.builder(
      itemCount: (controller.isNetwork.isNotEmpty &&
              controller.savedLineData.isNotEmpty)
          ? data?.imageData.length
          : data?.imageList.length,
      physics: const NeverScrollableScrollPhysics(),
      padding:
          const EdgeInsets.symmetric(horizontal: 2).copyWith(top: h * 0.015),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
          crossAxisSpacing: w * 0.04,
          mainAxisSpacing: h * 0.018,
          childAspectRatio: 1.2),
      itemBuilder: (context, index1) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: blackColor, width: 1.2),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: (controller.isNetwork.isNotEmpty &&
                            controller.savedLineData.isNotEmpty)
                        ? data?.imageData[index1].contains('http://')
                            ? NetworkImage(data?.imageData[index1])
                            : data?.imageData[index1].contains('/data/user/')
                                ? FileImage(
                                    File(data?.imageData[index1] ?? ""),
                                  ) as ImageProvider
                                : MemoryImage(base64Decode(
                                        data?.imageData[index1] ?? ""))
                                    as ImageProvider
                        : data?.imageList[index1].contains('http://')
                            ? NetworkImage(data?.imageList[index1])
                            : FileImage(
                                File(data?.imageList[index1] ?? ""),
                              ) as ImageProvider,
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1.1,
              right: 1.1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        child: Container(
                          height: h * 0.52,
                          width: Responsive.isDesktop(context) ? w * 0.5 : w,
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor, width: 1.2),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: (controller.isNetwork.isNotEmpty &&
                                      controller.savedLineData.isNotEmpty)
                                  ? data?.imageData[index1].contains('http://')
                                      ? NetworkImage(data?.imageData[index1])
                                      : MemoryImage(base64Decode(
                                              data?.imageData[index1] ?? ""))
                                          as ImageProvider
                                  : data?.imageList[index1].contains('http://')
                                      ? NetworkImage(data?.imageList[index1])
                                      : FileImage(
                                          File(data?.imageList[index1] ?? ""),
                                        ) as ImageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: h * 0.052,
                                width: h * 0.052,
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: blackColor),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.remove_red_eye,
                      size:
                          Responsive.isDesktop(context) ? h * 0.037 : h * 0.025,
                      color: Colors.white),
                ),
              ),
            ),

            /// remove image

            if (controller.isNetwork.isNotEmpty &&
                controller.savedLineData.isNotEmpty) ...[
              if (data?.imageData.isNotEmpty ?? false)
                if (data?.imageData[index1].contains('http://') == false)
                  Positioned(
                    right:
                        Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
                    top: -h * 0.008,
                    child: !controller.isEdit
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              controller.removeImage(index1, index);
                            },
                            child: Center(
                                child: assetImage(AppAssets.closeIcon,
                                    height: h * 0.035)),
                          ),
                  ),
            ] else ...[
              if (data?.imageList.isNotEmpty ?? false)
                if (data?.imageList[index1].contains('http://') == false)
                  Positioned(
                    right:
                        Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
                    top: -h * 0.008,
                    child: !controller.isEdit
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              controller.removeImage(index1, index);
                            },
                            child: Center(
                                child: assetImage(AppAssets.closeIcon,
                                    height: h * 0.035)),
                          ),
                  ),
            ],
          ],
        );
      },
    );
  }

  /// OVERALL IMAGE GRIDVIEW

  Widget overallImageGridView(EditActivityController controller, double h,
      BuildContext context, double w) {
    log('isEdit==============>>>${controller.isEdit}');
    log('controller.isNetwork == "no"==============>>>${controller.isNetwork == "no"}');
    log(' controller.offlineStatus.isNotEmpty==============>>>${controller.offlineStatus.isNotEmpty}');
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData
            : controller.activityData?.overallImagesList;
    return GridView.builder(
      itemCount: controller.activityData?.overallImagesList?.length ?? 0,
      physics: const NeverScrollableScrollPhysics(),
      padding:
          const EdgeInsets.symmetric(horizontal: 2).copyWith(top: h * 0.015),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
          crossAxisSpacing: w * 0.04,
          mainAxisSpacing: h * 0.018,
          childAspectRatio: 1.2),
      itemBuilder: (context, index1) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: blackColor, width: 1.2),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: controller.activityData?.overallImagesList?[index1]
                            .contains('http://')
                        ? NetworkImage(
                            controller.activityData?.overallImagesList?[index1])
                        : FileImage(
                            File(controller
                                    .activityData?.overallImagesList?[index1] ??
                                ""),
                          ) as ImageProvider,
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1.1,
              right: 1.1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: Colors.white,
                        child: Container(
                          height: h * 0.65,
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor, width: 1.2),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: controller
                                      .activityData?.overallImagesList?[index1]
                                      .contains('http://')
                                  ? NetworkImage(controller
                                      .activityData?.overallImagesList?[index1])
                                  : FileImage(File(controller.activityData
                                          ?.overallImagesList?[index1] ??
                                      "")) as ImageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: h * 0.052,
                                width: h * 0.052,
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: blackColor),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.remove_red_eye,
                      size:
                          Responsive.isDesktop(context) ? h * 0.037 : h * 0.025,
                      color: Colors.white),
                ),
              ),
            ),

            /// remove image

            // if(controller.isNetwork == "no"
            //     ? controller.offlineStatus.isNotEmpty)

            if (controller.activityData?.overallImagesList?[index1]
                    .contains('http://') ==
                false)
              Positioned(
                right: Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
                top: -h * 0.008,
                child: !controller.isEdit ||
                        (controller.isNetwork == "no" &&
                            controller.offlineStatus.isNotEmpty)
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          controller.removeOverallImage(index1);
                        },
                        child: Center(
                            child: assetImage(AppAssets.closeIcon,
                                height: h * 0.035)),
                      ),
              ),
          ],
        );
      },
    );
  }

  /// COMMENT TEXTFIELD

  Widget commentTextField(EditActivityController controller, int index,
      double w, double h, bool readOnly) {
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData[index]
            : controller.activityData?.lineData?[index];
    return TextFormField(
      readOnly: readOnly == true ? readOnly : !controller.isEdit,
      controller: data?.controller,
      style: textFieldTextStyle,
      cursorWidth: 2,
      minLines: 5,
      maxLines: 5,
      decoration: InputDecoration(
        filled: true,
        fillColor: containerColor,
        hintText: AppString.writeHere,
        hintStyle: textFieldHintTextStyle,
        contentPadding:
            EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  /// COMMENT TEXT

  Widget commentRemarkText(
      EditActivityController controller, int index, double h) {
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData[index]
            : controller.activityData?.lineData?[index];
    return Row(
      children: [
        AppString.cmtAndRemark.boldRobotoTextStyle(fontSize: 16),
        data?.value.toString().toLowerCase() == "yes"
            ? AppString.optional.boldRobotoTextStyle(fontSize: 16)
            : const SizedBox(),
      ],
    ).paddingOnly(bottom: h * 0.01);
  }

  /// SUBMIT BUTTON

  Widget submitButton(
      EditActivityController controller, double h, BuildContext context) {
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData
            : controller.activityData?.lineData;
    return Expanded(
      child: data?.isNotEmpty ?? false
          ? Padding(
              padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
              child: MaterialButton(
                onPressed: () async {
                  //   controller.formSubmittedTime = DateTime.now();
                  await controller.uploadCheckListController(isDraft: "no");
                },
                color: Colors.black,
                height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppString.submit.boldRobotoTextStyle(
                      fontSize: 16, fontColor: backGroundColor),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  /// REJECT BUTTON

  Widget rejectButton(
      EditActivityController controller, double h, BuildContext context) {
    final data =
        (controller.isNetwork.isNotEmpty && controller.savedLineData.isNotEmpty)
            ? controller.savedLineData
            : controller.activityData?.lineData;

    return Expanded(
      child: data?.isNotEmpty ?? false
          ? Padding(
              padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
              child: MaterialButton(
                onPressed: () async {
                  await controller.rejectCheckListController();
                },
                color: redColor,
                height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: AppString.reject.boldRobotoTextStyle(
                      fontSize: 16, fontColor: backGroundColor),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  /// SAVE AS DRAFT

  Widget saveAsDraftButton(
      double h, EditActivityController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: h * 0.025),
      child: MaterialButton(
        onPressed: () async {
          await controller.uploadCheckListController(isDraft: "yes");
        },
        color: appColor,
        height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: AppString.saveAsDraft
              .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
        ),
      ),
    );
  }

  /// SAVE AS DRAFT

  Widget saveRejectButton(
      double h, EditActivityController controller, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.025),
        child: MaterialButton(
          onPressed: () async {
            await controller.saveData(true);
          },
          color: redColor,
          height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: AppString.reject
                .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
          ),
        ),
      ),
    );
  }

  /// OVERALL REMARK

  Widget overAllRemark(EditActivityController controller, double w, double h) {
    return TextFormField(
      readOnly: !controller.isEdit,
      controller: controller.activityData!.controller,
      style: textFieldTextStyle,
      cursorWidth: 2,
      minLines: 5,
      maxLines: 5,
      decoration: InputDecoration(
        filled: true,
        fillColor: containerColor,
        hintText: AppString.writeHere,
        hintStyle: textFieldHintTextStyle,
        contentPadding:
            EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE6E6E6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE6E6E6),
          ),
        ),
      ),
    );
  }

  /// NO CHECKLIST TEXT

  Widget noChecklist(double h) {
    return SizedBox(
      height: h * 0.65,
      child: const Center(
        child: Text(AppString.noChecklistData),
      ),
    );
  }

  /// SAVE AS DRAFT

  Widget saveButton(
      double h, EditActivityController controller, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.025),
        child: MaterialButton(
          onPressed: () async {
            await controller.saveData(false);
          },
          color: appColor,
          height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: AppString.save
                .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
          ),
        ),
      ),
    );
  }

  /// ALREADY SUBMITTED TEXT

  Widget alreadySubmitted(double h, double w) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: h * 0.02),
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.035),
      decoration: const BoxDecoration(color: appColor),
      alignment: Alignment.center,
      child: AppString.submitted.boldRobotoTextStyle(
          fontSize: 15,
          fontColor: backGroundColor,
          textAlign: TextAlign.center),
    );
  }





  
//21/02/26
Future<void> downloadImage(String imagePath) async {
  await Permission.photos.request();
  await Permission.storage.request();

  try {
    Uint8List bytes;

    if (imagePath.contains('http')) {
      // Download from network
      var response = await Dio().get(
        imagePath,
        options: Options(responseType: ResponseType.bytes),
      );
      bytes = Uint8List.fromList(response.data);
    } else if (imagePath.startsWith('/')) {
      // Local file
      File file = File(imagePath);
      bytes = await file.readAsBytes();
    } else {
      // Base64 image
      bytes = base64Decode(imagePath);
    }

    await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: "download_${DateTime.now().millisecondsSinceEpoch}",
    );

    successSnackBar("Success", "Image saved to gallery");
  } catch (e) {
    errorSnackBar("Error", "Failed to download image");
  }
}

}


