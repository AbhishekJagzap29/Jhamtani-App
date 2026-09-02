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


class FloorActivityScreen extends StatefulWidget {
  const FloorActivityScreen({super.key});

  @override
  State<FloorActivityScreen> createState() => _FlatActivityScreenState();
}

class _FlatActivityScreenState extends State<FloorActivityScreen> {
  FlatFloorActivityController flatFloorActivityController =
      Get.put(FlatFloorActivityController());
  TowerIdDataModal constData = Get.arguments['model'];
  int count = Get.arguments['count'];
  String progress = Get.arguments['progress'];
  TowerData? towerData = Get.arguments['tower_data'];
  ListFloor? flatFloorData = Get.arguments['flat_floor_data'];

  @override
  void initState() {
    getFloorData();
    super.initState();
  }

  getFloorData() async {
    // await flatFloorActivityController.fetchFloorActivityData(floorId: constData.id ?? "");
    String floorId = constData.id ?? "";
    await flatFloorActivityController
        .getFloorController(body: {"floor_id": floorId});
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
            title: AppString.floorActivity.boldRobotoTextStyle(fontSize: 20,fontColor: Colors.white)),
        floatingActionButton: const CommonBackToHomeButton(),
        body: SafeArea(
          child: GetBuilder<FlatFloorActivityController>(
            builder: (controller) {
              if (controller.getFloorApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.getFloorApiResponse.status ==
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: SizedBox(
                                              width: w * 0.5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  '${controller.floorActivityRes?.activityData?.floorName}'
                                                      .boldRobotoTextStyle(
                                                          fontSize: 26),
                                                  '${constData.towerName}'
                                                      .regularBarlowTextStyle(
                                                          fontSize: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                '$progress%'
                                                    .boldRobotoTextStyle(
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
                                                  unselectedColor:
                                                      lightGreyColor,
                                                )
                                              ],
                                            ),
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
                                      controller.searchFloorActivity();
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
                                if (controller
                                    .searchListFloorOfActivityData.isNotEmpty)
                                  ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Responsive.isDesktop(context)
                                            ? h * 0.03
                                            : h * 0.017),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.floorDataLength,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final data = ConstDataModel(
                                            towerName:
                                                constData.towerName ?? "",
                                            flatFloorName:
                                                "${controller.floorActivityRes?.activityData?.floorName}",
                                            data: controller
                                                    .searchListFloorOfActivityData[
                                                index],
                                            screen: 'floor',
                                            activityName: controller
                                                .searchListFloorOfActivityData[
                                                    index]
                                                .name!,
                                            activityId: controller
                                                .searchListFloorOfActivityData[
                                                    index]
                                                .activityId!
                                                .toString(),
                                          );
                                          final result = await Get.toNamed(
                                            Routes.activityDetailsScreen,
                                            arguments: {"model": data},
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? h * 0.025
                                                          : h * 0.015,
                                                  horizontal: w * 0.035),
                                              decoration: BoxDecoration(
                                                color: containerColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                                    .searchListFloorOfActivityData[
                                                                        index]
                                                                    .color ==
                                                                'red'
                                                            ? redColor
                                                            : controller
                                                                        .searchListFloorOfActivityData[
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
                                                                      child: "${controller.searchListFloorOfActivityData[index].name}".toString().boldRobotoTextStyle(
                                                                          maxLine:
                                                                              2,
                                                                          textOverflow: TextOverflow
                                                                              .ellipsis,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    controller.searchListFloorOfActivityData[index].activity_type_status ==
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
                                                                    .searchListFloorOfActivityData[
                                                                        index]
                                                                    .desc!
                                                                    .toString()
                                                                    .regularBarlowTextStyle(
                                                                        maxLine:
                                                                            3,
                                                                        textOverflow:
                                                                            TextOverflow
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
                                                              icon: const Icon(Icons
                                                                  .more_vert_rounded),
                                                              itemBuilder:
                                                                  (context) {
                                                                return [
                                                                  PopupMenuItem(
                                                                    onTap: () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .viewPdf,
                                                                          arguments: controller
                                                                              .searchListFloorOfActivityData[index]
                                                                              .name!
                                                                              .toString());
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
                                                                          .getReplicateActivityController(
                                                                              body: {
                                                                            "activity_id":
                                                                                "${controller.searchListFloorOfActivityData[index].activityId}".toString()
                                                                          });

                                                                      getFloorData();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .copy,
                                                                            color:
                                                                                appColor),
                                                                        (w * 0.02)
                                                                            .addWSpace(),
                                                                        AppString
                                                                            .replicateAct
                                                                            .regularRobotoTextStyle(fontSize: 16),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (preferences
                                                                          .getBool(
                                                                              SharedPreference.del_activity_users) ==
                                                                      true)

                                                                    /// delete
                                                                    PopupMenuItem(
                                                                      onTap:
                                                                          () async {
                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                300));
                                                                        await controller.deleteActivityController(
                                                                            body: {
                                                                              "activity_id": "${controller.searchListFloorOfActivityData[index].activityId}".toString()
                                                                            });

                                                                        getFloorData();
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.delete,
                                                                              color: appColor),
                                                                          (w * 0.02)
                                                                              .addWSpace(),
                                                                          AppString
                                                                              .deleteActivity
                                                                              .regularRobotoTextStyle(fontSize: 16),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  PopupMenuItem(
                                                                    onTap: () {
                                                                      Future.delayed(
                                                                              const Duration(milliseconds: 200))
                                                                          .then(
                                                                        (value) async {
                                                                          await controller.storeForOfflineUse(
                                                                              w: w,
                                                                              context: context,
                                                                              h: h,
                                                                              index: index,
                                                                              activityType: 'floor');
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .save,
                                                                            color:
                                                                                appColor),
                                                                        (w * 0.02)
                                                                            .addWSpace(),
                                                                        AppString
                                                                            .saveAsOffline
                                                                            .regularRobotoTextStyle(fontSize: 16),
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
                                                            .searchListFloorOfActivityData[
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
                                  )
                                else
                                  SizedBox(
                                    height: h * 0.45,
                                    child: const Center(
                                      child:
                                          Text('No activity data available!'),
                                    ),
                                  ),
                                controller.floorDataLength ==
                                        controller.searchListFloorOfActivityData
                                            .length
                                    ? const SizedBox()
                                    : Center(
                                        child: controller.load
                                            ? showCircular()
                                            : TextButton(
                                                onPressed: () {
                                                  controller.setFloorDataLength(
                                                      false);
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
              } else if (controller.getFloorApiResponse.status ==
                  Status.ERROR) {
                return const Center(child: Text('Server Error'));
              } else {
                getFloorData();
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
                                            '${controller.floorActivityRes?.activityData?.floorName}'
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
                                        controller.searchFloorActivity();
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
                                  controller.searchListFloorOfActivityData.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017),
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.floorDataLength,
                                          itemBuilder: (context, index) {
                                            var document = parse(controller
                                                .searchListFloorOfActivityData[index].desc!
                                                .toString());

                                            return GestureDetector(
                                              onTap: () async {
                                                final data = ConstDataModel(
                                                    towerName: constData.towerName ?? "",
                                                    flatFloorName:
                                                        "${controller.floorActivityRes?.activityData?.floorName}",
                                                    data: controller.searchListFloorOfActivityData[index],
                                                    screen: 'floor');
                                                final result = await Get.toNamed(
                                                  Routes.activityDetailsScreen,
                                                  arguments: {"model": data},
                                                );

                                                log('result==========>>>>>> $result');
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: Responsive.isDesktop(context)
                                                            ? h * 0.025
                                                            : h * 0.015,
                                                        horizontal: w * 0.035),
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
                                                                      "${controller.searchListFloorOfActivityData[index].name}"
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
                                                                                arguments: controller
                                                                                    .searchListFloorOfActivityData[
                                                                                        index]
                                                                                    .name!
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
                                                              .format(controller
                                                                  .searchListFloorOfActivityData[index]
                                                                  .writeDate!)
                                                              .regularRobotoTextStyle(fontSize: 11),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : SizedBox(
                                          height: h * 0.45,
                                          child: const Center(
                                            child: Text('No activity data available!'),
                                          ),
                                        ),
                                  controller.floorDataLength == controller.searchListFloorOfActivityData.length
                                      ? const SizedBox()
                                      : Center(
                                          child: controller.load
                                              ? showCircular()
                                              : TextButton(
                                                  onPressed: () {
                                                    controller.setFloorDataLength(false);
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
}
