// import 'dart:io';
// //import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

// import 'package:flutter/material.dart';

// class FetchAllNcDataResponseModel {
//   final String status;
//   final List<FetchNcData> fetchNcData;

//   FetchAllNcDataResponseModel(
//       {required this.status, required this.fetchNcData});

//   factory FetchAllNcDataResponseModel.fromJson(Map<String, dynamic> json) {
//     return FetchAllNcDataResponseModel(
//       status: json['status'],
//       fetchNcData:
//           (json['ncs'] as List).map((e) => FetchNcData.fromJson(e)).toList(),
//     );
//   }
// }

// class FetchNcData {
//   int? ncId;
//   int? projectInfoId;
//   int? projectTowerId;
//   int? projectFloorId;
//   int? projectFlatsId;
//   int? projectActivityId;
//   int? projectActTypeId;
//   int? projectCheckLineId;
//   String? projectInfoName;
//   String? projectTowerName;
//   String? projectFloorName;
//   String? projectFlatsName;
//   String? projectActivityName;
//   String? projectActTypeName;
//   String? projectCheckLineName;
//   String? projectResponsible;
//   DateTime? projectCreateDate;
//   List<dynamic>? rectifiedImages;
//   String? customChecklistItem;
//   String? description;
//   String? flagCategory;
//   String? overallRemarks;
//   List<dynamic>? closeImage;
//   String? status;
//   String? approverRemark;
//   List<dynamic>? approverImages;

//   FetchNcData({
//     this.ncId,
//     this.projectInfoId,
//     this.projectTowerId,
//     this.projectFloorId,
//     this.projectFlatsId,
//     this.projectActivityId,
//     this.projectActTypeId,
//     this.projectCheckLineId,
//     this.projectInfoName,
//     this.projectTowerName,
//     this.projectFloorName,
//     this.projectActTypeName,
//     this.projectActivityName,
//     this.projectCheckLineName,
//     this.projectFlatsName,
//     this.projectResponsible,
//     this.projectCreateDate,
//     this.description,
//     this.flagCategory,
//     this.rectifiedImages,
//     this.customChecklistItem,
//     this.overallRemarks,
//     this.closeImage,
//     this.status, // <-- backend status
//     this.approverRemark,
//     this.approverImages,
//   });

//   FetchNcData.fromJson(Map<String, dynamic> json) {
//     ncId = _parseInt(json['nc_id']);
//     projectInfoId = _parseInt(json['project_info_id']);
//     projectTowerId = _parseInt(json['project_tower_id']);
//     projectFloorId = _parseInt(json['project_floor_id']);
//     projectFlatsId = _parseInt(json['project_flats_id']);
//     projectActivityId = _parseInt(json['project_activity_id']);
//     projectActTypeId = _parseInt(json['project_act_type_id']);
//     projectCheckLineId = _parseInt(json['project_check_line_id']);
//     projectInfoName = _parseString(json['project_info_name']);
//     projectTowerName = _parseString(json['project_tower_name']);
//     projectFloorName = _parseString(json['project_floor_name']);
//     projectActTypeName = _parseString(json['project_act_type_name']);
//     projectFlatsName = _parseString(json['project_flats_name']);
//     projectActivityName = _parseString(json['project_activity_name']);
//     projectCheckLineName = _parseString(json['project_check_line_name']);
//     projectResponsible = _parseString(json['project_responsible']);
//     flagCategory = _parseString(json['flag_category']);
//     customChecklistItem = _parseString(json['custom_checklist_item']);
//     description = _parseString(json['description']);
//     overallRemarks = _parseString(json['overall_remarks']);
//     status = _parseString(json['status']);
//     approverRemark = _parseString(json['approver_remark']);

//     // Parse rectified images here --Rectified_images
//     if (json['rectified_images'] != null) {
//       rectifiedImages = json['rectified_images'] as List<dynamic>;
//     } else {
//       rectifiedImages = [];
//     }
//     //close images
//     if (json['close_image'] != null) {
//       if (json['close_image'] is List) {
//         closeImage = json['close_image'];
//       } else {
//         closeImage = [];
//       }
//     } else {
//       closeImage = [];
//     }
// //approver reject  images
//     if (json['approver_image'] != null && json['approver_image'] is List) {
//       approverImages = (json['approver_image'] as List)
//           .map((e) => e is Map<String, dynamic> ? e : {})
//           .toList();
//     } else {
//       approverImages = [];
//     }

