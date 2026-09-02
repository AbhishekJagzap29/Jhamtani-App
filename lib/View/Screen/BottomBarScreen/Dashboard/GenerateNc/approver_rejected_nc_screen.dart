//UPDATED CODE 28/11 12.00AM
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:flutter/material.dart';

import 'generated_nc_complete_details_screen.dart';

class ApproverRejectedNcScreen extends StatelessWidget {
  final List<FetchNcData> allNcList;

  ApproverRejectedNcScreen({required this.allNcList});

  @override
  Widget build(BuildContext context) {
    // Filter only NCs rejected by Approver
    final rejectedList = allNcList.where((nc) {
      return (nc.status ?? "").toLowerCase() == "approver_reject";
    }).toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Approver Rejected NCs"),
      // ),
      appBar: AppBarWidget(
                            backGroundColor: const Color(0xFF3498DB),

        title: AppString.generatencDetails.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      body: rejectedList.isEmpty
          ? const Center(child: Text("No approver rejected NCs found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rejectedList.length,
              itemBuilder: (context, index) {
                final nc = rejectedList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GenerateNcCompleteDetailsScreen(
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

                          //  IMPORTANT CHANGES
                          overallRemarks: "", // maker starts fresh
                          closeImage: [], // maker does NOT see old images
                          // approverRemark: "", // clear old reject remark
                          //08/12
                          approverRemark: nc.approverRemark,
                          //13/12
                          approverImages: nc.approverImages,
                          //
                          ncStatus: "approver_reject", // enforce reject mode
                        ),
                      ),
                    );
                  },

                  ///
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
                            _formatDate(nc.projectCreateDate) ?? "NA",
                          ),
                          _buildDetailRow(
                            "Flag Category",
                            nc.flagCategory ?? "NA",
                          ),
                          _buildDetailRow(
                            "Project Name",
                            nc.projectInfoName ?? "NA",
                          ),
                          _buildDetailRow(
                            "Tower Name",
                            nc.projectTowerName ?? "NA",
                          ),
                          _buildDetailRow(
                            "Floor Name",
                            nc.projectFloorName ?? "No Floor",
                          ),
                          _buildDetailRow(
                            "Flat Name",
                            nc.projectFlatsName ?? "No Flat",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// REUSABLE DETAIL ROW

  Widget _buildDetailRow(String label, String value) {
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
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// DATE FORMATTER

  String? _formatDate(dynamic date) {
    if (date == null) return null;
    try {
      DateTime parsed;

      if (date is DateTime) {
        parsed = date;
      } else if (date is String) {
        parsed = DateTime.parse(date);
      } else {
        return null;
      }

      return "${parsed.day}-${parsed.month}-${parsed.year}";
    } catch (e) {
      return null;
    }
  }
}
