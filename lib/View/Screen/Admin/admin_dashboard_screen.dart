import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class AdminDashBoardScreen extends StatefulWidget {
  const AdminDashBoardScreen({super.key});

  @override
  State<AdminDashBoardScreen> createState() => _AdminDashBoardScreenState();
}

class _AdminDashBoardScreenState extends State<AdminDashBoardScreen> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(h * 0.07),
            child: AppBarWidget(
              leading: false,
              centerTitle: true,
              title: AppString.dashboard.boldRobotoTextStyle(fontSize: 22),
            ),
          ),
          backgroundColor: backGroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SearchAndFilterRow(
                    hintText: AppString.searchProject,
                  ),
                  MasonryGridView.count(
                    crossAxisSpacing: w * 0.05,
                    mainAxisSpacing: w * 0.05,
                    crossAxisCount: 2,
                    padding: EdgeInsets.only(top: h * 0.02),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 25,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.adminProjectDetailsScreen);
                        },
                        child: Container(
                          padding: EdgeInsets.all(w * 0.026),
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xffE6E6E6),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: h * 0.12,
                                  width: w * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          AppAssets.building1,
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            index == 1 || index == 2 || index == 5 ? redColor : greenColor,
                                        radius: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: h * 0.011),
                                  child: StepProgressIndicator(
                                    totalSteps: 5,
                                    roundedEdges: const Radius.circular(10),
                                    currentStep: 2,
                                    unselectedSize: h * 0.007,
                                    size: h * 0.007,
                                    selectedColor: greenColor,
                                    unselectedColor: lightGreyColor,
                                  )),
                              AppString.projectNameTitle.boldRobotoTextStyle(fontSize: 14),
                              AppString.locationName
                                  .regularRobotoTextStyle(fontSize: 13, fontColor: greyTextColor)
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
