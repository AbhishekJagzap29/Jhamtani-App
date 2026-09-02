import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Profile/profile_screen_controller.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenController profileScreenController = Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        appBar: AppBarWidget(
          leading: false,
          centerTitle: true,
                              backGroundColor: const Color(0xFF3498DB),

          title: AppString.profile.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
          action: [
            Center(
              child: PopupMenuButton(
                iconColor: Colors.white,
                initialValue: profileScreenController.selectedItem,
                onSelected: (item) {
                  profileScreenController.selectedItem = item;
                  profileScreenController.update();
                  if (item == 1) {
                    /// Change Password
                    Get.toNamed(Routes.updatePasswordScreen);
                    profileScreenController.selectedItem = 0;
                    profileScreenController.update();
                  } else {
                    preferences.logOut();
                    profileScreenController.selectedItem = 0;
                    profileScreenController.update();
                  }
                },
                position: PopupMenuPosition.under,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.black,
                          size: Responsive.isTablet(context) ? h * 0.031 : h * 0.025,
                        ),
                        (w * 0.03).addWSpace(),
                        AppString.changePassword.regularRobotoTextStyle(fontSize: 16, fontColor: Colors.grey.shade600),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                          size: Responsive.isTablet(context) ? h * 0.031 : h * 0.025,
                        ),
                        (w * 0.03).addWSpace(),
                        AppString.logout.regularRobotoTextStyle(fontSize: 16, fontColor: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backGroundColor,
        body: GetBuilder<ProfileScreenController>(
          builder: (controller) {
            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    height: h * 0.355,
                    color: Colors.white,
                    width: w,
                    padding: EdgeInsets.only(bottom: h * 0.035),
                    child: networkImageShimmer(
                        h: h * 0.33,
                        radius: 0,
                        w: h,
                        url: controller.profileData?.profileImage ?? "",
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned.fill(
                  top: h * 0.33,
                  child: Container(
                    margin: EdgeInsets.only(top: h * 0.02),
                    padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                    decoration: BoxDecoration(
                      color: const Color(0xff888888).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      ),
                    ),
                    width: w,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          (h * 0.03).addHSpace(),
                          ListTile(
                            leading: Icon(
                              Icons.account_circle_outlined,
                              size: Responsive.isTablet(context) ? h * 0.031 : h * 0.025,
                            ),
                            title: SizedBox(
                                width: w * 0.058,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AppString.name
                                      .regularRobotoTextStyle(fontSize: 18, fontColor: Colors.grey.shade600),
                                )),
                            trailing: SizedBox(
                              width: w * 0.4,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: (controller.profileData?.name ?? '').boldRobotoTextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.switch_account_outlined,
                              size: Responsive.isTablet(context) ? h * 0.031 : h * 0.025,
                            ),
                            title: AppString.username
                                .regularRobotoTextStyle(fontSize: 18, fontColor: Colors.grey.shade600),
                            trailing: SizedBox(
                                width: w * 0.4,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: (controller.profileData?.username ?? "").boldRobotoTextStyle(fontSize: 18))),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.badge,
                              size: Responsive.isTablet(context) ? h * 0.031 : h * 0.025,
                            ),
                            title: SizedBox(
                              width: w * 0.2,
                              child: AppString.userType
                                  .regularRobotoTextStyle(fontSize: 18, fontColor: Colors.grey.shade600),
                            ),
                          //   trailing: SizedBox(
                          //       width: w * 0.4,
                          //       child: Align(
                          //           alignment: Alignment.centerRight,
                          //           child: (controller.profileData?.userType ?? "").boldRobotoTextStyle(fontSize: 18))),
                          // ),
               trailing: SizedBox(
  width: w * 0.4,
  child: Align(
    alignment: Alignment.centerRight,
    child: controller.profileData?.userType != null && controller.profileData!.userType!.isNotEmpty
        ? controller.profileData!.userType!.join(", ").boldRobotoTextStyle(fontSize: 18)
        : "".boldRobotoTextStyle(fontSize: 18),
  ),
),


                         // (h * 0.01).addHSpace(),

                          /// logout
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: w * 0.18)
                          //       .copyWith(top: h * 0.05),
                          //   child: MaterialButton(
                          //     onPressed: () async {
                          //       preferences.logOut();
                          //     },
                          //     color: Colors.black,
                          //     height: Responsive.isDesktop(context)
                          //         ? h * 0.078
                          //         : h * 0.058,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         AppString.logOut.boldRobotoTextStyle(
                          //             fontSize: 16, fontColor: backGroundColor),
                          //         (w * 0.02).addWSpace(),
                          //         Icon(
                          //           Icons.exit_to_app,
                          //           color: Colors.white,
                          //           size: Responsive.isTablet(context)
                          //               ? h * 0.031
                          //               : h * 0.025,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // (h * 0.1).addHSpace(),
                       )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),

        /*  appBar: AppBarWidget(
          leading: false,
          centerTitle: false,
          title: AppString.profile.boldRobotoTextStyle(fontSize: 20),
          ),
        body: GetBuilder<ProfileScreenController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: h * 0.2,
                  width: h * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(controller.profileData?.profileImage ?? ""), fit: BoxFit.fill),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: controller.profileData?.profileImage == "" ||
                            controller.profileData!.profileImage!.isEmpty
                        ? assetImage(AppAssets.profileImage)
                        : const SizedBox(),
                  ),
                ),
                (w * 0.12).addHSpace(),
                Container(
                  width: w * 0.8,
                  padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1, 5),
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                      child:
                          "Name : ${controller.profileData?.name ?? ""}".boldRobotoTextStyle(fontSize: 18)),
                ),
                Container(
                  width: w * 0.8,
                  margin: EdgeInsets.symmetric(vertical: h * 0.022),
                  padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1, 5),
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                      child: "Username : ${controller.profileData?.username ?? ""}"
                          .boldRobotoTextStyle(fontSize: 18)),
                ),
                Container(
                  width: w * 0.8,
                  padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1, 5),
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: "User type : ${controller.profileData?.userType ?? ""}"
                        .boldRobotoTextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: w * 0.18).copyWith(top: w * 0.1, bottom: h * 0.085),
                  child: MaterialButton(
                    onPressed: () async {
                      preferences.logOut();
                    },
                    color: Colors.black,
                    height: h * 0.058,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppString.logOut.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                        (w * 0.02).addWSpace(),
                        const Icon(Icons.exit_to_app, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),*/
      ),
    );
  }
}
