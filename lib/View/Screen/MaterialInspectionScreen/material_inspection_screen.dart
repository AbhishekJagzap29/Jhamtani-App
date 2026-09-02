import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/material_count_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/constructor_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/MaterialInspectionScreen/material_inspection_screen_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';

/// VJ Material Inspection  ==========================================================
// class MaterialInspectionScreen extends StatefulWidget {
//   const MaterialInspectionScreen({super.key});

//   @override
//   State<MaterialInspectionScreen> createState() =>
//       _MaterialInspectionScreenState();
// }

// class _MaterialInspectionScreenState extends State<MaterialInspectionScreen> {
//   MaterialInspectionScreenController materialInspectionScreenController =
//       Get.find();

//  String? name;
//   @override
//   void initState() {
//     super.initState();
//         name = Get.arguments['name'] ?? '';

//     materialInspectionScreenController.getMaterialInspectionCounts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: backGroundColor,
//       appBar: AppBarWidget(
//           title:
//               AppString.materialInspection.boldRobotoTextStyle(fontSize: 20)),
//       floatingActionButton:
// (preferences.getString(SharedPreference.userType)?.contains("maker") ?? false)

//        //  preferences.getString(SharedPreference.userType) == "maker"
//               ? FloatingActionButton(
//                   onPressed: () {
//                     Get.toNamed(Routes.createMaterialInspectionScreen);
//                   },
//                   backgroundColor: const Color(0xff000000),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   ),
//                 )
//               : const SizedBox(),
//       body: GetBuilder<MaterialInspectionScreenController>(
//         builder: (controller) {
//           final CountData = controller.miCountData;
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//             child: Column(
//               children: [
//                 (h * 0.02).addHSpace(),
//                 Container(
//                   padding: EdgeInsets.only(
//                       left: w * 0.06,
//                       right: w * 0.06,
//                       top: h * 0.03,
//                       bottom: h * 0.025),
//                   decoration: BoxDecoration(
//                     color: containerColor,
//                     border: Border.all(
//                       color: const Color(0xffE6E6E6),
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//     name!.boldRobotoTextStyle(fontSize: 22),

