// // generate_nc_details_screen.dart
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/approver_closed_nc_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/approver_rejected_nc_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';

// class GenerateNcDetailsScreen extends StatefulWidget {
//   final String? projectId;
//   final String? towerId;
//   final String? floorId;
//   final String? flatId;
//   final String? projectResponsible;
//   final String? activityTypeId;
//   final String? activityId;
//   final String? description;
//   final Uint8List? rectifiedImage;
//   final String? projectCreateDate;
//   final String? customChecklistItem;

//   final bool fromMaker; // show search & filter only when true

//   const GenerateNcDetailsScreen({
//     Key? key,
//     this.projectId,
//     this.towerId,
//     this.floorId,
//     this.flatId,
//     this.projectResponsible,
//     this.activityTypeId,
//     this.activityId,
//     this.description,
//     this.rectifiedImage,
//     this.projectCreateDate,
//     this.customChecklistItem,
//     this.fromMaker = false,
//   }) : super(key: key);

//   @override
//   State<GenerateNcDetailsScreen> createState() =>
//       _GenerateNcDetailsScreenState();
// }

// class _GenerateNcDetailsScreenState extends State<GenerateNcDetailsScreen> {
//   final GenerateNcController _controller = GenerateNcController();
//   late NcController ncController;
//   final TextEditingController _customChecklistController =
//       TextEditingController();

// // Add to State class fields
//   String? selectedStatus; // holds status selected from bottom sheet
//   String? userType;

// // Add this method to State class
//   void _applyStatusFilter(String? status) {
//     setState(() {
//       selectedStatus = status?.toLowerCase();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //  SAFE CONTROLLER INITIALIZATION
//     if (Get.isRegistered<NcController>()) {
//       ncController = Get.find<NcController>();
//     } else {
//       ncController = Get.put(NcController());
//     }

//     _fetchData();
//     _loadUserRole();
//   }

//   Future<void> _loadUserRole() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userType = prefs.getString(SharedPreference.userType);

//     setState(() {});
//   }

