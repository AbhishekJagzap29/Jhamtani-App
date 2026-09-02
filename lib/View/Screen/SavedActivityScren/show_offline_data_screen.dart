import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';

class ShowOfflineDataScreen extends StatefulWidget {
  const ShowOfflineDataScreen({super.key});

  @override
  State<ShowOfflineDataScreen> createState() => _ShowOfflineDataScreenState();
}

class _ShowOfflineDataScreenState extends State<ShowOfflineDataScreen> {
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
            title: AppString.projectsChecklist
                .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              (h * 0.03).addHSpace(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // if (controller.projectDetailsRes?.projectData
                      //         ?.checklistData?.isEmpty ??
                      //     false)
                      //   SizedBox(
                      //     height: h * 0.2,
                      //     child: const Center(
                      //       child: Text('No Data!'),
                      //     ),
                      //   )
                      // else
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: h * 0.03),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context) ? 3 : 2,
                          childAspectRatio: Responsive.isDesktop(context)
                              ? w * 0.0012
                              : Responsive.isTablet(context)
                                  ? w * 0.0018
                                  : w * 0.00365,
                          crossAxisSpacing: Responsive.isDesktop(context)
                              ? w * 0.04
                              : Responsive.isTablet(context)
                                  ? w * 0.06
                                  : w * 0.075,
                          mainAxisSpacing: Responsive.isDesktop(context)
                              ? h * 0.05
                              : h * 0.03,
                        ),
                        shrinkWrap: true,
                        itemCount: 2,
                        // controller.projectDetailsRes
                        //         ?.projectData?.checklistData?.length ??
                        //     0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              log("ON_TAP CALLED");
                              index == 0
                                  ? Get.toNamed(Routes.saveActivityScreenNew)
                                  : Get.toNamed(Routes.showSaveHQIScreen);

                              // preferences.putString(
                              //     SharedPreference.projectId, controller.projectId);
                              // Get.toNamed(Routes.projectDetailsScreen,
                              //     arguments: {
                              //       'cId':
                              //           "${controller.projectDetailsRes?.projectData?.checklistData![index].checklistId}"
                              //               .toString(),
                              //       'pId': controller.projectId,
                              //       'pName': controller.projectName,
                              //       "cName":
                              //           "${controller.projectDetailsRes?.projectData?.checklistData![index].name}"
                              //     });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE6E6E6),
                                ),
                                color: containerColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: Responsive.isDesktop(context)
                                          ? w * 0.23
                                          : w * 0.365,
                                      height: Responsive.isDesktop(context)
                                          ? h * 0.18
                                          : Responsive.isTablet(context)
                                              ? h * 0.12
                                              : h * 0.08,
                                      child: networkImageShimmer(
                                        radius: 10,
                                        fit: BoxFit.cover,
                                        h: h * 0.25,
                                        w: w,
                                        url: index == 0
                                            // ? "http://146.190.140.251:8069/web/image?model=project.details&field=image&id=99".toString()
                                            // : "http://146.190.140.251:8069/web/image?model=project.details&field=image&id=122".toString(),

                                            ? "http://157.245.102.113:8079/web/image?model=project.details&field=image&id=99"
                                                .toString()
                                            : "http://157.245.102.113:8079/web/image?model=project.details&field=image&id=157"
                                                .toString(),
                                      )),
                                  index == 0
                                      ? "Work Inspection"
                                          .semiBoldBarlowTextStyle(
                                          maxLine: 1,
                                          fontSize: 14,
                                          textOverflow: TextOverflow.ellipsis,
                                        )
                                      : "Home Inspection"
                                          .semiBoldBarlowTextStyle(
                                          maxLine: 1,
                                          fontSize: 14,
                                          textOverflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
