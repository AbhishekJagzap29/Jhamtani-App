import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Screen/IntroScreen/intro_screen_controller.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/utils/extension.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  IntroScreenController introScreenController = Get.put(IntroScreenController());

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<IntroScreenController>(
      builder: (controller) {
        return Container(
          color: backGroundColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backGroundColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.045, left: w * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        3,
                        (index) => index == controller.select
                            ? Container(
                                height: Responsive.isTablet(context) ? h * 0.015 : h * 0.012,
                                width: w * 0.072,
                                margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                                decoration: BoxDecoration(
                                  color: appColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )
                            : Container(
                                height: Responsive.isTablet(context) ? h * 0.015 : h * 0.012,
                                width: Responsive.isTablet(context) ? h * 0.015 : h * 0.012,
                                margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                                decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                      ),
                    ),
                  ),

                  (h * 0.025).addHSpace(),

                  // SizedBox(height: h * 0.025),
                  Expanded(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: h * 0.58,
                              width: w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    onBoardImage[index],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.085).copyWith(top: h * 0.038),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  onBoardTitle[index].boldRobotoTextStyle(),

                                  (h * 0.010).addHSpace(),

                                  // SizedBox(height: h * 0.010),
                                  onBoardDescription[index]
                                      .semiBoldBarlowTextStyle(fontColor: greyTextColor)
                                      .paddingOnly(right: w * 0.07),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06).copyWith(bottom: h * 0.047),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.loginScreen);
                          },
                          child: AppString.skipText.regularBarlowTextStyle(fontSize: 17),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.select == 2) {
                              Get.offAllNamed(Routes.loginScreen);
                            } else {
                              controller.changeIndex(controller.select + 1);
                            }

                            pageController.animateToPage(controller.select,
                                duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: w * 0.044),
                            height: h * 0.06,
                            width: h * 0.065,
                            decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_forward, color: backGroundColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