//   Future<void> _fetchData() async {
//     await _controller.fetchAllNcData();
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _customChecklistController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBarWidget(
//         title: AppString.generatencDetails.boldRobotoTextStyle(fontSize: 20),
//       ),
//       floatingActionButton: const CommonBackToHomeButton(),
//       body: SafeArea(
//         child: _buildBody(context, w, h),
//       ),
//     );
//   }

//   Widget _buildImageCard(String? base64Image) {
//     Uint8List? imageBytes;
//     if (base64Image != null && base64Image.isNotEmpty) {
//       try {
//         imageBytes = base64Decode(base64Image);
//       } catch (e) {
//         debugPrint("Error decoding image: $e");
//       }
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       elevation: 5,
//       color: containerColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Image:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8.0),
//             imageBytes != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.memory(
//                       imageBytes,
//                       fit: BoxFit.cover,
//                       height: 150,
//                       width: double.infinity,
//                       errorBuilder: (context, error, stackTrace) {
//                         debugPrint("Error displaying image: $error");
//                         return const Text(
//                           "Error loading image",
//                           style: TextStyle(color: Colors.grey),
//                         );
//                       },
//                     ),
//                   )
//                 : const Text(
//                     "No image data available",
//                     style: TextStyle(color: Colors.red),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context, double w, double h) {
//     final response = _controller.generateNcFetchResponse;

//     if (response.status == Status.LOADING) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (response.status == Status.COMPLETE) {
//       // response.data is expected to be List<FetchNcData>
//       final List<FetchNcData> data = (response.data is List<FetchNcData>)
//           ? (response.data as List<FetchNcData>)
//           : (response.data ?? []).cast<FetchNcData>();

//       if (data.isEmpty) {
//         return const Center(child: Text('No NC data available!'));
//       }

//       // sort latest first (safe comparator)
//       data.sort((FetchNcData a, FetchNcData b) {
//         final int idA = a.ncId ?? 0;
//         final int idB = b.ncId ?? 0;
//         return idB.compareTo(idA);
//       });

//       // Build filteredList from data applying maker search & filter (if enabled)
//       List<FetchNcData> filteredList = List<FetchNcData>.from(data);

//       // Apply NcController filter (if any) — only when maker opened with fromMaker true
//       if (widget.fromMaker == true) {
//         if (ncController.filterIndex != 0) {
//           String? filterValue;
//           switch (ncController.filterIndex) {
//             case 1:
//               filterValue = ncController.selectedTower?.towerName;
//               break;
//             case 2:
//               filterValue = ncController.selectedFlatData?.flatName;
//               break;
//             case 3:
//               filterValue = ncController.selectedFlatActivity?.activityName;
//               break;
//             case 4:
//               filterValue =
//                   ncController.selectedFlatActivityType?.activityTypeName;
//               break;
//             case 5:
//               filterValue = ncController.selectedFlatChecklist?.checklistName;
//               break;
//             case 6:
//               filterValue = ncController.selectedFloorData?.floorName;
//               break;
//             case 7:
//               filterValue = ncController.selectedFloorActivity?.activityName;
//               break;
//             case 8:
//               filterValue = ncController.selectedFloorChecklist?.checklistName;
//               break;
//             default:
//               filterValue = null;
//           }

//           if (filterValue != null && filterValue.trim().isNotEmpty) {
//             final String fLower = filterValue.toLowerCase();
//             filteredList = filteredList.where((nc) {
//               // compare relevant field based on filterIndex
//               switch (ncController.filterIndex) {
//                 case 1:
//                   return (nc.projectTowerName ?? "").toLowerCase() == fLower;
//                 case 2:
//                   return (nc.projectFlatsName ?? "").toLowerCase() == fLower;
//                 case 3:
//                   return (nc.projectActivityName ?? "").toLowerCase() == fLower;
//                 case 4:
//                   return (nc.projectActTypeName ?? "").toLowerCase() == fLower;
//                 case 5:
//                   return (nc.projectCheckLineName ?? "").toLowerCase() ==
//                       fLower;
//                 case 6:
//                   return (nc.projectFloorName ?? "").toLowerCase() == fLower;
//                 case 7:
//                   return (nc.projectActivityName ?? "").toLowerCase() == fLower;
//                 case 8:
//                   return (nc.projectCheckLineName ?? "").toLowerCase() ==
//                       fLower;
//                 default:
//                   return true;
//               }
//             }).toList();
//           }
//         }

//         // Apply search text (searchController is in ncController)
//         final String query = (ncController.searchController.text ?? "").trim();
//         if (query.isNotEmpty) {
//           final String qlower = query.toLowerCase();
//           filteredList = filteredList.where((nc) {
//             return (nc.projectInfoName ?? "").toLowerCase().contains(qlower) ||
//                 (nc.projectTowerName ?? "").toLowerCase().contains(qlower) ||
//                 (nc.projectFloorName ?? "").toLowerCase().contains(qlower) ||
//                 (nc.projectFlatsName ?? "").toLowerCase().contains(qlower) ||
//                 (nc.flagCategory ?? "").toLowerCase().contains(qlower) ||
//                 (nc.projectActivityName ?? "").toLowerCase().contains(qlower);
//           }).toList();
//         }
//       }

//       if (widget.fromMaker == true ||
//           (userType ?? "").trim().toLowerCase() == "approver") {
//         filteredList = filteredList.where((nc) {
//           final status = (nc.status ?? "").toLowerCase();

//           return status == "open" || // NC created by checker
//               status == "submit" || // macker submitted to approver
//               status == "approver_reject"; // approver rejected to maker
//         }).toList();
//       }
//       //10/12
//       // hide closed NC completely from the app....applies to ALL (Maker, Checker, Approver)
//       filteredList = filteredList.where((nc) {
//         final s = (nc.status ?? "").toLowerCase();
//         //return s != "close";
//         //13/12
//         return s != "close" && s != "done";
//       }).toList();
// //=========================>
//       return Column(
//         children: [
//           // SEARCH + FILTER ROW (reuse same UI as NcDetailsScreen)
//           if (widget.fromMaker == true ||
//               (userType ?? "").trim().toLowerCase() == "approver")
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: w * 0.06, vertical: h * 0.015),
//               child: SearchAndFilterRow(
//                 controller: ncController.searchController,
//                 hintText: "Search Parameter",
//                 onChanged: (v) {
//                   setState(() {});
//                 },
//                 onTap: () {
//                   _showStatusBottomSheet(context, data);
//                 },
//               ),
//             ),

