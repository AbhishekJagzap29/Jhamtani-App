import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/dashboard_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Profile/profile_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/report_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPages = preferences.getString(SharedPreference.userType) == "checker"
      ? [
          const HomeScreen(),
          const DashboardScreen(),
          const NotificationScreen(),
          const ReportScreen(),
          const ProfileScreen(),
        ]
      : [
          const HomeScreen(),
          const DashboardScreen(),
          const NotificationScreen(),
          const ProfileScreen(),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: false,
       // notchColor: Colors.black87,
notchColor: const Color(0xFF3498DB),
        removeMargins: false,
        bottomBarWidth: MediaQuery.of(context).size.width,
        durationInMilliSeconds: 300,
        bottomBarItems: preferences.getString(SharedPreference.userType) == "checker"
            ? [
                const BottomBarItem(
                  inActiveItem: Icon(
                    CupertinoIcons.home,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    CupertinoIcons.home,
                    color: Colors.white,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom2,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom2,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom3,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom3,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    CupertinoIcons.doc_text,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    CupertinoIcons.doc_text,
                    color: Colors.white,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom4,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom4,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                )
              ]
            : [
                const BottomBarItem(
                  inActiveItem: Icon(
                    CupertinoIcons.home,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    CupertinoIcons.home,
                    color: Colors.white,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom2,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom2,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom3,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom3,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset(
                    AppAssets.bottom4,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  activeItem: SvgPicture.asset(
                    AppAssets.bottom4,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
