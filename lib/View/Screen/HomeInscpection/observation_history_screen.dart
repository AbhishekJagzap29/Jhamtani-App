import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/observation_history_controller.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class ObservationHistoryScreen extends StatefulWidget {
  const ObservationHistoryScreen({super.key});

  @override
  State<ObservationHistoryScreen> createState() =>
      _ObservationHistoryScreenState();
}

class _ObservationHistoryScreenState extends State<ObservationHistoryScreen> {
  final ObservationHistoryController controller =
      Get.put(ObservationHistoryController());
  int? observationId;
  String? observationState;

 
  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['observation_id'] != null) {
      observationId = args['observation_id'];
      controller.fetchObservationHistory(observationId: observationId!);

    }
     observationState = args['state'];
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: GetBuilder<ObservationHistoryController>(
        builder: (controller) {
          final history = controller.observationHistory;

          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBarWidget(
              backGroundColor: const Color(0xFF3498DB),
              title: AppString.history.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
            ),
            body: controller.observationResponse.status == Status.LOADING
                ? const Center(child: CircularProgressIndicator())
                : history == null
                    ? const Center(
                        child: Text('No observation history available!'))
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03, vertical: h * 0.02),
                        child: Column(
                          children: [
                            if (history.checkerName != null &&
                                history.checkerName!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(w * 0.035),
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      border: Border.all(
                                          color: const Color(0xffE6E6E6)),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "Observation Created By :"
                                            .boldRobotoTextStyle(fontSize: 18),
                                        Row(
                                          children: [
                                            "Checker/Approver : ".boldRobotoTextStyle(
                                                fontSize: 16),
                                            "${history.checkerName}"
                                                .regularBarlowTextStyle(
                                                    fontSize: 16,
                                                    maxLine: 10,
                                                    textOverflow:
                                                        TextOverflow.ellipsis),
                                          ],
                                        ).paddingOnly(top: h * 0.005),
                                        (1.0).appDivider(color: Colors.black),
                                        "${history.issueTypeName ?? '-'}"
                                            .regularBarlowTextStyle(
                                                fontSize: 16,
                                                maxLine: 10,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppString.lastUpdateTime
                                          .semiBoldBarlowTextStyle(
                                              fontSize: 13),
                                      DateFormat('dd/MM/yyyy hh:mm')
                                          .format(
                                            (history.lastUpdate != null &&
                                                    history
                                                        .lastUpdate!.isNotEmpty)
                                                ? DateTime.parse(
                                                    history.lastUpdate!)
                                                : DateTime.now(),
                                          )
                                          .regularRobotoTextStyle(fontSize: 12),
                                    ],
                                  ).paddingSymmetric(vertical: h * 0.015),
                                ],
                              ),

                            // ✅ Maker Card - Show only if makerName is NOT empty
                            if (history.makerName != null &&
                                history.makerName!.trim().isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(w * 0.035),
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      border: Border.all(
                                          color: const Color(0xffE6E6E6)),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "Submitted/Solved By :"
                                            .boldRobotoTextStyle(fontSize: 18),
                                        Row(
                                          children: [
                                            "Maker : ".boldRobotoTextStyle(
                                                fontSize: 16),
                                            "${history.makerName}"
                                                .regularBarlowTextStyle(
                                                    fontSize: 16,
                                                    maxLine: 10,
                                                    textOverflow:
                                                        TextOverflow.ellipsis),
                                          ],
                                        ).paddingOnly(top: h * 0.005),
                                        (1.0).appDivider(color: Colors.black),
                                        "${history.issueTypeName ?? '-'}"
                                            .regularBarlowTextStyle(
                                                fontSize: 16,
                                                maxLine: 10,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppString.lastUpdateTime
                                          .semiBoldBarlowTextStyle(
                                              fontSize: 13),
                                      DateFormat('dd/MM/yyyy hh:mm')
                                          .format(
                                            (history.lastUpdate != null &&
                                                    history
                                                        .lastUpdate!.isNotEmpty)
                                                ? DateTime.parse(
                                                    history.lastUpdate!)
                                                : DateTime.now(),
                                          )
                                          .regularRobotoTextStyle(fontSize: 12),
                                    ],
                                  ).paddingSymmetric(vertical: h * 0.015),
                                ],
                              ),

  // 3️⃣ Checked/Approved By (Same Checker)





// 3️⃣ Checked/Approved By (Only if checker actually approved or resubmitted)
if (history.checkerName != null &&
    history.checkerName!.isNotEmpty &&
    (observationState == "completed" || observationState == "resubmitted_by_checker"))
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(color: const Color(0xffE6E6E6)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Checked/Approved By :".boldRobotoTextStyle(fontSize: 18),
            Row(
              children: [
                "Checker/Approver : ".boldRobotoTextStyle(fontSize: 16),
                "${history.checkerName}".regularBarlowTextStyle(
                  fontSize: 16,
                  maxLine: 10,
                  textOverflow: TextOverflow.ellipsis),
              ],
            ).paddingOnly(top: h * 0.005),
            (1.0).appDivider(color: Colors.black),
            "${history.issueTypeName ?? '-'}".regularBarlowTextStyle(
              fontSize: 16,
              maxLine: 10,
              textOverflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppString.lastUpdateTime.semiBoldBarlowTextStyle(fontSize: 13),
          DateFormat('dd/MM/yyyy hh:mm')
              .format(
                (history.lastUpdate != null &&
                        history.lastUpdate!.isNotEmpty)
                    ? DateTime.parse(history.lastUpdate!)
                    : DateTime.now(),
              )
              .regularRobotoTextStyle(fontSize: 12),
        ],
      ).paddingSymmetric(vertical: h * 0.015),
    ],
  ),


































  // if (history.checkerName != null && history.checkerName!.isNotEmpty)
  //   Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(w * 0.035),
  //         decoration: BoxDecoration(
  //           color: containerColor,
  //           border: Border.all(color: const Color(0xffE6E6E6)),
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             "Checked/Approved By :".boldRobotoTextStyle(fontSize: 18),
  //             Row(
  //               children: [
  //                 "Checker/Approver : ".boldRobotoTextStyle(fontSize: 16),
  //                 "${history.checkerName}".regularBarlowTextStyle(
  //                     fontSize: 16,
  //                     maxLine: 10,
  //                     textOverflow: TextOverflow.ellipsis),
  //               ],
  //             ).paddingOnly(top: h * 0.005),
  //             (1.0).appDivider(color: Colors.black),
  //             "${history.issueTypeName ?? '-'}".regularBarlowTextStyle(
  //                 fontSize: 16,
  //                 maxLine: 10,
  //                 textOverflow: TextOverflow.ellipsis),
  //           ],
  //         ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           AppString.lastUpdateTime.semiBoldBarlowTextStyle(fontSize: 13),
  //           DateFormat('dd/MM/yyyy hh:mm')
  //               .format(
  //                 (history.lastUpdate != null &&
  //                         history.lastUpdate!.isNotEmpty)
  //                     ? DateTime.parse(history.lastUpdate!)
  //                     : DateTime.now(),
  //               )
  //               .regularRobotoTextStyle(fontSize: 12),
  //         ],
  //       ).paddingSymmetric(vertical: h * 0.015),
  //     ],
  //   ),
],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
