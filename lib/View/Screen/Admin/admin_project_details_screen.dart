import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class AdminProjectDetailsScreen extends StatefulWidget {
  const AdminProjectDetailsScreen({super.key});

  @override
  State<AdminProjectDetailsScreen> createState() =>
      _AdminProjectDetailsScreenState();
}

class _AdminProjectDetailsScreenState extends State<AdminProjectDetailsScreen> {
  bool isFavorite = true;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: w * 1,
                      height: h * 0.33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        image: DecorationImage(
                            image: AssetImage(AppAssets.building1),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      bottom: -h * 0.07,
                      left: w * 0.06,
                      right: w * 0.06,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: h * 0.013, horizontal: w * 0.06),
                        decoration: BoxDecoration(
                          color: containerColor,
                          border: Border.all(
                            color: const Color(0xffE6E6E6),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppString.projectName
                                      .boldRobotoTextStyle(fontSize: 16),
                                  (h * 0.005).addHSpace(),
                                  SizedBox(
                                    width: w * 0.42,
                                    child: AppString.projectAddress
                                        .regularBarlowTextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              CircularStepProgressIndicator(
                                totalSteps: 10,
                                stepSize: 10,
                                currentStep: 7,
                                padding: 0.05,
                                height: h * 0.095,
                                width: h * 0.095,
                                selectedColor: greenColor,
                                unselectedColor: const Color(0xffBCCCBF),
                                child: Center(
                                  child:
                                      '70%'.boldRobotoTextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06)
                          .copyWith(top: h * 0.025),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back_ios,
                            size: 22, color: backGroundColor),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    children: [
                      (h * 0.068).addHSpace(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.018),
                        child: const SearchAndFilterRow(
                          hintText: AppString.searchParameter,
                        ),
                      ),
                      (h * 0.015).addHSpace(),
                      GridView.builder(
                        padding: EdgeInsets.only(top: h * 0.017),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: w * 0.00752,
                          crossAxisSpacing: w * 0.045,
                          mainAxisSpacing: h * 0.02,
                        ),
                        shrinkWrap: true,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // if (index == 0) {
                              //   Get.toNamed(Routes.towerDetailsScreen);
                              // }
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.035),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE6E6E6),
                                ),
                                color: containerColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  adminProjectDetails[index]
                                      .toString()
                                      .regularRobotoTextStyle(fontSize: 13),
                                  dummyValueList[index]
                                      .toString()
                                      .boldRobotoTextStyle(
                                          fontSize: 16,
                                          fontColor: index == 0 ||
                                                  index == 2 ||
                                                  index == 5
                                              ? Colors.red
                                              : index == 1 || index == 3
                                                  ? Colors.black
                                                  : greenColor),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