//           // show applied filter label only if not null (reuse same logic)
//           if (widget.fromMaker == true &&
//               ncController.filterIndex != 0 &&
//               _filterAppliedValue(ncController) != null)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   "Filter applied for :  "
//                       .boldRobotoTextStyle(fontSize: 15, fontColor: appColor),
//                   Flexible(
//                     child: _filterAppliedValue(ncController)!
//                         .regularRobotoTextStyle(
//                             maxLine: 10,
//                             fontSize: 14,
//                             textAlign: TextAlign.start,
//                             textOverflow: TextOverflow.ellipsis),
//                   ),
//                 ],
//               ).paddingSymmetric(vertical: h * 0.017),
//             ),

//           // NC list
//           //10/12
//           filteredList.isEmpty
//               ? const Expanded(
//                   child: Center(
//                     child: Text(
//                       'No NC data found!',
//                     ),
//                   ),
//                 )
// //============>
//               : Expanded(
//                   child: ListView.builder(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: w * 0.06, vertical: h * 0.02),
//                     itemCount: filteredList.length,
//                     itemBuilder: (context, index) {
//                       final nc = filteredList[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   GenerateNcCompleteDetailsScreen(
//                                 ncId: nc.ncId,
//                                 projectId: nc.projectInfoName,
//                                 towerId: nc.projectTowerName,
//                                 floorId: nc.projectFloorName,
//                                 flatId: nc.projectFlatsName,
//                                 activityId: nc.projectActivityName,
//                                 activityTypeId: nc.projectActTypeName,
//                                 projectCreateDate: nc.projectCreateDate,
//                                 checklistLineId: nc.projectCheckLineName,
//                                 flagCategory: nc.flagCategory,
//                                 initialDescription: nc.description,
//                                 rectifiedImage: nc.rectifiedImages,
//                                 projectResponsible: nc.projectResponsible,
//                                 customChecklistItem: nc.customChecklistItem,
//                                 overallRemarks: nc.overallRemarks,
//                                 closeImage: nc.closeImage,
//                                 approverRemark: nc.approverRemark,
//                                 ncStatus: nc.status,
//                                 //12/12
//                                 approverImages: nc.approverImages,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           elevation: 5,
//                           color: containerColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildDetailRow(
//                                   "Date",
//                                   formatDateSafe(nc.projectCreateDate),
//                                 ),
//                                 _buildDetailRow(
//                                     "Flag Category", nc.flagCategory ?? "NA"),
//                                 _buildDetailRow(
//                                     "Project Name", nc.projectInfoName ?? "NA"),
//                                 _buildDetailRow(
//                                     "Tower Name", nc.projectTowerName ?? "NA"),
//                                 _buildDetailRow("Floor Name",
//                                     nc.projectFloorName ?? "No Floor"),
//                                 _buildDetailRow("Flat Name",
//                                     nc.projectFlatsName ?? "No Flat"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       );
//     } else {
//       return Center(
//         child: Text(
//           response.message ?? 'Something went wrong.',
//           style: const TextStyle(color: Colors.red),
//         ),
//       );
//     }
//   }

//   String? _filterAppliedValue(NcController controller) {
//     switch (controller.filterIndex) {
//       case 1:
//         return controller.selectedTower?.towerName;
//       case 2:
//         return controller.selectedFlatData?.flatName;
//       case 3:
//         return controller.selectedFlatActivity?.activityName;
//       case 4:
//         return controller.selectedFlatActivityType?.activityTypeName;
//       case 5:
//         return controller.selectedFlatChecklist?.checklistName;
//       case 6:
//         return controller.selectedFloorData?.floorName;
//       case 7:
//         return controller.selectedFloorActivity?.activityName;
//       case 8:
//         return controller.selectedFloorChecklist?.checklistName;
//       default:
//         return null;
//     }
//   }

