import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/no_internet.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/add_report_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/report_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  NetworkController networkController = Get.put(NetworkController());
  ReportController reportController = Get.put(ReportController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportController.getReportData();
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
            appBar: AppBarWidget(
              leading: false,
              centerTitle: false,
              backGroundColor: const Color(0xFF3498DB),
              title: AppString.trainingReport.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white ),
            ),
            body: netController.isResult == true
                ? NoInternetWidget(
                    h: h,
                    w: w,
                    onPressed: () {},
                  ).paddingOnly(bottom: h * 0.178)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
                    child: GetBuilder<ReportController>(
                      builder: (controller) {
                        if (controller.getReportResponse.status == Status.LOADING) {
                          return showCircular();
                        } else if (controller.getReportResponse.status == Status.COMPLETE) {
                          return Column(
                            children: [
                              Expanded(
                                child: (controller.towerDataList == null || controller.towerDataList!.isEmpty)
                                    ? const Center(
                                        child: Text('No Report Found!'),
                                      ).paddingOnly(bottom: h * 0.15)
                                    : ListView.builder(
                                        padding: EdgeInsets.zero.copyWith(bottom: h * 0.12),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: controller.towerDataList?.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              Get.toNamed(Routes.reportDetailScreen, arguments: controller.towerDataList![index]);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(w * 0.02),
                                              margin: EdgeInsets.only(bottom: w * 0.038),
                                              decoration: BoxDecoration(
                                                color: containerColor,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: const Color(0xffE6E6E6),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  (h * 0.01).addWSpace(),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        (controller.towerDataList![index].trainerName ?? '').boldRobotoTextStyle(
                                                          textOverflow: TextOverflow.ellipsis,
                                                          fontSize: 17,
                                                          fontColor: blackColor,
                                                        ),
                                                        // (h * 0.005).addHSpace(),
                                                        // buildRow(
                                                        //     title:
                                                        //         "Tower Id : ",
                                                        //     subTitle:
                                                        //         "${controller.towerDataList![index].towerId}"),
                                                        (h * 0.005).addHSpace(),
                                                        buildRow(
                                                            title: "Topic of Training : ",
                                                            subTitle: "${controller.towerDataList![index].topicOfTraining}"),
                                                        (h * 0.005).addHSpace(),
                                                        buildRow(
                                                            title: "Number of attendees : ",
                                                            subTitle: "${controller.towerDataList![index].trainingGivenTo?.length}"),
                                                        (h * 0.005).addHSpace(),
                                                        buildRow(
                                                            title: "Total manhours : ",
                                                            subTitle: "${controller.towerDataList![index].totalManhours}"),
                                                        (h * 0.005).addHSpace(),
                                                      ],
                                                    ),
                                                  ),
                                                  (h * 0.005).addWSpace(),
                                                  Builder(
                                                    builder: (context) {
                                                      String formattedDateTime = DateFormat('dd MMM,yyyy')
                                                          .format(DateTime.parse("${controller.towerDataList![index].trainingDatedOn}"));

                                                      return Padding(
                                                        padding: EdgeInsets.only(bottom: h * 0.025),
                                                        child: formattedDateTime
                                                            .toString()
                                                            .boldRobotoTextStyle(fontSize: 10, fontColor: appColor),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        } else if (controller.getReportResponse.status == Status.ERROR) {
                          return const Center(
                            child: Text('Server Error'),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
            floatingActionButton: preferences.getString(SharedPreference.userType) == "checker"
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 90, right: 10),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddReportScreen(),
                            ));
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: blackColor,
                      child: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }

  Row buildRow({String? title, String? subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title!.boldRobotoTextStyle(fontSize: 13, fontColor: Colors.grey.shade700),
        Expanded(child: subTitle!.regularRobotoTextStyle(fontSize: 13, fontColor: Colors.grey.shade700)),
      ],
    );
  }
}
