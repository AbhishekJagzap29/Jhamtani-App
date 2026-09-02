import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/edit_activity_controller.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: GetBuilder<EditActivityController>(
//         builder: (controller) {
//           return Scaffold(
//             backgroundColor: backGroundColor,
//             appBar: AppBarWidget(
//               title: "History".boldRobotoTextStyle(fontSize: 20),
//             ),
//             body: controller.history.isEmpty
//                 ? const Center(
//                     child: Text('No checkpoint history available!'),
//                   )
//                 : SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                           child: ListView.builder(
//                             padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: controller.history.length,
//                             itemBuilder: (context, index) {
//                               return Column(
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(w * 0.035),
//                                     decoration: BoxDecoration(
//                                       color: containerColor,
//                                       border: Border.all(color: const Color(0xffE6E6E6)),
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         controller.history[index].isPass.toString().toLowerCase() == "no"
//                                             ? "Rejected By : ".boldRobotoTextStyle(fontSize: 18)
//                                             : "Submitted By : ".boldRobotoTextStyle(fontSize: 18),
//                                         Row(
//                                           children: [
//                                             "Name : ".boldRobotoTextStyle(fontSize: 16),
//                                             "${controller.history[index].submittedBy?.name} (${controller.history[index].submittedBy?.role})"
//                                                 .toString()
//                                                 .regularBarlowTextStyle(
//                                                     fontSize: 16, maxLine: 10, textOverflow: TextOverflow.ellipsis),
//                                           ],
//                                         ).paddingOnly(top: h * 0.01),
//                                         (1.0).appDivider(color: Colors.black),
//                                         "${controller.history[index].name} (Value : ${controller.history[index].isPass == "nop" ? "Not Applicable" : controller.history[index].isPass.toString().capitalizeFirst})"
//                                             .toString()
//                                             .regularBarlowTextStyle(
//                                                 fontSize: 16, maxLine: 10, textOverflow: TextOverflow.ellipsis),
//                                         if (controller.history[index].isPass.toString().toLowerCase() == "no" ||
//                                             controller.history[index].imageList.isNotEmpty) ...[
//                                           (h * 0.015).addHSpace(),
//                                           AppString.cmtAndRemark.boldRobotoTextStyle(fontSize: 16),
//                                           (h * 0.015).addHSpace(),
//                                           TextFormField(
//                                             readOnly: true,
//                                             maxLines: 5,
//                                             minLines: 1,
//                                             controller: controller.history[index].controller,
//                                             style: textFieldTextStyle,
//                                             cursorWidth: 2,
//                                             decoration: InputDecoration(
//                                               filled: true,
//                                               fillColor: containerColor,
//                                               hintText: AppString.writeHere,
//                                               hintStyle: textFieldHintTextStyle,
//                                               contentPadding:
//                                                   EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 borderSide: const BorderSide(
//                                                   color: Color(0xffE6E6E6),
//                                                 ),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 borderSide: const BorderSide(
//                                                   color: Color(0xffE6E6E6),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),

//                                           /// IMAGE
//                                           if (controller.history[index].imageList.isNotEmpty) ...[
//                                             (h * 0.03).addHSpace(),
//                                             GridView.builder(
//                                               itemCount: controller.history[index].imageList.length,
//                                               physics: const NeverScrollableScrollPhysics(),
//                                               shrinkWrap: true,
//                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                                   crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
//                                                   crossAxisSpacing: w * 0.04,
//                                                   mainAxisSpacing: h * 0.018,
//                                                   childAspectRatio: 1.2),
//                                               itemBuilder: (context, index1) {
//                                                 log('controller.history[index].imageList[index1]==========>>>>>> ${controller.history[index].imageList}');

//                                                 return Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                         border: Border.all(color: blackColor, width: 1.2),
//                                                         borderRadius: BorderRadius.circular(10),
//                                                         image: DecorationImage(
//                                                             image: NetworkImage(
//                                                                 controller.history[index].imageList[index1]),
//                                                             fit: BoxFit.fill),
//                                                       ),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: 1,
//                                                       left: 1.1,
//                                                       right: 1.1,
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           showDialog(
//                                                             context: context,
//                                                             builder: (context) {
//                                                               print(
//                                                                   'controlimageList[index1]---------->>>>>> ${controller.history[index].imageList[index1]}');

//                                                               return Dialog(
//                                                                 shape: const RoundedRectangleBorder(
//                                                                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                                                 ),
//                                                                 backgroundColor: Colors.white,
//                                                                 child: Container(
//                                                                   height: h * 0.52,
//                                                                   width: Responsive.isDesktop(context) ? w * 0.5 : w,
//                                                                   decoration: BoxDecoration(
//                                                                     border: Border.all(color: blackColor, width: 1.2),
//                                                                     borderRadius: BorderRadius.circular(15),
//                                                                     image: DecorationImage(
//                                                                         image: NetworkImage(controller
//                                                                             .history[index].imageList[index1]),
//                                                                         fit: BoxFit.fill),
//                                                                   ),
//                                                                   child: Align(
//                                                                     alignment: Alignment.topRight,
//                                                                     child: GestureDetector(
//                                                                       onTap: () {
//                                                                         Get.back();
//                                                                       },
//                                                                       child: Container(
//                                                                         height: h * 0.052,
//                                                                         width: h * 0.052,
//                                                                         margin: const EdgeInsets.all(10),
//                                                                         decoration: BoxDecoration(
//                                                                           color: Colors.white,
//                                                                           shape: BoxShape.circle,
//                                                                           border: Border.all(color: blackColor),
//                                                                         ),
//                                                                         alignment: Alignment.center,
//                                                                         child: const Center(
//                                                                           child: Icon(Icons.close, color: Colors.black),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             },
//                                                           );
//                                                         },
//                                                         child: Container(
//                                                           decoration: const BoxDecoration(
//                                                             color: appColor,
//                                                             borderRadius: BorderRadius.only(
//                                                               bottomRight: Radius.circular(10),
//                                                               bottomLeft: Radius.circular(10),
//                                                             ),
//                                                           ),
//                                                           child: Icon(Icons.remove_red_eye,
//                                                               size:
//                                                                   Responsive.isDesktop(context) ? h * 0.037 : h * 0.025,
//                                                               color: Colors.white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             )
//                                           ],
//                                         ]
//                                       ],
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       AppString.lastUpdateTime.semiBoldBarlowTextStyle(fontSize: 13),
//                                       DateFormat('dd/MM/yyyy hh:mm')
//                                           .format(DateTime.parse("${controller.history[index].updateTime}"))
//                                           .regularRobotoTextStyle(fontSize: 12),
//                                     ],
//                                   ).paddingSymmetric(vertical: h * 0.015)
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: GetBuilder<EditActivityController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBarWidget(
               backGroundColor: const Color(0xFF3498DB),
              title: "History".boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
            ),
            body: controller.history.isEmpty
                ? const Center(
                    child: Text('No checkpoint history available!'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.history.length,
                            itemBuilder: (context, index) {
                              return Column(
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
                                        controller.history[index].isPass.toString().toLowerCase() == "no"
                                            ? "Rejected By : ".boldRobotoTextStyle(fontSize: 18)
                                            : "Submitted By : ".boldRobotoTextStyle(fontSize: 18),
                                        Row(
                                          children: [
                                            "Name : ".boldRobotoTextStyle(fontSize: 16),
                                            "${controller.history[index].submittedBy?.name} (${controller.history[index].submittedBy?.role})"
                                                .toString()
                                                .regularBarlowTextStyle(
                                                    fontSize: 16, maxLine: 10, textOverflow: TextOverflow.ellipsis),
                                          ],
                                        ).paddingOnly(top: h * 0.01),
                                        (1.0).appDivider(color: Colors.black),
                                        "${controller.history[index].name} (Value : ${controller.history[index].isPass == "nop" ? "Not Applicable" : controller.history[index].isPass.toString().capitalizeFirst})"
                                            .toString()
                                            .regularBarlowTextStyle(
                                                fontSize: 16, maxLine: 10, textOverflow: TextOverflow.ellipsis),
                                        if (controller.history[index].isPass.toString().toLowerCase() == "no" ||
                                            controller.history[index].imageList.isNotEmpty) ...[
                                          (h * 0.015).addHSpace(),
                                          AppString.cmtAndRemark.boldRobotoTextStyle(fontSize: 16),
                                          (h * 0.015).addHSpace(),
                                          TextFormField(
                                            readOnly: true,
                                            maxLines: 5,
                                            minLines: 1,
                                            controller: controller.history[index].controller,
                                            style: textFieldTextStyle,
                                            cursorWidth: 2,
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
                                          ),

                                          /// IMAGE
                                          if (controller.history[index].imageList.isNotEmpty) ...[
                                            (h * 0.03).addHSpace(),
                                            GridView.builder(
                                              itemCount: controller.history[index].imageList.length,
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
                                                  crossAxisSpacing: w * 0.04,
                                                  mainAxisSpacing: h * 0.018,
                                                  childAspectRatio: 1.2),
                                              itemBuilder: (context, index1) {
                                                log('controller.history[index].imageList[index1]==========>>>>>> ${controller.history[index].imageList}');

                                                return Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: blackColor, width: 1.2),
                                                        borderRadius: BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                controller.history[index].imageList[index1]),
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
                                                              print(
                                                                  'controlimageList[index1]---------->>>>>> ${controller.history[index].imageList[index1]}');

                                                              return Dialog(
                                                                shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                                ),
                                                                backgroundColor: Colors.white,
                                                                child: Container(
                                                                  height: h * 0.52,
                                                                  width: Responsive.isDesktop(context) ? w * 0.5 : w,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: blackColor, width: 1.2),
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(controller
                                                                            .history[index].imageList[index1]),
                                                                        fit: BoxFit.fill),
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
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          shape: BoxShape.circle,
                                                                          border: Border.all(color: blackColor),
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: const Center(
                                                                          child: Icon(Icons.close, color: Colors.black),
                                                                        ),
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
                                                  ],
                                                );
                                              },
                                            )
                                          ],
                                        ]
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppString.lastUpdateTime.semiBoldBarlowTextStyle(fontSize: 13),
                                      DateFormat('dd/MM/yyyy hh:mm')
                                          .format(DateTime.parse("${controller.history[index].updateTime}"))
                                          .regularRobotoTextStyle(fontSize: 12),
                                    ],
                                  ).paddingSymmetric(vertical: h * 0.015)
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
