import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/flat_floor_activity_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class FlatActivityScreen extends StatefulWidget {
  const FlatActivityScreen({super.key});

  @override
  State<FlatActivityScreen> createState() => _FlatActivityScreenState();
}

class _FlatActivityScreenState extends State<FlatActivityScreen> {
  FlatFloorActivityController flatFloorActivityController =
      Get.put(FlatFloorActivityController());
  TowerIdDataModal constData = Get.arguments['model'];
  int count = Get.arguments['count'];
  String progress = Get.arguments['progress'];
  TowerData? towerData = Get.arguments['tower_data'];
  ListFloor? flatFloorData = Get.arguments['flat_floor_data'];

  @override
  void initState() {
    getFlatData();
    super.initState();
  }

  getFlatData() async {
    String flatId = constData.id ?? "";
    await flatFloorActivityController
        .getFlatController(body: {"flat_id": flatId});
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
            title: AppString.flatActivity
                .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white)),
        floatingActionButton: const CommonBackToHomeButton(),
        body: SafeArea(
          child: GetBuilder<FlatFloorActivityController>(
            builder: (controller) {
              if (controller.getFlatApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.getFlatApiResponse.status ==
                  Status.COMPLETE) {
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
                                      top: h * 0.03,
                                      bottom: h * 0.025),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              '${controller.flatActivityRes?.activityData?.flatName}'
                                                  .boldRobotoTextStyle(
                                                      fontSize: 26),
                                              '${constData.towerName}'
                                                  .regularBarlowTextStyle(
                                                      fontSize: 12),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              '$progress%'.boldRobotoTextStyle(
                                                  fontSize: 30),
                                              5.0.addHSpace(),
                                              StepProgressIndicator(
                                                totalSteps: 5,
                                                roundedEdges:
                                                    const Radius.circular(10),
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
                                              'Total Checklists           :  '
                                                  .boldRobotoTextStyle(
                                                      fontSize: 12),
                                              (flatFloorData?.totalCount ?? '0')
                                                  .toString()
                                                  .regularRobotoTextStyle(
                                                      fontSize: 10),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              'Maker Submitted        :  '
                                                  .boldRobotoTextStyle(
                                                      fontSize: 12),
                                              (flatFloorData?.makerCount ?? '0')
                                                  .toString()
                                                  .regularRobotoTextStyle(
                                                      fontSize: 10),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              'Checker Submitted    :  '
                                                  .boldRobotoTextStyle(
                                                      fontSize: 12),
                                              (flatFloorData?.checkerCount ??
                                                      '0')
                                                  .toString()
                                                  .regularRobotoTextStyle(
                                                      fontSize: 10),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              'Approver Submitted  :  '
                                                  .boldRobotoTextStyle(
                                                      fontSize: 12),
                                              (flatFloorData?.approverCount ??
                                                      '0')
                                                  .toString()
                                                  .regularRobotoTextStyle(
                                                      fontSize: 10),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Responsive.isDesktop(context)
                                          ? h * 0.028
                                          : h * 0.016),
                                  child: SearchAndFilterRow(
                                    onChanged: (p0) {
                                      controller.searchActivity();
                                    },
                                    controller: controller.searchController,
                                    hintText: AppString.searchActivity,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: 1.0
                                            .appDivider(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: AppString.activities
                                          .boldRobotoTextStyle(fontSize: 16),
                                    ),
                                    Expanded(
                                        child: 1.0
                                            .appDivider(color: Colors.black)),
                                  ],
                                ),
                                controller.searchListOfActivityData.isEmpty
                                    ? SizedBox(
                                        height: h * 0.45,
                                        child: const Center(
                                          child: Text(
                                              'No activity data available!'),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.only(
                                            top: Responsive.isDesktop(context)
                                                ? h * 0.03
                                                : h * 0.017),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.flatDataLength,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              final data = ConstDataModel(
                                                towerName:
                                                    constData.towerName ?? "",
                                                flatFloorName:
                                                    "${controller.flatActivityRes?.activityData?.flatName}",
                                                data: controller
                                                        .searchListOfActivityData[
                                                    index],
                                                screen: 'flat',
                                                activityName: controller
                                                    .searchListOfActivityData[
                                                        index]
                                                    .name!,
                                                activityId: controller
                                                    .searchListOfActivityData[
                                                        index]
                                                    .activityId!
                                                    .toString(),
                                              );
                                              log('data----------- ${data.data}');

                                              final result = await Get.toNamed(
                                                Routes.activityDetailsScreen,
                                                arguments: {"model": data},
                                              );

                                              log('result---------->>>>>> $result');
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: h * 0.015,
                                                      horizontal: w * 0.035),
                                                  decoration: BoxDecoration(
                                                    color: containerColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                                        .searchListOfActivityData[
                                                                            index]
                                                                        .color ==
                                                                    'red'
                                                                ? redColor
                                                                : controller.searchListOfActivityData[index]
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
                                                                width: w * 0.62,
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
                                                                          child: "${controller.searchListOfActivityData[index].name}".toString().boldRobotoTextStyle(
                                                                              maxLine: 2,
                                                                              textOverflow: TextOverflow.ellipsis,
                                                                              fontSize: 15),
                                                                        ),
                                                                        controller.searchListOfActivityData[index].activity_type_status ==
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
                                                                        .searchListOfActivityData[
                                                                            index]
                                                                        .desc!
                                                                        .toString()
                                                                        .regularBarlowTextStyle(
                                                                            maxLine:
                                                                                3,
                                                                            textOverflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize: 11),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              SizedBox(
                                                                width:
                                                                    w * 0.075,
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
                                                                              Routes.viewPdf,
                                                                              arguments: "${controller.searchListOfActivityData[index].name}".toString());
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.download,
                                                                                color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.downloadPdf.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        onTap:
                                                                            () async {
                                                                          await Future.delayed(
                                                                              const Duration(milliseconds: 300));
                                                                          await controller
                                                                              .getReplicateActivityController(
                                                                            body: {
                                                                              "activity_id": "${controller.searchListOfActivityData[index].activityId}".toString()
                                                                            },
                                                                          );
                                                                          getFlatData();
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.copy,
                                                                                color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.replicateAct.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      if (preferences
                                                                              .getBool(SharedPreference.del_activity_users) ==
                                                                          true)

                                                                        /// delete
                                                                        PopupMenuItem(
                                                                          onTap:
                                                                              () async {
                                                                            await Future.delayed(const Duration(milliseconds: 300));
                                                                            await controller.deleteActivityController(body: {
                                                                              "activity_id": "${controller.searchListFloorOfActivityData[index].activityId}".toString()
                                                                            });

                                                                            getFlatData();
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Icon(Icons.delete, color: appColor),
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
                                                                              await controller.storeForOfflineUse(w: w, context: context, h: h, index: index, activityType: 'flat');
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.save,
                                                                                color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.saveAsOffline.regularRobotoTextStyle(fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.cancel_outlined,
                                                                                color: redColor),
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
                                                  padding: EdgeInsets.only(
                                                      top: h * 0.008,
                                                      bottom: h * 0.017),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AppString.lastUpdateTime
                                                            .semiBoldBarlowTextStyle(
                                                                fontSize: 11),
                                                        DateFormat(
                                                                'dd/MM/yyyy hh:mm')
                                                            .format(controller
                                                                .flatActivityRes!
                                                                .activityData!
                                                                .listFlatData![
                                                                    index]
                                                                .writeDate!)
                                                            .regularRobotoTextStyle(
                                                                fontSize: 11),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                controller.flatDataLength ==
                                        controller
                                            .searchListOfActivityData.length
                                    ? const SizedBox()
                                    : Center(
                                        child: controller.load
                                            ? showCircular()
                                            : TextButton(
                                                onPressed: () {
                                                  controller
                                                      .setFlatDataLength(false);
                                                },
                                                child: "Load more"
                                                    .semiBoldBarlowTextStyle(
                                                        fontColor: appColor),
                                              ),
                                      ),
                                (h * 0.1).addHSpace()
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    controller.getActivityChecklistApiResponse.status ==
                                Status.LOADING ||
                            controller.getReplicateActivityApiResponse.status ==
                                Status.LOADING
                        ? Container(
                            color: Colors.black12,
                            child: Center(
                              child: showCircular(),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              } else if (controller.getFlatApiResponse.status == Status.ERROR) {
                return const Center(child: Text('Server Error'));
              } else {
                getFlatData();
                return const Center(child: Text('Something went wrong'));
              }

              /*return controller.loading
                  ? showCircular()
                  : SingleChildScrollView(
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
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    border: Border.all(
                                      color: const Color(0xffE6E6E6),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          '${controller.flatActivityRes?.activityData?.flatName}'
                                              .boldRobotoTextStyle(fontSize: 26),
                                          '${constData.towerName}'.regularBarlowTextStyle(fontSize: 12),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          '70%'.boldRobotoTextStyle(fontSize: 30),
                                          5.0.addHSpace(),
                                          StepProgressIndicator(
                                            totalSteps: 5,
                                            roundedEdges: const Radius.circular(10),
                                            currentStep: 2,
                                            unselectedSize: h * 0.007,
                                            size: h * 0.007,
                                            selectedColor: greenColor,
                                            unselectedColor: lightGreyColor,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Responsive.isDesktop(context) ? h * 0.028 : h * 0.016),
                                  child: SearchAndFilterRow(
                                    onChanged: (p0) {
                                      controller.searchActivity();
                                    },
                                    controller: controller.searchController,
                                    hintText: AppString.searchActivity,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: 1.0.appDivider(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: AppString.activities.boldRobotoTextStyle(fontSize: 16),
                                    ),
                                    Expanded(child: 1.0.appDivider(color: Colors.black)),
                                  ],
                                ),
                                controller.searchListOfActivityData.isEmpty
                                    ? SizedBox(
                                        height: h * 0.45,
                                        child: const Center(
                                          child: Text('No activity data available!'),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.only(
                                            top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017),
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.flatDataLength,
                                        itemBuilder: (context, index) {
                                          var document = parse(
                                              controller.searchListOfActivityData[index].desc!.toString());

                                          return GestureDetector(
                                            onTap: () async {
                                              final data = ConstDataModel(
                                                  towerName: constData.towerName ?? "",
                                                  flatFloorName:
                                                      "${controller.flatActivityRes?.activityData?.flatName}",
                                                  data: controller.searchListOfActivityData[index],
                                                  screen: 'flat');

                                              final result = await Get.toNamed(
                                                Routes.activityDetailsScreen,
                                                arguments: {"model": data},
                                              );
                                              log('result---------->>>>>> $result');
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: h * 0.015, horizontal: w * 0.035),
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
                                                            backgroundColor: greenColor,
                                                            radius: 12,
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
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    "${controller.searchListOfActivityData[index].name}"
                                                                        .toString()
                                                                        .boldRobotoTextStyle(
                                                                            maxLine: 2,
                                                                            textOverflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize: 15),
                                                                    (h * 0.005).addHSpace(),
                                                                    document.body!.text
                                                                        .toString()
                                                                        .regularBarlowTextStyle(
                                                                            maxLine: 3,
                                                                            textOverflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize: 11),
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
                                                                          Get.toNamed(Routes.viewPdf,
                                                                              arguments:
                                                                                  "${controller.searchListOfActivityData[index].name}"
                                                                                      .toString());
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(Icons.download,
                                                                                color: appColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.downloadPdf
                                                                                .regularRobotoTextStyle(
                                                                                    fontSize: 16),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.cancel_outlined,
                                                                                color: redColor),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.close
                                                                                .regularRobotoTextStyle(
                                                                                    fontSize: 16),
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
                                                      children: [
                                                        AppString.lastUpdateTime
                                                            .semiBoldBarlowTextStyle(fontSize: 11),
                                                        DateFormat('dd/MM/yyyy hh:mm')
                                                            .format(controller.flatActivityRes!.activityData!
                                                                .listFlatData![index].writeDate!)
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
                                controller.flatDataLength == controller.searchListOfActivityData.length
                                    ? const SizedBox()
                                    : Center(
                                        child: controller.load
                                            ? showCircular()
                                            : TextButton(
                                                onPressed: () {
                                                  controller.setFlatDataLength(false);
                                                },
                                                child:
                                                    "Load more".semiBoldBarlowTextStyle(fontColor: appColor),
                                              ),
                                      ),
                                (h * 0.1).addHSpace()
                              ],
                            ),
                          )
                        ],
                      ),
                    );*/
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
            child: "Saved Activity".semiBoldBarlowTextStyle(
                fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This activity data saved successfully for the offline use. You can store maximum 10 activity data for offline use"
                    .regularRobotoTextStyle(
                        fontSize: 15, textAlign: TextAlign.center),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: "Okay".boldRobotoTextStyle(
                    fontSize: 16, fontColor: backGroundColor),
              ),
            )
          ],
        );
      },
    );
  }
}