//     projectCreateDate =
//         DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now();
//   }

//   int? _parseInt(dynamic value) {
//     try {
//       if (value is int) {
//         return value;
//       } else if (value is String) {
//         return int.tryParse(value);
//       } else if (value is bool) {
//         return value ? 1 : 0;
//       }
//     } catch (e) {
//       print('Error parsing int: $value');
//     }
//     return null;
//   }

//   String? _parseString(dynamic value) {
//     if (value is String) {
//       return value;
//     } else if (value is bool) {
//       return value ? 'true' : 'false';
//     } else if (value != null) {
//       return value.toString();
//     }
//     return null;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'nc_id': ncId,
//       'project_info_id': projectInfoId,
//       'project_tower_id': projectTowerId,
//       'project_floor_id': projectFloorId,
//       'project_flats_id': projectFlatsId,
//       'project_activity_id': projectActivityId,
//       'project_act_type_id': projectActTypeId,
//       'project_check_line_id': projectCheckLineId,
//       'project_info_name': projectInfoName,
//       'project_tower_name': projectTowerName,
//       'project_floor_name': projectFloorName,
//       'project_flats_name': projectFlatsName,
//       'project_act_type_name': projectActTypeName,
//       'project_activity_name': projectActivityName,
//       'project_check_line_name': projectCheckLineName,
//       'project_responsible': projectResponsible,
//       'projectCreateDate': projectCreateDate,
//       'description': description,
//       'flag_category': flagCategory,
//       'rectified_images': rectifiedImages,
//       'custom_checklist_item': customChecklistItem,
//       'overall_remarks': overallRemarks,
//       'close_image': closeImage,
//       'status': status,
//       'approver_remark': approverRemark,
//       'approver_image': approverImages,
//     };
//   }
// }

//UPDATED 15/12
import 'dart:io';
import 'package:flutter/material.dart';

class FetchAllNcDataResponseModel {
  final String status;
  final List<FetchNcData> fetchNcData;

  FetchAllNcDataResponseModel({
    required this.status,
    required this.fetchNcData,
  });

  factory FetchAllNcDataResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchAllNcDataResponseModel(
      status: json['status'],
      fetchNcData:
          (json['ncs'] as List).map((e) => FetchNcData.fromJson(e)).toList(),
    );
  }
}

class FetchNcData {
  int? ncId;
  int? projectInfoId;
  int? projectTowerId;
  int? projectFloorId;
  int? projectFlatsId;
  int? projectActivityId;
  int? projectActTypeId;
  int? projectCheckLineId;

  String? projectInfoName;
  String? projectTowerName;
  String? projectFloorName;
  String? projectFlatsName;
  String? projectActivityName;
  String? projectActTypeName;
  String? projectCheckLineName;
  String? projectResponsible;

  DateTime? projectCreateDate;

  List<dynamic>? rectifiedImages;
  List<dynamic>? closeImage;

  String? customChecklistItem;
  String? description;
  String? flagCategory;
  String? overallRemarks;
  String? status;
  String? approverRemark;

  /// EXISTING (DO NOT REMOVE)
  List<dynamic>? approverImages;

  /// EXISTING (DO NOT REMOVE)
  List<dynamic>? approverCloseImages;

  FetchNcData({
    this.ncId,
    this.projectInfoId,
    this.projectTowerId,
    this.projectFloorId,
    this.projectFlatsId,
    this.projectActivityId,
    this.projectActTypeId,
    this.projectCheckLineId,
    this.projectInfoName,
    this.projectTowerName,
    this.projectFloorName,
    this.projectFlatsName,
    this.projectActivityName,
    this.projectActTypeName,
    this.projectCheckLineName,
    this.projectResponsible,
    this.projectCreateDate,
    this.description,
    this.flagCategory,
    this.rectifiedImages,
    this.customChecklistItem,
    this.overallRemarks,
    this.closeImage,
    this.status,
    this.approverRemark,
    this.approverImages,
    this.approverCloseImages,
  });