//   Widget _buildDetailRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             "$label: ",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(
//               value?.toString() ?? 'Not Available',
//               textAlign: TextAlign.right,
//               style: TextStyle(color: Colors.grey[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDynamicDate(dynamic date) {
//     if (date == null) return "Not Provided";
//     try {
//       DateTime parsed;
//       if (date is DateTime)
//         parsed = date;
//       else if (date is String)
//         parsed = DateTime.parse(date);
//       else
//         return "Invalid Date";
//       return "${parsed.day}-${parsed.month}-${parsed.year}";
//     } catch (e) {
//       return "Invalid Date";
//     }
//   }

//   void _showStatusBottomSheet(
//     BuildContext context,
//     List<FetchNcData> allNcList,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         final double h = MediaQuery.of(context).size.height;

//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Select Status",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               const SizedBox(height: 12),

//               // maker button
//               if (widget.fromMaker == true)
//                 _approverRejectButton(h, context, allNcList),

//               const SizedBox(height: 10),

//               // APPROVER SECTION
//               //10/12
//               // if (userType == "approver") ...[
//               //   _closedNcButton(h, context, allNcList),
//               // ]
//             ],
//           ),
//         );
//       },
//     );
//   }

//   ///
//   Widget _approverRejectButton(
//       double h, BuildContext context, List<FetchNcData> allNcList) {
//     return MaterialButton(
//       onPressed: () {
//         // Close the bottom sheet
//         //  Navigator.pop(context);
//         //23/12
//         Get.back();

//         // Set the state so filtering switches to approver_reject
//         setState(() {
//           selectedStatus = "approver_reject";
//         });

//         // Navigate to ApproverRejectedNcScreen (if you still want to open it)
//         Get.to(
//           () => ApproverRejectedNcScreen(
//             allNcList: allNcList,
//           ),
//         );
//       },
//       color: redColor,
//       height: h * 0.058,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(
//           "Approver Reject",
//           style: TextStyle(
//             fontSize: 16,
//             color: backGroundColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// //
// Widget _closedNcButton(
//   double h,
//   BuildContext context,
//   List<FetchNcData> allNcList,
// ) {
//   return MaterialButton(
//     onPressed: () {
//       //  Navigator.pop(context);
//       //23/12
//       Get.back();

//       // Filter only closed NCs
//       List<FetchNcData> closedList = allNcList.where((nc) {
//         return (nc.status ?? "").toLowerCase() == "close";
//       }).toList();
//       //10/12
//       // Get.to(() => ApproverClosedNcScreen(allNcList: closedList));
//     },
//     color: Colors.green,
//     height: h * 0.058,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: const Center(
//       child: Text(
//         "Closed NC",
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }

// // // SAFE DATE PARSING FIX

// String formatDateSafe(dynamic date) {
//   if (date == null) return "Not Provided";

//   try {
//     DateTime parsed;

//     // If already DateTime → use it directly
//     if (date is DateTime) {
//       parsed = date;
//     }
//     // If String → parse it
//     else if (date is String) {
//       parsed = DateTime.parse(date);
//     }
//     // Unknown type
//     else {
//       return "Invalid Date";
//     }

//     return "${parsed.day}-${parsed.month}-${parsed.year}";
//   } catch (e) {
//     return "Invalid Date";
//   }
// }

