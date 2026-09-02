import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_tower_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/no_internet.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/report_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  NetworkController networkController = Get.put(NetworkController());
  ReportController reportController = Get.put(ReportController());

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.clearData();
      reportController.startTime = TimeOfDay.now();
      for (int i = 0; i < 1; i++) {
        reportController.trainingController.add(TextEditingController());
        reportController.focusNodes.add(FocusNode());
        reportController.trainingValues.add(null);
        reportController.update();
      }
      // . reportController.trainingController.add(TextEditingController());
      //  FocusNode newFocusNode = FocusNode();
      //  reportController.focusNodes.add(newFocusNode);
      //  WidgetsBinding.instance
      //      .addPostFrameCallback((_) {
      //    FocusScope.of(context)
      //        .requestFocus(newFocusNode);
      //  });
      //  reportController.trainingValues.add(null);
      //  reportController.update();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reportController.trainingController.clear();
    reportController.trainingValues.clear();
    reportController.focusNodes.clear();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<NetworkController>(
      builder: (netController) {
        return Container(
          color: backGroundColor,
          child: Scaffold(
            backgroundColor: const Color(0xffFDFDFD),
            // appBar: AppBarWidget(
            //     title: AppString.addReport.boldRobotoTextStyle(fontSize: 20)),
                            appBar: AppBarWidget(
                  backGroundColor: const Color(0xFF3498DB),
                  title: AppString.addReport.boldRobotoTextStyle(
                    fontSize: 20,
                    fontColor: Colors.white,
                  ),
                ),
            body: netController.isResult == true
                ? NoInternetWidget(
                    h: h,
                    w: w,
                    onPressed: () {},
                  ).paddingOnly(bottom: h * 0.178)
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                    ),
                    child: GetBuilder<ReportController>(
                      builder: (controller) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (h * 0.02).addHSpace(),

                                /// Select Project
                                "${AppString.selectProject} :"
                                    .semiBoldBarlowTextStyle(fontSize: 14),
                                InnerShadowContainer(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Responsive.isDesktop(context)
                                                ? w * 0.0155
                                                : Responsive.isTablet(context)
                                                    ? w * 0.035
                                                    : w * 0.047),
                                    child: Center(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text(
                                            controller.selectProject?.name
                                                    .toString() ??
                                                AppString.selectProject,
                                            style: controller
                                                        .selectProject?.name !=
                                                    AppString.selectProject
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
                                        items: controller
                                            .homeScreenController.projectData
                                            .map((ProjectDetails items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: items.name
                                                .toString()
                                                .regularBarlowTextStyle(
                                                    fontSize: 16),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          controller.changeProject(newValue!);
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                (h * 0.02).addHSpace(),

                                ///Training Date

                                inputTextField(
                                  w,
                                  h,
                                  controller: controller.trainingDateController,
                                  hintText: AppString.selectTrainingDate,
                                  isReadOnly: true,
                                  validationText:
                                      AppString.pleaseSelectTrainingDate,
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    color: blackColor,
                                  ),
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(3000),
                                      initialDate: DateTime.now(),
                                      currentDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                  primary: blackColor
                                                      .withOpacity(0.9),
                                                  onPrimary: Colors.white,
                                                  onSurface: blackColor
                                                      .withOpacity(0.9)),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                ),
                                              ),
                                            ),
                                            child: child!);
                                      },
                                    );

                                    if (selectedDate != null) {
                                      controller.trainingDateController.text =
                                          DateFormat("dd-MM-yyyy")
                                              .format(selectedDate);
                                    }
                                  },
                                ),
                                (h * 0.02).addHSpace(),

                                ///Topic Name

                                inputTextField(w, h,
                                    controller: controller.topicController,
                                    hintText: AppString.topicOfTraining,
                                    validationText:
                                        AppString.pleaseEnterTopicOfTraining),
                                (h * 0.02).addHSpace(),

                                ///Building Name

                                "${AppString.selectTower} :"
                                    .semiBoldBarlowTextStyle(fontSize: 14),
                                Opacity(
                                  opacity: controller.getTowerResponse.status ==
                                              Status.LOADING ||
                                          controller.towerData!.isEmpty
                                      ? 0.6
                                      : 1,
                                  child: IgnorePointer(
                                    ignoring:
                                        controller.getTowerResponse.status ==
                                                    Status.LOADING ||
                                                controller.towerData!.isEmpty
                                            ? true
                                            : false,
                                    child: InnerShadowContainer(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Responsive.isDesktop(
                                                    context)
                                                ? w * 0.0155
                                                : Responsive.isTablet(context)
                                                    ? w * 0.035
                                                    : w * 0.047),
                                        child: Center(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Text(
                                                controller.selectTower?.name
                                                        .toString() ??
                                                    AppString.selectTower,
                                                style: controller.selectTower
                                                            ?.name !=
                                                        AppString.selectTower
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
                                            items: controller.towerData
                                                ?.map((TowerDatum items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: items.name
                                                    .toString()
                                                    .regularBarlowTextStyle(
                                                        fontSize: 16),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              controller.changeTower(newValue!);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),

                                ///Location

                                inputTextField(w, h,
                                    controller: controller.locationController,
                                    hintText: AppString.location,
                                    validationText:
                                        AppString.pleaseEnterLocation),
                                (h * 0.02).addHSpace(),

                                ///trainer Name

                                inputTextField(w, h,
                                    controller: controller.tNameController,
                                    hintText: AppString.trainerName,
                                    validationText:
                                        AppString.pleaseEnterTrainerName),
                                (h * 0.02).addHSpace(),

                                ///Training Given to Name List

                                "${AppString.trainingGiven} :"
                                    .semiBoldBarlowTextStyle(fontSize: 14),
                                (h * 0.01).addHSpace(),

                                controller.trainingValues.isEmpty ||
                                        controller.trainingController.isEmpty
                                    ? const Text("")
                                    : ListView.builder(
                                        itemCount:
                                            controller.trainingValues.length,
                                        // itemCount:
                                        //     1,
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: h * 0.02),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: containerColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(13),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              width: 2)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12,
                                                          horizontal: 17),
                                                      child: "${index + 1}"
                                                          .semiBoldBarlowTextStyle(
                                                              fontSize: 14),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField(
                                                        value: controller
                                                                .trainingValues[
                                                            index],
                                                        items: controller
                                                            .trainingGivenList
                                                            .map((e) {
                                                          return DropdownMenuItem(
                                                              value: e,
                                                              child: Center(
                                                                  child: Text(
                                                                      "$e")));

                                                          // child:
                                                          //     Text("$e"));
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          controller
                                                                  .trainingValues[
                                                              index] = value;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              containerColor
                                                                  .withOpacity(
                                                                      0.7),
                                                          hintText: AppString
                                                              .organization,
                                                          hintStyle:
                                                              textFieldTextStyle,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                      horizontal: w *
                                                                          0.045)
                                                                  .copyWith(
                                                                      top: h *
                                                                          0.03),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                width: 2),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .red.shade600,
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                width: 2),
                                                          ),
                                                        ),
                                                        hint: Center(
                                                          child: Text(
                                                            AppString
                                                                .organization,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                textFieldTextStyle,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                inputTextField(w, h,
                                                    controller: controller
                                                            .trainingController[
                                                        index],
                                                    focusNode: controller
                                                        .focusNodes[index],
                                                    onChanged: (p0) {
                                                  controller
                                                      .getNonEmptyTextFieldsCount();
                                                },
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        if (controller
                                                                .trainingController
                                                                .length >
                                                            1) {
                                                          controller
                                                              .trainingController
                                                              .removeAt(index);
                                                          controller.focusNodes
                                                              .removeAt(index);
                                                          controller
                                                              .trainingValues
                                                              .removeAt(index);
                                                          controller.update();
                                                          controller
                                                              .getNonEmptyTextFieldsCount();
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: blackColor,
                                                      ),
                                                    ),
                                                    isList: true,
                                                    validationText: AppString
                                                        .pleaseEnterTrainingGivenName),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                ///Add Name Controller

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.trainingController
                                          .add(TextEditingController());
                                      FocusNode newFocusNode = FocusNode();
                                      controller.focusNodes.add(newFocusNode);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        FocusScope.of(context)
                                            .requestFocus(newFocusNode);
                                      });
                                      controller.trainingValues.add(null);
                                      controller.update();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),

                                ///Start Time

                                inputTextField(
                                  w,
                                  h,
                                  controller:
                                      controller.trainingStartController,
                                  hintText: AppString.selectTrainingStartTime,
                                  isReadOnly: true,
                                  validationText:
                                      AppString.pleaseEnterTrainingDate,
                                  suffixIcon: Icon(
                                    Icons.watch_later_outlined,
                                    color: blackColor,
                                  ),
                                  onTap: () async {
                                    TimeOfDay? startTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                  primary: blackColor
                                                      .withOpacity(0.9),
                                                  onPrimary: Colors.white,
                                                  onSurface: blackColor
                                                      .withOpacity(0.9)),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                ),
                                              ),
                                            ),
                                            child: child!);
                                      },
                                    );

                                    print('startTime======>${startTime}');
                                    log('startTime======>${startTime}');

                                    if (startTime != null) {
                                      controller.startTime = startTime;
                                      controller.trainingStartController.text =
                                          startTime.format(context);
                                      controller.calculateTimeOfDayDifference();
                                      controller.update();
                                    }
                                  },
                                ),
                                (h * 0.02).addHSpace(),

                                ///End Time

                                inputTextField(
                                  w,
                                  h,
                                  controller: controller.trainingEndController,
                                  hintText: AppString.selectTrainingEndTime,
                                  isReadOnly: true,
                                  validationText:
                                      AppString.pleaseEnterTrainingDate,
                                  suffixIcon: Icon(
                                    Icons.watch_later_outlined,
                                    color: blackColor,
                                  ),
                                  onTap: () async {
                                    TimeOfDay? endTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                  primary: blackColor
                                                      .withOpacity(0.9),
                                                  onPrimary: Colors.white,
                                                  onSurface: blackColor
                                                      .withOpacity(0.9)),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                ),
                                              ),
                                            ),
                                            child: child!);
                                      },
                                    );

                                    print('endTime======>${endTime}');
                                    log('endTime======>${endTime}');

                                    if (endTime != null) {
                                      if (controller.isTimeValid(
                                          endTime, controller.startTime)) {
                                        controller.endTime = endTime;
                                        controller.trainingEndController.text =
                                            endTime.format(context);
                                        controller
                                            .calculateTimeOfDayDifference();
                                        controller.update();
                                      } else {
                                        errorSnackBar("Warning",
                                            "End time must be after the start time.");
                                      }
                                    }
                                  },
                                ),
                                (h * 0.02).addHSpace(),

                                ///Duration

                                inputTextField(w, h,
                                    controller: controller.tDurationController,
                                    hintText: AppString.totalDuration,
                                    isReadOnly: true,
                                    validationText:
                                        AppString.pleaseEnterTotalDuration),
                                (h * 0.02).addHSpace(),

                                ///Main Hours

                                inputTextField(w, h,
                                    controller: controller.tManHourController,
                                    isReadOnly: true,
                                    hintText: AppString.totalManhours,
                                    validationText:
                                        AppString.pleaseEnterTotalManhours),
                                (h * 0.02).addHSpace(),

                                ///Description

                                inputTextField(w, h,
                                    controller:
                                        controller.descriptionController,
                                    hintText: AppString.descriptions,
                                    validationText:
                                        AppString.pleaseEnterDescription,
                                    maxLine: 5),
                                (h * 0.02).addHSpace(),

                                ///OverAll Images

                                "${AppString.overAllImage} :"
                                    .semiBoldBarlowTextStyle(fontSize: 14)
                                    .paddingOnly(bottom: h * 0.01),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade100,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: h * 0.02, horizontal: w * 0.02),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// OVERALL IMAGE GRID VIEW

                                      if (controller.overallImages != []) ...[
                                        overallImageGridView(
                                            controller, h, context, w)
                                      ],

                                      /// CAPTURE IMAGE BUTTON

                                      controller.overallImages.length < 2
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                      horizontal: w * 0.18)
                                                  .copyWith(top: h * 0.03),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  controller
                                                      .captureOverallImage(
                                                          context: context);
                                                },
                                                color: Colors.black,
                                                height: Responsive.isDesktop(
                                                        context)
                                                    ? h * 0.078
                                                    : h * 0.058,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: w * 0.04),
                                                      child: assetImage(
                                                          AppAssets.cameraIcon,
                                                          scale: 2),
                                                    ),
                                                    AppString.capturePhoto
                                                        .boldRobotoTextStyle(
                                                            fontSize: 16,
                                                            fontColor:
                                                                backGroundColor),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                                controller.addReportResponse.status ==
                                        Status.LOADING
                                    ? showCircular()
                                    : submitButton(controller, h, context),
                                (h * 0.02).addHSpace(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// SUBMIT BUTTON

  Widget submitButton(
      ReportController controller, double h, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
      child: MaterialButton(
        onPressed: () async {
          if (controller.formKey.currentState!.validate()) {
            controller.addCheckerReport();
          }
        },
        color: Colors.black,
        height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppString.submit
              .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
        ),
      ),
    );
  }

  /// OVERALL IMAGE GRIDVIEW

  Widget overallImageGridView(
      ReportController controller, double h, BuildContext context, double w) {
    return GridView.builder(
      itemCount: controller.overallImages.length ?? 0,
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
                    image: FileImage(
                      File(controller.overallImages[index1] ?? ""),
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
                          // width: Responsive.isDesktop(context) ? w * 0.6 : w,
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor, width: 1.2),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(
                                      controller.overallImages[index1] ?? ""))
                                  as ImageProvider,
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
            Positioned(
              right: Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
              top: -h * 0.008,
              child: GestureDetector(
                onTap: () {
                  controller.removeOverallImage(index1);
                },
                child: Center(
                    child: assetImage(AppAssets.closeIcon, height: h * 0.035)),
              ),
            ),
          ],
        );
      },
    );
  }

  ///TextField
  inputTextField(double w, double h,
      {bool isReadOnly = false,
      bool isList = false,
      required TextEditingController controller,
      String? validationText,
      String? hintText,
      String? title,
      Widget? suffixIcon,
      FocusNode? focusNode,
      int? maxLine,
      String? Function(String?)? validation,
      void Function(String)? onChanged,
      VoidCallback? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ((title ?? hintText) ?? "").semiBoldBarlowTextStyle(fontSize: 14),
        isList ? const SizedBox() : (h * 0.008).addHSpace(),
        TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          style: textFieldTextStyle,
          cursorWidth: 2,
          onTap: onTap,
          focusNode: focusNode,
          validator: validation ??
              (value) {
                if (value!.trim().isEmpty) {
                  return validationText;
                }
                return null;
              },
          maxLines: maxLine ?? 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: containerColor.withOpacity(0.7),
            hintText: AppString.writeHere,
            hintStyle: textFieldHintTextStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
                .copyWith(top: h * 0.03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.red.shade600,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
