import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_save_site_visit_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/site_visits_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class SaveActivityScreen extends StatefulWidget {
  const SaveActivityScreen({super.key});

  @override
  State<SaveActivityScreen> createState() => _SaveActivityScreenState();
}

class _SaveActivityScreenState extends State<SaveActivityScreen> {
  // final HQIFlatListController controller = Get.put(HQIFlatListController());
  HomeScreenController homeScreenController = Get.find();

  bool showLoader = false;
  List<ChecklistData> savedChecklist = [];
  List<LocationObservationData> offlineHQIData = [];

  String? projectId;
  String? towerId;
  String? flatId;
  String? flatName;
  String? towerName;
  int? count;
  String? progress;
  String? visitName;
  int? visitId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      homeScreenController.changeSyncStatus();
    });
    super.initState();
  }

  void getData() {
    savedChecklist = [];
    offlineHQIData = [];

    setState(() {
      showLoader = true;
    });

    /// ✅ Saved Activity Checklist Data
    String resData = preferences.getString(SharedPreference.activityData) ?? '';
    if (resData.isNotEmpty) {
      try {
        final data = jsonDecode(resData);
        savedChecklist = List<ChecklistData>.from(data.map((x) => ChecklistData.fromJson(x)));
        log('Checklist Data: $data');
      } catch (e) {
        log('Error decoding checklist: $e');
      }
    }

    String? hqiRaw = preferences.getString(SharedPreference.hqiFlatsOffline) ?? '';
    if (hqiRaw.isNotEmpty) {
      try {
        final parsed = jsonDecode(hqiRaw);
        offlineHQIData = List<LocationObservationData>.from(
          parsed.map((e) => LocationObservationData.fromJson(e)),
        );
        log('✅ Observation Data loaded: ${offlineHQIData.length}');
        log('✅ Observation Data loaded offlineHQIData: ${jsonEncode(offlineHQIData)}');
      } catch (e) {
        log('❌ Error decoding observation data: $e');
      }
    }

    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Container(
          color: backGroundColor,
          child: Scaffold(
            backgroundColor: const Color(0xffFDFDFD),
            appBar: AppBarWidget(
              centerTitle: true,
              backGroundColor: const Color(0xFF3498DB),
              title: AppString.savedActivity.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
              action: [
                /// Sync Button
                controller.sync
                    ? Padding(
                        padding: EdgeInsets.all(h * 0.003),
                        child: MaterialButton(
                          onPressed: () async {
                            await controller.syncData();
                            setState(() {});
                          },
                          color: appColor,
                          height: h * 0.058,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppString.syncData.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                              (w * 0.02).addWSpace(),
                              const Icon(Icons.sync, color: Colors.white),
                            ],
                          ),
                        ).paddingSymmetric(vertical: h * 0.005, horizontal: w * 0.015),
                      )
                    : const SizedBox()
              ],
            ),
            body: showLoader
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05).copyWith(
                      top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (savedChecklist.isEmpty && offlineHQIData.isEmpty) const Center(child: Text('No saved activity found!')),

                        /// 🔹 Checklist Activity Data
                        if (savedChecklist.isNotEmpty)
                          ...List.generate(savedChecklist.length, (index) {
                            final item = savedChecklist[index];
                            final hasChecklist = item.listChecklistData != null && item.listChecklistData!.isNotEmpty;
                            if (!hasChecklist) return const SizedBox();

                            return GestureDetector(
                              onTap: () async {
                                final data = ConstDataModel(
                                  towerName: item.listChecklistData?[0].towerName ?? "",
                                  activityId: item.activityId?.toString() ?? "",
                                  flatFloorName:
                                      item.listChecklistData![0].flatName != null && item.listChecklistData![0].flatName != "false"
                                          ? item.listChecklistData![0].flatName ?? ""
                                          : item.listChecklistData![0].flooName ?? "",
                                  data: item.listChecklistData,
                                  screen: 'save',
                                  activityName: item.activityName ?? "",
                                );

                                final result = await Get.toNamed(
                                  Routes.activityDetailsScreen,
                                  arguments: {"model": data},
                                );
                                log('Checklist Tap Result: $result');
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.017,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 12,
                                        ),
                                        (w * 0.03).addWSpace(),
                                        Expanded(
                                          child: (item.activityName ?? "").boldRobotoTextStyle(
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (h * 0.01).addHSpace(),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: h * 0.008, horizontal: w * 0.03),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: greyTextColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Project Name: ${item.listChecklistData?[0].projectName ?? "-"}"),
                                          Text("Tower Name: ${item.listChecklistData?[0].towerName ?? "-"}"),
                                          if (item.listChecklistData?[0].flooName != null && item.listChecklistData?[0].flooName != "false")
                                            Text("Floor Name: ${item.listChecklistData?[0].flooName}"),
                                          if (item.listChecklistData?[0].flatName != null && item.listChecklistData?[0].flatName != "false")
                                            Text("Flat Name: ${item.listChecklistData?[0].flatName}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                        ////// Offline Site Visit Observations
                        if (offlineHQIData.isNotEmpty)
                          ...List.generate(offlineHQIData.length, (index) {
                            final item = offlineHQIData[index];
                            final visitName = item.visitDetails?.visitName ?? "-";
                            final issueCategory = item.issueCategoryName ?? "-";
                            final issueType = item.issueTypeName ?? "-";

                            return GestureDetector(
                              // onTap: () {
                              //   Get.toNamed(
                              //     Routes.hqiFlatScreen,
                              //   );
                              // },

                              onTap: () {
                                final item = offlineHQIData[index];

                                final visitDetails = item.visitDetails;

                                // Convert VisitDetails to FlatVisitData
                                final convertedVisit = FlatVisitData(
                                  visitId: visitDetails?.visitId,
                                  visitName: visitDetails?.visitName,
                                  //locationData: visitDetails?.locationData ?? [],
                                );

                                Get.toNamed(
                                  Routes.hqiFlatScreen,
                                  arguments: {
                                    "project_id": projectId,
                                    "tower_id": towerId,
                                    "tower_name": towerName ?? "",
                                    "flat_id": flatId,
                                    "flat_name": flatName ?? "",
                                    "count": null, // or item.count if available
                                    "progress": null, // or item.progress if available
                                    "data": convertedVisit,
                                    //item
                                    //  .visitDetails, // assuming visitDetails is equivalent to online visitData
                                    "completeMode": false,
                                    "visit_name": item.visitDetails?.visitName ?? "Site Visit",
                                    "visit_id": item.visitDetails?.visitId,
                                    "offline": true, // you can add this if needed in your screen logic
                                  },
                                );
                              },

                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: h * 0.01),
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.017,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 12,
                                        ),
                                        (w * 0.03).addWSpace(),
                                        Expanded(
                                          child: (visitName).boldRobotoTextStyle(
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (h * 0.01).addHSpace(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: h * 0.008,
                                        horizontal: w * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: greyTextColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Issue Category: $issueCategory"),
                                          Text("Issue Type: $issueType"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