//UPDATED THIS FILE FOR SOLVE WHITE SCREEN ISSUE 30/12
// generate_nc_details_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/approver_rejected_nc_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:jhamtani_app/View/Widgets/search_filter_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateNcDetailsScreen extends StatefulWidget {
  final String? projectId;
  final String? towerId;
  final String? floorId;
  final String? flatId;
  final String? projectResponsible;
  final String? activityTypeId;
  final String? activityId;
  final String? description;
  final Uint8List? rectifiedImage;
  final String? projectCreateDate;
  final String? customChecklistItem;

  final bool fromMaker; // show search & filter only when true

  const GenerateNcDetailsScreen({
    Key? key,
    this.projectId,
    this.towerId,
    this.floorId,
    this.flatId,
    this.projectResponsible,
    this.activityTypeId,
    this.activityId,
    this.description,
    this.rectifiedImage,
    this.projectCreateDate,
    this.customChecklistItem,
    this.fromMaker = false,
  }) : super(key: key);

  @override
  State<GenerateNcDetailsScreen> createState() =>
      _GenerateNcDetailsScreenState();
}

class _GenerateNcDetailsScreenState extends State<GenerateNcDetailsScreen> {
  final GenerateNcController _controller = GenerateNcController();
  late NcController ncController;
  final TextEditingController _customChecklistController =
      TextEditingController();

  String? selectedStatus;
  String? userType;

  //  NEW: Track initial load state
  bool _isInitializing = true;

  void _applyStatusFilter(String? status) {
    setState(() {
      selectedStatus = status?.toLowerCase();
    });
  }

  @override
  void initState() {
    super.initState();

    // SAFE CONTROLLER INITIALIZATION
    if (Get.isRegistered<NcController>()) {
      ncController = Get.find<NcController>();
    } else {
      ncController = Get.put(NcController());
    }

    //  CRITICAL FIX: Initialize data properly
    _initializeScreen();
  }