  FetchNcData.fromJson(Map<String, dynamic> json) {
    ncId = _parseInt(json['nc_id']);
    projectInfoId = _parseInt(json['project_info_id']);
    projectTowerId = _parseInt(json['project_tower_id']);
    projectFloorId = _parseInt(json['project_floor_id']);
    projectFlatsId = _parseInt(json['project_flats_id']);
    projectActivityId = _parseInt(json['project_activity_id']);
    projectActTypeId = _parseInt(json['project_act_type_id']);
    projectCheckLineId = _parseInt(json['project_check_line_id']);

    projectInfoName = _parseString(json['project_info_name']);
    projectTowerName = _parseString(json['project_tower_name']);
    projectFloorName = _parseString(json['project_floor_name']);
    projectFlatsName = _parseString(json['project_flats_name']);
    projectActivityName = _parseString(json['project_activity_name']);
    projectActTypeName = _parseString(json['project_act_type_name']);
    projectCheckLineName = _parseString(json['project_check_line_name']);
    projectResponsible = _parseString(json['project_responsible']);

    flagCategory = _parseString(json['flag_category']);
    customChecklistItem = _parseString(json['custom_checklist_item']);
    description = _parseString(json['description']);
    overallRemarks = _parseString(json['overall_remarks']);
    status = _parseString(json['status']);
    approverRemark = _parseString(json['approver_remark']);

    // Rectified images
    rectifiedImages =
        json['rectified_images'] != null && json['rectified_images'] is List
            ? json['rectified_images']
            : [];

    // Close images
    closeImage = json['close_image'] != null && json['close_image'] is List
        ? json['close_image']
        : [];

    // ===================== APPROVER IMAGES FIX =====================

    /// When approver CLOSES NC
    if (json['approver_close_img'] != null &&
        json['approver_close_img'] is List &&
        (json['approver_close_img'] as List).isNotEmpty) {
      approverCloseImages = json['approver_close_img'];
      approverImages = json['approver_close_img']; // keep backward usage safe
    }

    /// When approver REJECTS NC
    else if (json['approver_reject_image'] != null &&
        json['approver_reject_image'] is List &&
        (json['approver_reject_image'] as List).isNotEmpty) {
      approverCloseImages = json['approver_reject_image'];
      approverImages = json['approver_reject_image'];
    }

    /// No approver images
    else {
      approverCloseImages = [];
      approverImages = [];
    }

   

    // projectCreateDate =
    //     DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now();
    //05/02/26
    projectCreateDate =
        DateTime.tryParse(json['project_create_date']?.toString() ?? '');
  }

  int? _parseInt(dynamic value) {
    try {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is bool) return value ? 1 : 0;
    } catch (_) {}
    return null;
  }

  String? _parseString(dynamic value) {
    if (value is String) return value;
    if (value is bool) return value ? 'true' : 'false';
    if (value != null) return value.toString();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'nc_id': ncId,
      'project_info_id': projectInfoId,
      'project_tower_id': projectTowerId,
      'project_floor_id': projectFloorId,
      'project_flats_id': projectFlatsId,
      'project_activity_id': projectActivityId,
      'project_act_type_id': projectActTypeId,
      'project_check_line_id': projectCheckLineId,
      'project_info_name': projectInfoName,
      'project_tower_name': projectTowerName,
      'project_floor_name': projectFloorName,
      'project_flats_name': projectFlatsName,
      'project_activity_name': projectActivityName,
      'project_act_type_name': projectActTypeName,
      'project_check_line_name': projectCheckLineName,
      'project_responsible': projectResponsible,
      'projectCreateDate': projectCreateDate,
      'description': description,
      'flag_category': flagCategory,
      'rectified_images': rectifiedImages,
      'custom_checklist_item': customChecklistItem,
      'overall_remarks': overallRemarks,
      'close_image': closeImage,
      'status': status,
      'approver_remark': approverRemark,
      'approver_images': approverImages,
      'approver_close_img': approverCloseImages,
    };
  }
}
