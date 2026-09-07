
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/pdf_view_controller.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_flat_list_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SiteVisitListViewScreen extends StatefulWidget {
  const SiteVisitListViewScreen({super.key});

  @override
  State<SiteVisitListViewScreen> createState() => _SiteVisitListViewScreenState();
}

class _SiteVisitListViewScreenState extends State<SiteVisitListViewScreen> {
  final HQIFlatListController controller = Get.put(HQIFlatListController());
  DownloadPdfController downloadPdfController = Get.put(DownloadPdfController());

  late String projectId;
  late String towerId;
  late String flatId;
  late String flatName;
  late String towerName;
  late int count;
  late String progress;
  String? visitName;
  int? visitId;
  // bool isOffline = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};

    projectId = args['project_id'] ?? '';
    towerId = args['tower_id'] ?? '';
    flatId = args['flat_id'] ?? '';
    flatName = args['flat_name'] ?? 'Flat';
    towerName = args['tower_name'] ?? 'Tower';
    count = args['count'] ?? 0;
    progress = args['progress']?.toString() ?? "0";
    // isOffline = args['offline'] ?? false;

    // controller.getFlatVisitsController(
    //   projectId: projectId,
    //   towerId: towerId,
    //   flatId: flatId,
    // );

    controller.getAndStoreData2(
      projectId: projectId,
      towerId: towerId,
      flatId: flatId,
      // flatVisitData: [],
    );
  }

  // @override
  // void dispose() {
  //   log('controller.flatVisitList::::::::::::::::despose');
  // controller.flatVisitList = [];
  // controller.locationdata = [];
  // controller.isOffline = false;
  // controller.flatVisitsApiResponse.data = [];
  // // controller.flatVisitData.clear();
  // // controller.flatVisitData = [];
  // controller.update();
  // super.dispose();
  // }

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
          title: AppString.sitevisits.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
        ),
        floatingActionButton: const CommonBackToHomeButton(),
        body: SafeArea(
          child: GetBuilder<HQIFlatListController>(
            builder: (controller) {
              if (controller.flatVisitsApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.flatVisitsApiResponse.status == Status.COMPLETE) {
                final visitList = controller.flatVisitList;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (h * 0.03).addHSpace(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: controller.isOffline ? h * 0.02 : h * 0.03),
                          decoration: BoxDecoration(
                            color: containerColor,
                            border: Border.all(color: const Color(0xffE6E6E6)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  flatName.boldRobotoTextStyle(fontSize: 22),
                                  Text(towerName, style: const TextStyle(fontSize: 12)),
                                  if (controller.isOffline) ...[
                                    SizedBox(height: h * 0.01),
                                    const Text("Offline", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  ]
                                ],
                              ),
                              Column(
                                children: [
                                  '$progress%'.boldRobotoTextStyle(fontSize: 30),
                                  5.0.addHSpace(),
                                  StepProgressIndicator(
                                    totalSteps: 5,
                                    currentStep: count,
                                    size: h * 0.007,
                                    unselectedSize: h * 0.007,
                                    selectedColor: greenColor,
                                    unselectedColor: lightGreyColor,
                                    roundedEdges: const Radius.circular(10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        (h * 0.02).addHSpace(),
                        Row(
                          children: [
                            Expanded(child: 1.0.appDivider(color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: AppString.sitevisits.boldRobotoTextStyle(fontSize: 16),
                            ),
                            Expanded(child: 1.0.appDivider(color: Colors.black)),
                          ],
                        ),
                        (h * 0.02).addHSpace(),
                        if (visitList.isEmpty)
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text("No Visits Available", style: TextStyle(color: Colors.grey.shade600)),
                          ))
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: visitList.length,
                            itemBuilder: (context, index) {
                              final visit = visitList[index];
                              final visitNo = index + 1;

                              return GestureDetector(
                                onTap: () {
                                  final visitData = controller.flatVisitList[index];

                                  Get.toNamed(
                                    Routes.hqiFlatScreen,
                                    arguments: {
                                      "project_id": projectId,
                                      "tower_id": towerId,
                                      "tower_name": towerName,
                                      "flat_id": flatId,
                                      "flat_name": flatName,
                                      "count": count,
                                      "progress": progress,
                                      // "data": visitData,
                                      "completeMode": false,
                                      "visit_name": visitData.visitName ?? "Site Visit",
                                      "visit_id": visitData.visitId,
                                      "offline": controller.isOffline,
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              visit.visitName ?? 'Site Visit $visitNo',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert, size: 20),
                                            onSelected: (value) {
                                             if (NetworkController().isResult == true) {
                                                errorSnackBar("Error!", "no internet connection");
                                              } else {
                                                if (value == 'download_pdf') {
                                                  downloadPdfController.downloadAndOpenPdf(
                                                    visitId: visit.visitId ?? 0,
                                                  );
                                                }
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem<String>(
                                                value: 'download_pdf',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.download, color: appColor, size: 18),
                                                    SizedBox(width: 6),
                                                    Text("Download PDF", style: TextStyle(fontSize: 13)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      StepProgressIndicator(
                                        totalSteps: 3,
                                        currentStep: visitNo.clamp(0, 3),
                                        size: h * 0.007,
                                        unselectedSize: h * 0.007,
                                        selectedColor: greenColor,
                                        unselectedColor: lightGreyColor,
                                        roundedEdges: const Radius.circular(10),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              } else if (controller.flatVisitsApiResponse.status == Status.ERROR) {
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

  Future<void> saveForOfflineUse(BuildContext context, double h, double w) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: "Saved Activity".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                "This activity data saved successfully for offline use. You can store a maximum of 5 activity data for offline use"
                    .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
              ),
            )
          ],
        );
      },
    );
  }
}