  //  NEW: Proper async initialization
  Future<void> _initializeScreen() async {
    try {
      // Load both operations in parallel
      await Future.wait([
        _fetchData(),
        _loadUserRole(),
      ]);
    } catch (e) {
      debugPrint("Error initializing screen: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString(SharedPreference.userType);
  }

  Future<void> _fetchData() async {
    await _controller.fetchAllNcData();
  }

  @override
  void dispose() {
    _customChecklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarWidget(
         backGroundColor: const Color(0xFF3498DB),
        title: AppString.generatencDetails.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      floatingActionButton: const CommonBackToHomeButton(),
      body: SafeArea(
        // ✅ CRITICAL FIX: Show loading during initialization
        child: _isInitializing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildBody(context, w, h),
      ),
    );
  }

  Widget _buildImageCard(String? base64Image) {
    Uint8List? imageBytes;
    if (base64Image != null && base64Image.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image);
      } catch (e) {
        debugPrint("Error decoding image: $e");
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      color: containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Image:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint("Error displaying image: $error");
                        return const Text(
                          "Error loading image",
                          style: TextStyle(color: Colors.grey),
                        );
                      },
                    ),
                  )
                : const Text(
                    "No image data available",
                    style: TextStyle(color: Colors.red),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double w, double h) {
    final response = _controller.generateNcFetchResponse;

    if (response.status == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (response.status == Status.COMPLETE) {
      final List<FetchNcData> data = (response.data is List<FetchNcData>)
          ? (response.data as List<FetchNcData>)
          : (response.data ?? []).cast<FetchNcData>();

      if (data.isEmpty) {
        return const Center(child: Text('No NC data available!'));
      }

      data.sort((FetchNcData a, FetchNcData b) {
        final int idA = a.ncId ?? 0;
        final int idB = b.ncId ?? 0;
        return idB.compareTo(idA);
      });

      List<FetchNcData> filteredList = List<FetchNcData>.from(data);

      if (widget.fromMaker == true) {
        if (ncController.filterIndex != 0) {
          String? filterValue;
          switch (ncController.filterIndex) {
            case 1:
              filterValue = ncController.selectedTower?.towerName;
              break;
            case 2:
              filterValue = ncController.selectedFlatData?.flatName;
              break;
            case 3:
              filterValue = ncController.selectedFlatActivity?.activityName;
              break;
            case 4:
              filterValue =
                  ncController.selectedFlatActivityType?.activityTypeName;
              break;
            case 5:
              filterValue = ncController.selectedFlatChecklist?.checklistName;
              break;
            case 6:
              filterValue = ncController.selectedFloorData?.floorName;
              break;
            case 7:
              filterValue = ncController.selectedFloorActivity?.activityName;
              break;
            case 8:
              filterValue = ncController.selectedFloorChecklist?.checklistName;
              break;
            default:
              filterValue = null;
          }

          if (filterValue != null && filterValue.trim().isNotEmpty) {
            final String fLower = filterValue.toLowerCase();
            filteredList = filteredList.where((nc) {
              switch (ncController.filterIndex) {
                case 1:
                  return (nc.projectTowerName ?? "").toLowerCase() == fLower;
                case 2:
                  return (nc.projectFlatsName ?? "").toLowerCase() == fLower;
                case 3:
                  return (nc.projectActivityName ?? "").toLowerCase() == fLower;
                case 4:
                  return (nc.projectActTypeName ?? "").toLowerCase() == fLower;
                case 5:
                  return (nc.projectCheckLineName ?? "").toLowerCase() ==
                      fLower;
                case 6:
                  return (nc.projectFloorName ?? "").toLowerCase() == fLower;
                case 7:
                  return (nc.projectActivityName ?? "").toLowerCase() == fLower;
                case 8:
                  return (nc.projectCheckLineName ?? "").toLowerCase() ==
                      fLower;
                default:
                  return true;
              }
            }).toList();
          }
        }

        final String query = (ncController.searchController.text ?? "").trim();
        if (query.isNotEmpty) {
          final String qlower = query.toLowerCase();
          filteredList = filteredList.where((nc) {
            return (nc.projectInfoName ?? "").toLowerCase().contains(qlower) ||
                (nc.projectTowerName ?? "").toLowerCase().contains(qlower) ||
                (nc.projectFloorName ?? "").toLowerCase().contains(qlower) ||
                (nc.projectFlatsName ?? "").toLowerCase().contains(qlower) ||
                (nc.flagCategory ?? "").toLowerCase().contains(qlower) ||
                (nc.projectActivityName ?? "").toLowerCase().contains(qlower);
          }).toList();
        }
      }

      if (widget.fromMaker == true ||
          (userType ?? "").trim().toLowerCase() == "approver") {
        filteredList = filteredList.where((nc) {
          final status = (nc.status ?? "").toLowerCase();
          return status == "open" ||
              status == "submit" ||
              status == "approver_reject";
        }).toList();
      }

      filteredList = filteredList.where((nc) {
        final s = (nc.status ?? "").toLowerCase();
        return s != "close" && s != "done";
      }).toList();

      return Column(
        children: [
          if (widget.fromMaker == true ||
              (userType ?? "").trim().toLowerCase() == "approver")
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06, vertical: h * 0.015),
              child: SearchAndFilterRow(
                controller: ncController.searchController,
                hintText: "Search Parameter",
                onChanged: (v) {
                  setState(() {});
                },
                onTap: () {
                  _showStatusBottomSheet(context, data);
                },
              ),
            ),
          if (widget.fromMaker == true &&
              ncController.filterIndex != 0 &&
              _filterAppliedValue(ncController) != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Filter applied for :  "
                      .boldRobotoTextStyle(fontSize: 15, fontColor: appColor),
                  Flexible(
                    child: _filterAppliedValue(ncController)!
                        .regularRobotoTextStyle(
                            maxLine: 10,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis),
                  ),
                ],
              ).paddingSymmetric(vertical: h * 0.017),
            ),
          filteredList.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('No NC data found!'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.06, vertical: h * 0.02),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final nc = filteredList[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await

                              ///
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GenerateNcCompleteDetailsScreen(
                                ncId: nc.ncId,
                                projectId: nc.projectInfoName,
                                towerId: nc.projectTowerName,
                                floorId: nc.projectFloorName,
                                flatId: nc.projectFlatsName,
                                activityId: nc.projectActivityName,
                                activityTypeId: nc.projectActTypeName,
                                projectCreateDate: nc.projectCreateDate,
                                checklistLineId: nc.projectCheckLineName,
                                flagCategory: nc.flagCategory,
                                initialDescription: nc.description,
                                rectifiedImage: nc.rectifiedImages,
                                projectResponsible: nc.projectResponsible,
                                customChecklistItem: nc.customChecklistItem,
                                overallRemarks: nc.overallRemarks,
                                closeImage: nc.closeImage,
                                approverRemark: nc.approverRemark,
                                ncStatus: nc.status,
                                approverImages: nc.approverImages,
                              ),
                            ),
                          );