//                             ],
//                           ),
//                         ],
//                       ),
//                       (h * 0.01).addHSpace(),
//                       Column(
//                         children: [
//                           Divider(
//                             color: const Color(0xffE6E6E6),
//                             thickness: 2,
//                             height: h * 0.02,
//                           ),
//                           Row(
//                             children: [
//                               'Maker Submitted        :  '
//                                   .boldRobotoTextStyle(fontSize: 12),
//                               (controller.miCountData?.makerCompleted ?? 0)
//                                   .toString()
//                                   .regularRobotoTextStyle(fontSize: 10),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               'Checker Submitted    :  '
//                                   .boldRobotoTextStyle(fontSize: 12),
//                               (controller.miCountData?.checkerCompleted ?? 0)
//                                   .toString()
//                                   .regularRobotoTextStyle(fontSize: 10),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               'Approver Submitted  :  '
//                                   .boldRobotoTextStyle(fontSize: 12),
//                               (controller.miCountData?.approverCompleted ?? 0)
//                                   .toString()
//                                   .regularRobotoTextStyle(fontSize: 10),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: Responsive.isDesktop(context)
//                           ? h * 0.028
//                           : h * 0.016),
//                   child: SearchAndFilterRow(
//                     onChanged: (p0) {
//                       controller.search(p0);
//                     },
//                     hintText: "Search MI Report",
//                   ),
//                 ),
//                 (h * 0.02).addHSpace(),
//                 Expanded(child: Builder(
//                   builder: (context) {
//                     if (controller.getMaterialInspectionResponse.status ==
//                         Status.LOADING) {
//                       return showCircular();
//                     } else if (controller
//                             .getMaterialInspectionResponse.status ==
//                         Status.COMPLETE) {
//                       return controller
//                               .searchMaterialInspectionResponseModel.isEmpty
//                           ? const Center(
//                               child: Text(
//                                   'No Material Inspection data available!'),
//                             )
//                           : ListView.builder(
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: controller
//                                   .searchMaterialInspectionResponseModel.length,
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 return Column(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         if (preferences.getString(
//                                                 SharedPreference.userType) ==
//                                             "maker") {
//                                           // if (index + 1 > 1
//                                           //     ? controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].status == "draft"
//                                           //     : controller.materialInspectionResponseModel?.miData?.materialInspection?[index].status == "draft" && index > 0) {
//                                           //   errorSnackBar("Oops!",
//                                           //       'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection?[index - 1].seqNo?.toUpperCase()} first');
//                                           //   return;
//                                           // }
//                                         }

//                                         /// Checker
//                                         if (preferences.getString(
//                                                 SharedPreference.userType) ==
//                                             "checker") {
//                                           if (controller
//                                                   .materialInspectionResponseModel
//                                                   ?.miData
//                                                   ?.materialInspection![index]
//                                                   .status ==
//                                               "draft") {
//                                             errorSnackBar("Stay Connected",
//                                                 'Please wait, until maker submit checklist!');
//                                             return;
//                                           }
//                                           // else if (index <= 0) {
//                                           // } else if (index + 1 > 1
//                                           //     ? controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].status == "submit"
//                                           //     : controller.materialInspectionResponseModel?.miData?.materialInspection?[index].status == "submit") {
//                                           //   errorSnackBar("Oops!",
//                                           //       'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].seqNo?.toUpperCase()} first');
//                                           //   return;
//                                           // }
//                                         }

//                                         /// Approver
//                                         if (preferences.getString(
//                                                 SharedPreference.userType) ==
//                                             "approver") {
//                                           if (controller
//                                                       .materialInspectionResponseModel
//                                                       ?.miData
//                                                       ?.materialInspection![
//                                                           index]
//                                                       .status ==
//                                                   "submit" ||
//                                               controller
//                                                       .materialInspectionResponseModel
//                                                       ?.miData
//                                                       ?.materialInspection![
//                                                           index]
//                                                       .status ==
//                                                   "draft") {
//                                             errorSnackBar("Stay Connected",
//                                                 'Please wait, until maker and checker submit checklist!');
//                                             return;
//                                           }
//                                           // else if (controller.materialInspectionResponseModel?.miData?.materialInspection![index].status == "submit") {
//                                           //   errorSnackBar("Stay Connected", 'Please wait, until checker submit checklist!');
//                                           //   return;
//                                           // }
//                                           // else if (index <= 0) {
//                                           // } else if (index + 1 > 1
//                                           //     ? controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].status == "checked"
//                                           //     : controller.materialInspectionResponseModel?.miData?.materialInspection![index].status == "checked") {
//                                           //   errorSnackBar("Oops!",
//                                           //       'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].seqNo?.toUpperCase()} first');
//                                           //   return;
//                                           // }
//                                         }

//                                         controller.updateSelectedReport(controller
//                                                 .searchMaterialInspectionResponseModel[
//                                             index]);
//                                         Get.toNamed(
//                                             Routes
//                                                 .updateMaterialInspectionScreen,
//                                             arguments: {
//                                               "screen": "materialInspection",
//                                               "id": '',
//                                             });
//                                       },
//                                       child: Container(
//                                         margin:
//                                             EdgeInsets.only(bottom: h * 0.02),
//                                         decoration: BoxDecoration(
//                                           color: containerColor,
//                                           border: Border.all(
//                                             color: const Color(0xffE6E6E6),
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: h * 0.02,
//                                                   horizontal: w * 0.04),
//                                               child: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   CircleAvatar(
//                                                     backgroundColor: greenColor,
//                                                     radius: 7,
//                                                   ),
//                                                   (w * 0.03).addWSpace(),
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       SizedBox(
//                                                         width: w * 0.62,
//                                                         child: Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             "${controller.searchMaterialInspectionResponseModel[index].mirNo}"
//                                                                 .toString()
//                                                                 .boldRobotoTextStyle(
//                                                                     maxLine: 2,
//                                                                     textOverflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                     fontSize:
//                                                                         15),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       (w * 0.02).addWSpace(),
//                                                       SizedBox(
//                                                         width: w * 0.05,
//                                                         child: PopupMenuButton(
//                                                           icon: const Icon(Icons
//                                                               .more_vert_rounded),
//                                                           itemBuilder:
//                                                               (context) {
//                                                             return [
//                                                               PopupMenuItem(
//                                                                 onTap:
//                                                                     () async {
//                                                                   await Future.delayed(
//                                                                       const Duration(
//                                                                           milliseconds:
//                                                                               300));
//                                                                   await controller
//                                                                       .deleteMaterialInspection(
//                                                                           "${controller.searchMaterialInspectionResponseModel[index].id}");
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     const Icon(
//                                                                         Icons
//                                                                             .delete,
//                                                                         color:
//                                                                             appColor),
//                                                                     (w * 0.02)
//                                                                         .addWSpace(),
//                                                                     AppString
//                                                                         .deleteActivity
//                                                                         .regularRobotoTextStyle(
//                                                                             fontSize:
//                                                                                 16),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               PopupMenuItem(
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Icon(
//                                                                         Icons
//                                                                             .cancel_outlined,
//                                                                         color:
//                                                                             redColor),
//                                                                     (w * 0.02)
//                                                                         .addWSpace(),
//                                                                     AppString
//                                                                         .close
//                                                                         .regularRobotoTextStyle(
//                                                                             fontSize:
//                                                                                 16),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ];
//                                                           },
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Container(
//                                               width: w,
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: w * 0.06,
//                                                   vertical: h * 0.0072),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     const BorderRadius.only(
//                                                   bottomLeft:
//                                                       Radius.circular(10),
//                                                   bottomRight:
//                                                       Radius.circular(10),
//                                                 ),
//                                                 border: Border.all(
//                                                   color: Colors.grey.shade300,
//                                                 ),
//                                               ),
//                                               child: (controller
//                                                               .materialInspectionResponseModel
//                                                               ?.miData
//                                                               ?.materialInspection![
//                                                                   index]
//                                                               .status ==
//                                                           "draft"
//                                                       ? "Status : ${controller.materialInspectionResponseModel?.miData?.materialInspection![index].status.toString().capitalizeFirst}"
//                                                       : "Last updated by ${controller.materialInspectionResponseModel?.miData?.materialInspection![index].status == "submit" ? "Maker" : (controller.materialInspectionResponseModel?.miData?.materialInspection![index].status == "approve") ? "Approver" : "Checker"}")
//                                                   .toString()
//                                                   .boldRobotoTextStyle(
//                                                       fontColor: appColor,
//                                                       fontSize: 14),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.only(bottom: h * 0.02),
//                                       child: Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             AppString.createdAt
//                                                 .semiBoldBarlowTextStyle(
//                                                     fontSize: 11),
//                                             "${controller.searchMaterialInspectionResponseModel[index].dateOfInsp}"
//                                                 .regularRobotoTextStyle(
//                                                     fontSize: 11),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ).paddingOnly(
//                                     bottom: index ==
//                                             controller
//                                                     .searchMaterialInspectionResponseModel
//                                                     .length -
//                                                 1
//                                         ? w * 0.18
//                                         : 0);
//                               },
//                             );
//                     } else if (controller
//                             .getMaterialInspectionResponse.status ==
//                         Status.ERROR) {
//                       return const Center(child: Text('Server Error'));
//                     } else {
//                       return const Center(child: Text('Something went wrong'));
//                     }
//                   },
//                 )),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

/// VB Material Inspection  ==========================================================
class MaterialInspectionScreen extends StatefulWidget {
  const MaterialInspectionScreen({super.key});

  @override
  State<MaterialInspectionScreen> createState() =>
      _MaterialInspectionScreenState();
}

class _MaterialInspectionScreenState extends State<MaterialInspectionScreen> {
  MaterialInspectionScreenController materialInspectionScreenController =
      Get.find();

  Color _statusDotColor(String? status) {
    final value = status?.toLowerCase() ?? "";
    if (value.contains("reject")) {
      return redColor;
    }
    if (value == "draft" || value == "submit") {
      return lightGreyColor;
    }
    if (value == "checked") {
      return yellowColor;
    }
    if (value == "approve") {
      return greenColor;
    }
    return greenColor;
  }

  String _inspectionStatusText(String? miStatus, String? status) {
    final value = (miStatus?.isNotEmpty ?? false) ? miStatus! : status ?? "";
    switch (value.toLowerCase()) {
      case "checker_reject":
        return "Status : Checker Rejected";
      case "approver_reject":
        return "Status : Approver Rejected";
      case "draft":
        return "Status : Draft";
      case "submit":
        return "Last updated by Maker";
      case "approve":
        return "Last updated by Approver";
      case "checked":
        return "Last updated by Checker";
      default:
        return "Status : ${value.toString().capitalizeFirst}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBarWidget(
          backGroundColor: const Color(0xFF3498DB),
          title: AppString.materialInspection
              .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white)),
      floatingActionButton:
          preferences.getString(SharedPreference.userType) == "maker"
              ? FloatingActionButton(
                  onPressed: () {
                    Get.toNamed(Routes.createMaterialInspectionScreen);
                  },
                  backgroundColor: const Color(0xFF3498DB),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
      body: GetBuilder<MaterialInspectionScreenController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                (h * 0.02).addHSpace(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Responsive.isDesktop(context)
                          ? h * 0.028
                          : h * 0.016),
                  child: SearchAndFilterRow(
                    onChanged: (p0) {
                      controller.search(p0);
                    },
                    // controller: controller.searchController,
                    hintText: AppString.searchActivity,
                  ),
                ),
                (h * 0.02).addHSpace(),
                Expanded(child: Builder(
                  builder: (context) {
                    if (controller.getMaterialInspectionResponse.status ==
                        Status.LOADING) {
                      return showCircular();
                    } else if (controller
                            .getMaterialInspectionResponse.status ==
                        Status.COMPLETE) {
                      return controller
                              .searchMaterialInspectionResponseModel.isEmpty
                          ? const Center(
                              child: Text(
                                  'No Material Inspection data available!'),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller
                                  .searchMaterialInspectionResponseModel.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (preferences.getString(
                                                SharedPreference.userType) ==
                                            "maker") {
                                          if (index + 1 > 1
                                              ? controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index - 1]
                                                      .status ==
                                                  "draft"
                                              : controller
                                                          .materialInspectionResponseModel
                                                          ?.miData
                                                          ?.materialInspection?[
                                                              index]
                                                          .status ==
                                                      "draft" &&
                                                  index > 0) {
                                            errorSnackBar("Oops!",
                                                'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection?[index - 1].seqNo?.toUpperCase()} first');

                                            return;
                                          }
                                        }

                                        /// Checker

                                        if (preferences.getString(
                                                SharedPreference.userType) ==
                                            "checker") {
                                          if (controller
                                                  .materialInspectionResponseModel
                                                  ?.miData
                                                  ?.materialInspection![index]
                                                  .status ==
                                              "draft") {
                                            errorSnackBar("Stay Connected",
                                                'Please wait, until maker submit checklist!');
                                            return;
                                          } else if (index <= 0) {
                                          } else if (index + 1 > 1
                                              ? controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index - 1]
                                                      .status ==
                                                  "submit"
                                              : controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection?[
                                                          index]
                                                      .status ==
                                                  "submit") {
                                            errorSnackBar("Oops!",
                                                'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].seqNo?.toUpperCase()} first');
                                            return;
                                          }
                                        }

                                        /// Approver

                                        if (preferences.getString(
                                                SharedPreference.userType) ==
                                            "approver") {
                                          if (controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index]
                                                      .status ==
                                                  "submit" ||
                                              controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index]
                                                      .status ==
                                                  "draft") {
                                            errorSnackBar("Stay Connected",
                                                'Please wait, until maker and checker submit checklist!');
                                            return;
                                          } else if (controller
                                                  .materialInspectionResponseModel
                                                  ?.miData
                                                  ?.materialInspection![index]
                                                  .status ==
                                              "submit") {
                                            errorSnackBar("Stay Connected",
                                                'Please wait, until checker submit checklist!');
                                            return;
                                          } else if (index <= 0) {
                                          } else if (index + 1 > 1
                                              ? controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index - 1]
                                                      .status ==
                                                  "checked"
                                              : controller
                                                      .materialInspectionResponseModel
                                                      ?.miData
                                                      ?.materialInspection![
                                                          index]
                                                      .status ==
                                                  "checked") {
                                            errorSnackBar("Oops!",
                                                'Please update ${controller.materialInspectionResponseModel?.miData?.materialInspection![index - 1].seqNo?.toUpperCase()} first');
                                            return;
                                          }
                                        }

                                        controller.updateSelectedReport(controller
                                                .searchMaterialInspectionResponseModel[
                                            index]);
                                        Get.toNamed(
                                            Routes
                                                .updateMaterialInspectionScreen,
                                            arguments: {
                                              "screen": "materialInspection",
                                              "id": '',
                                            });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(bottom: h * 0.02),
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          border: Border.all(
                                            color: const Color(0xffE6E6E6),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.02,
                                                  horizontal: w * 0.04),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: _statusDotColor((controller
                                                                .searchMaterialInspectionResponseModel[
                                                                    index]
                                                                .miStatus
                                                                ?.isNotEmpty ??
                                                            false)
                                                        ? controller
                                                            .searchMaterialInspectionResponseModel[
                                                                index]
                                                            .miStatus
                                                        : controller
                                                            .searchMaterialInspectionResponseModel[
                                                                index]
                                                            .status),
                                                    radius: 7,
                                                  ),
                                                  (w * 0.03).addWSpace(),
                                                  Row(
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
                                                            "${controller.searchMaterialInspectionResponseModel[index].seqNo}"
                                                                .toString()
                                                                .boldRobotoTextStyle(
                                                                    maxLine: 2,
                                                                    textOverflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        15),
                                                          ],
                                                        ),
                                                      ),
                                                      (w * 0.02).addWSpace(),
                                                      SizedBox(
                                                        width: w * 0.05,
                                                        child: PopupMenuButton(
                                                          icon: const Icon(Icons
                                                              .more_vert_rounded),
                                                          itemBuilder:
                                                              (context) {
                                                            return [
                                                              PopupMenuItem(
                                                                onTap:
                                                                    () async {
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              300));

                                                                  await controller
                                                                      .replicateMaterialInspection(
                                                                          "${controller.searchMaterialInspectionResponseModel[index].id}");
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
                                                                        .regularRobotoTextStyle(
                                                                            fontSize:
                                                                                16),
                                                                  ],
                                                                ),
                                                              ),
                                                              // if (preferences.getBool(SharedPreference
                                                              //     .del_activity_users) ==
                                                              //     true)
                                                              //
                                                              // /// delete
                                                              PopupMenuItem(
                                                                onTap:
                                                                    () async {
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              300));
                                                                  await controller
                                                                      .deleteMaterialInspection(
                                                                          "${controller.searchMaterialInspectionResponseModel[index].id}");
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color:
                                                                            appColor),
                                                                    (w * 0.02)
                                                                        .addWSpace(),
                                                                    AppString
                                                                        .deleteActivity
                                                                        .regularRobotoTextStyle(
                                                                            fontSize:
                                                                                16),
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
                                                                        .regularRobotoTextStyle(
                                                                            fontSize:
                                                                                16),
                                                                  ],
                                                                ),
                                                              ),
                                                            ];
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.06,
                                                  vertical: h * 0.0072),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: _inspectionStatusText(
                                                      controller
                                                          .searchMaterialInspectionResponseModel[
                                                              index]
                                                          .miStatus,
                                                      controller
                                                          .searchMaterialInspectionResponseModel[
                                                              index]
                                                          .status)
                                                  .toString()
                                                  .boldRobotoTextStyle(
                                                      fontColor: appColor,
                                                      fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: h * 0.02),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AppString.createdAt
                                                .semiBoldBarlowTextStyle(
                                                    fontSize: 11),
                                            "${controller.searchMaterialInspectionResponseModel[index].dateOfInsp}"
                                                .regularRobotoTextStyle(
                                                    fontSize: 11),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(
                                    bottom: index ==
                                            controller
                                                    .searchMaterialInspectionResponseModel
                                                    .length -
                                                1
                                        ? w * 0.18
                                        : 0);
                              },
                            );
                    } else if (controller
                            .getMaterialInspectionResponse.status ==
                        Status.ERROR) {
                      return const Center(child: Text('Server Error'));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  },
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
