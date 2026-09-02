// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:jhamtani_app/View/Constant/app_color.dart';
// import 'package:jhamtani_app/View/Constant/app_string.dart';
// import 'package:jhamtani_app/View/constant/app_assets.dart';
//
// class AppBottomBar extends StatefulWidget {
//   const AppBottomBar({super.key});
//
//   @override
//   State<AppBottomBar> createState() => _AppBottomBarState();
// }
//
// class _AppBottomBarState extends State<AppBottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//
//
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           height: h * 0.066,
//           color: Colors.black,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * 0.075),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(
//                 5,
//                 (index) => index == 2
//                     ? SizedBox(
//                         height: h * 0.07,
//                         width: h * 0.07,
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           log('==INDEX==>$index');
//                         },
//                         child: assetImage(bottomBarIcon[index], scale: 2.5)),
//                 // Image.asset(bottomBarIcon[index], scale: 2.5)),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           right: 0,
//           left: 0,
//           bottom: 0,
//           child: GestureDetector(
//             onTap: () {
//               print('==INDEX==>2');
//             },
//             child: Container(
//               height: h * 0.07,
//               width: h * 0.07,
//               margin: const EdgeInsets.only(bottom: 5),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: appColor,
//               ),
//               child: Center(
//                 child: assetImage(bottomBarIcon[2], scale: 2.5),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