                          if (result != null && result["refresh"] == true) {
                            await _fetchData(); //  THIS WAS MISSING
                            setState(() {});
                          }
//=========================
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5,
                          color: containerColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  "Date",
                                  formatDateSafe(nc.projectCreateDate),
                                ),
                                _buildDetailRow(
                                    "Flag Category", nc.flagCategory ?? "NA"),
                                _buildDetailRow(
                                    "Project Name", nc.projectInfoName ?? "NA"),
                                _buildDetailRow(
                                    "Tower Name", nc.projectTowerName ?? "NA"),
                                _buildDetailRow("Floor Name",
                                    nc.projectFloorName ?? "No Floor"),
                                _buildDetailRow("Flat Name",
                                    nc.projectFlatsName ?? "No Flat"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      );
    } else {
      return Center(
        child: Text(
          response.message ?? 'Something went wrong.',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  String? _filterAppliedValue(NcController controller) {
    switch (controller.filterIndex) {
      case 1:
        return controller.selectedTower?.towerName;
      case 2:
        return controller.selectedFlatData?.flatName;
      case 3:
        return controller.selectedFlatActivity?.activityName;
      case 4:
        return controller.selectedFlatActivityType?.activityTypeName;
      case 5:
        return controller.selectedFlatChecklist?.checklistName;
      case 6:
        return controller.selectedFloorData?.floorName;
      case 7:
        return controller.selectedFloorActivity?.activityName;
      case 8:
        return controller.selectedFloorChecklist?.checklistName;
      default:
        return null;
    }
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not Available',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDynamicDate(dynamic date) {
    if (date == null) return "Not Provided";
    try {
      DateTime parsed;
      if (date is DateTime)
        parsed = date;
      else if (date is String)
        parsed = DateTime.parse(date);
      else
        return "Invalid Date";
      return "${parsed.day}-${parsed.month}-${parsed.year}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  void _showStatusBottomSheet(
    BuildContext context,
    List<FetchNcData> allNcList,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final double h = MediaQuery.of(context).size.height;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 12),
              if (widget.fromMaker == true)
                _approverRejectButton(h, context, allNcList),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _approverRejectButton(
      double h, BuildContext context, List<FetchNcData> allNcList) {
    return MaterialButton(
      onPressed: () {
        Get.back();

        setState(() {
          selectedStatus = "approver_reject";
        });

        Get.to(
          () => ApproverRejectedNcScreen(
            allNcList: allNcList,
          ),
        );
      },
      color: redColor,
      height: h * 0.058,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Approver Reject",
          style: TextStyle(
            fontSize: 16,
            color: backGroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _closedNcButton(
    double h,
    BuildContext context,
    List<FetchNcData> allNcList,
  ) {
    return MaterialButton(
      onPressed: () {
        Get.back();

        List<FetchNcData> closedList = allNcList.where((nc) {
          return (nc.status ?? "").toLowerCase() == "close";
        }).toList();
      },
      color: Colors.green,
      height: h * 0.058,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          "Closed NC",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

String formatDateSafe(dynamic date) {
  if (date == null) return "Not Provided";

  try {
    DateTime parsed;

    if (date is DateTime) {
      parsed = date;
    } else if (date is String) {
      parsed = DateTime.parse(date);
    } else {
      return "Invalid Date";
    }

    return "${parsed.day}-${parsed.month}-${parsed.year}";
  } catch (e) {
    return "Invalid Date";
  }
}
