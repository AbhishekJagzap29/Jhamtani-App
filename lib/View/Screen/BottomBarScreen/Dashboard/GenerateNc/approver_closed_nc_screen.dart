// import 'package:flutter/material.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'generated_nc_complete_details_screen.dart';

// class ApproverClosedNcScreen extends StatelessWidget {
//   final List<FetchNcData> allNcList;

//   ApproverClosedNcScreen({required this.allNcList});

//   @override
//   Widget build(BuildContext context) {
//     /// Filter CLOSE status
//     final closedList = allNcList.where((nc) {
//       return (nc.status ?? "").toLowerCase() == "close";
//     }).toList();
//     //03/12
//     // final closedList = allNcList.where((nc) {
//     //   final s = (nc.status ?? "").toLowerCase();
//     //   final r = (nc.approverRemark ?? "").trim();

//     //   //
//     //   return s == "close" || (r.isNotEmpty && r != "rejected" && r != "done.");
//     // }).toList();

//     return Scaffold(
//       appBar: AppBarWidget(
//         title: AppString.generatencDetails.boldRobotoTextStyle(fontSize: 20),
//       ),
//       body: closedList.isEmpty
//           ? const Center(child: Text("No closed NCs found"))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: closedList.length,
//               itemBuilder: (context, index) {
//                 final nc = closedList[index];

//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => GenerateNcCompleteDetailsScreen(
//                           ncId: nc.ncId,
//                           projectId: nc.projectInfoName,
//                           towerId: nc.projectTowerName,
//                           floorId: nc.projectFloorName,
//                           flatId: nc.projectFlatsName,
//                           activityId: nc.projectActivityName,
//                           activityTypeId: nc.projectActTypeName,
//                           projectCreateDate: nc.projectCreateDate,
//                           checklistLineId: nc.projectCheckLineName,
//                           flagCategory: nc.flagCategory,
//                           initialDescription: nc.description,
//                           rectifiedImage: nc.rectifiedImages,
//                           projectResponsible: nc.projectResponsible,
//                           customChecklistItem: nc.customChecklistItem,
//                           overallRemarks: nc.overallRemarks,
//                           closeImage: nc.closeImage,
//                           approverRemark: nc.approverRemark,
//                           ncStatus: nc.status,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 5,
//                     color: containerColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildDetailRow(
//                             "Date",
//                             _formatDate(nc.projectCreateDate) ?? "NA",
//                           ),
//                           _buildDetailRow(
//                               "Flag Category", nc.flagCategory ?? "NA"),
//                           _buildDetailRow(
//                               "Project Name", nc.projectInfoName ?? "NA"),
//                           _buildDetailRow(
//                               "Tower Name", nc.projectTowerName ?? "NA"),
//                           _buildDetailRow(
//                               "Floor Name", nc.projectFloorName ?? "No Floor"),
//                           _buildDetailRow(
//                               "Flat Name", nc.projectFlatsName ?? "No Flat"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   /// Row component (same as rejected screen)
//   Widget _buildDetailRow(String label, String value) {
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
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Date formatter (same logic)
//   String? _formatDate(dynamic date) {
//     if (date == null) return null;
//     try {
//       DateTime parsed;

//       if (date is DateTime) {
//         parsed = date;
//       } else if (date is String) {
//         parsed = DateTime.parse(date);
//       } else {
//         return null;
//       }

//       return "${parsed.day}-${parsed.month}-${parsed.year}";
//     } catch (e) {
//       return null;
//     }
//   }
// }
