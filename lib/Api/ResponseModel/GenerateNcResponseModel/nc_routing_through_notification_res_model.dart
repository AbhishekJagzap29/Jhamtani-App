// class NcRoutingThroughNotificationResponseModel {
//   final String status;
//   final NcRoutingThroughNotificationModel nc;

//   NcRoutingThroughNotificationResponseModel({
//     required this.status,
//     required this.nc,
//   });

//   factory NcRoutingThroughNotificationResponseModel.fromJson(
//       Map<String, dynamic> json) {
//     return NcRoutingThroughNotificationResponseModel(
//       status: json['status'] ?? '',
//       nc: NcRoutingThroughNotificationModel.fromJson(json['nc'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'nc': nc.toJson(),
//     };
//   }
// }

// class NcRoutingThroughNotificationModel {
//   final String seqNumber;
//   final int ncId;
//   final int projectInfoId;
//   final String projectInfoName;
//   final int projectTowerId;
//   final String projectTowerName;
//   final int projectFloorId;
//   final String projectFloorName;
//   final int projectFlatsId;
//   final String projectFlatsName;
//   final int projectActivityId;
//   final String projectActivityName;
//   final int projectActTypeId;
//   final String projectActTypeName;
//   final int projectCheckLineId;
//   final String projectCheckLineName;
//   final String customChecklistItem;
//   final String projectCreateDate;
//   final String projectResponsible;
//   final String description;
//   final String flagCategory;
//   final List<dynamic> rectifiedImage;
//   final String status;
//   final String overallRemarks;
//   final List<dynamic> closeImage;
//   final String approverRemark;
//   final List<dynamic> approverImages;

//   NcRoutingThroughNotificationModel({
//     required this.seqNumber,
//     required this.ncId,
//     required this.projectInfoId,
//     required this.projectInfoName,
//     required this.projectTowerId,
//     required this.projectTowerName,
//     required this.projectFloorId,
//     required this.projectFloorName,
//     required this.projectFlatsId,
//     required this.projectFlatsName,
//     required this.projectActivityId,
//     required this.projectActivityName,
//     required this.projectActTypeId,
//     required this.projectActTypeName,
//     required this.projectCheckLineId,
//     required this.projectCheckLineName,
//     required this.customChecklistItem,
//     required this.projectCreateDate,
//     required this.projectResponsible,
//     required this.description,
//     required this.flagCategory,
//     required this.rectifiedImage,
//     required this.status,
//     required this.overallRemarks,
//     required this.closeImage,
//     required this.approverRemark,
//     required this.approverImages,

//   });

//   factory NcRoutingThroughNotificationModel.fromJson(
//       Map<String, dynamic> json) {
//     return NcRoutingThroughNotificationModel(
//       seqNumber: json['seq_number'] ?? '',
//       ncId: json['nc_id'] ?? 0,
//       projectInfoId: json['project_info_id'] ?? 0,
//       projectInfoName: json['project_info_name'] ?? '',
//       projectTowerId: json['project_tower_id'] ?? 0,
//       projectTowerName: json['project_tower_name'] ?? '',
//       projectFloorId: json['project_floor_id'] ?? 0,
//       projectFloorName: json['project_floor_name'] ?? '',
//       projectFlatsId: json['project_flats_id'] ?? 0,
//       projectFlatsName: json['project_flats_name'] ?? '',
//       projectActivityId: json['project_activity_id'] ?? 0,
//       projectActivityName: json['project_activity_name'] ?? '',
//       projectActTypeId: json['project_act_type_id'] ?? 0,
//       projectActTypeName: json['project_act_type_name'] ?? '',
//       projectCheckLineId: json['project_check_line_id'] ?? 0,
//       projectCheckLineName: json['project_check_line_name'] ?? '',
//       customChecklistItem: json['custom_checklist_item'] ?? '',
//       projectCreateDate: json['project_create_date'] ?? '',
//       projectResponsible: json['project_responsible'] ?? '',
//       description: json['description'] ?? '',
//       flagCategory: json['flag_category'] ?? '',
//       rectifiedImage: json['rectified_images'] ?? [],
//       status: json['status'] ?? '',
//       overallRemarks: json['overall_remarks'] ?? '',
//       closeImage: json['close_image'] ?? [],
//       approverRemark: json['approver_remark'] ?? '',
//       approverImages: json['approver_image'] ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'seq_number': seqNumber,
//       'nc_id': ncId,
//       'project_info_id': projectInfoId,
//       'project_info_name': projectInfoName,
//       'project_tower_id': projectTowerId,
//       'project_tower_name': projectTowerName,
//       'project_floor_id': projectFloorId,
//       'project_floor_name': projectFloorName,
//       'project_flats_id': projectFlatsId,
//       'project_flats_name': projectFlatsName,
//       'project_activity_id': projectActivityId,
//       'project_activity_name': projectActivityName,
//       'project_act_type_id': projectActTypeId,
//       'project_act_type_name': projectActTypeName,
//       'project_check_line_id': projectCheckLineId,
//       'project_check_line_name': projectCheckLineName,
//       'custom_checklist_item': customChecklistItem,
//       'project_create_date': projectCreateDate,
//       'project_responsible': projectResponsible,
//       'description': description,
//       'flag_category': flagCategory,
//       'rectified_image': rectifiedImage,
//       'status': status,
//       'overall_remarks': overallRemarks,
//       'close_image': closeImage,
//       'approver_remark': approverRemark,
//       'approver_image': approverImages,

//     };
//   }
// }

//UPDATED 15/12
class NcRoutingThroughNotificationResponseModel {
  final String status;
  final NcRoutingThroughNotificationModel nc;

  NcRoutingThroughNotificationResponseModel({
    required this.status,
    required this.nc,
  });

  factory NcRoutingThroughNotificationResponseModel.fromJson(
      Map<String, dynamic> json) {
    return NcRoutingThroughNotificationResponseModel(
      status: json['status'] ?? '',
      nc: NcRoutingThroughNotificationModel.fromJson(json['nc'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'nc': nc.toJson(),
    };
  }
}

class NcRoutingThroughNotificationModel {
  final String seqNumber;
  final int ncId;
  final int projectInfoId;
  final String projectInfoName;
  final int projectTowerId;
  final String projectTowerName;
  final int projectFloorId;
  final String projectFloorName;
  final int projectFlatsId;
  final String projectFlatsName;
  final int projectActivityId;
  final String projectActivityName;
  final int projectActTypeId;
  final String projectActTypeName;
  final int projectCheckLineId;
  final String projectCheckLineName;
  final String customChecklistItem;
  final String projectCreateDate;
  final String projectResponsible;
  final String description;
  final String flagCategory;

  //06/12
  final List<dynamic> rectifiedImage;
  final String status;
  final String overallRemarks;
  final List<dynamic> closeImage;
  final String approverRemark;
  final List<dynamic> approverImages;
  final List<dynamic> approverCloseImages;

  NcRoutingThroughNotificationModel({
    required this.seqNumber,
    required this.ncId,
    required this.projectInfoId,
    required this.projectInfoName,
    required this.projectTowerId,
    required this.projectTowerName,
    required this.projectFloorId,
    required this.projectFloorName,
    required this.projectFlatsId,
    required this.projectFlatsName,
    required this.projectActivityId,
    required this.projectActivityName,
    required this.projectActTypeId,
    required this.projectActTypeName,
    required this.projectCheckLineId,
    required this.projectCheckLineName,
    required this.customChecklistItem,
    required this.projectCreateDate,
    required this.projectResponsible,
    required this.description,
    required this.flagCategory,
    required this.rectifiedImage,
    required this.status,
    required this.overallRemarks,
    required this.closeImage,
    required this.approverRemark,
    required this.approverImages,
    required this.approverCloseImages,
  });

  factory NcRoutingThroughNotificationModel.fromJson(
      Map<String, dynamic> json) {
    // ONLY FIX: correct approver image mapping
    List<dynamic> _approverImgs = [];

    if (json['approver_close_img'] != null &&
        json['approver_close_img'] is List &&
        (json['approver_close_img'] as List).isNotEmpty) {
      _approverImgs = json['approver_close_img'];
    } else if (json['approver_reject_image'] != null &&
        json['approver_reject_image'] is List &&
        (json['approver_reject_image'] as List).isNotEmpty) {
      _approverImgs = json['approver_reject_image'];
    }

    return NcRoutingThroughNotificationModel(
      seqNumber: json['seq_number'] ?? '',
      ncId: json['nc_id'] ?? 0,
      projectInfoId: json['project_info_id'] ?? 0,
      projectInfoName: json['project_info_name'] ?? '',
      projectTowerId: json['project_tower_id'] ?? 0,
      projectTowerName: json['project_tower_name'] ?? '',
      projectFloorId: json['project_floor_id'] ?? 0,
      projectFloorName: json['project_floor_name'] ?? '',
      projectFlatsId: json['project_flats_id'] ?? 0,
      projectFlatsName: json['project_flats_name'] ?? '',
      projectActivityId: json['project_activity_id'] ?? 0,
      projectActivityName: json['project_activity_name'] ?? '',
      projectActTypeId: json['project_act_type_id'] ?? 0,
      projectActTypeName: json['project_act_type_name'] ?? '',
      projectCheckLineId: json['project_check_line_id'] ?? 0,
      projectCheckLineName: json['project_check_line_name'] ?? '',
      customChecklistItem: json['custom_checklist_item'] ?? '',
      projectCreateDate: json['project_create_date'] ?? '',
      projectResponsible: json['project_responsible'] ?? '',
      description: json['description'] ?? '',
      flagCategory: json['flag_category'] ?? '',
      rectifiedImage: json['rectified_images'] ?? [],
      status: json['status'] ?? '',
      overallRemarks: json['overall_remarks'] ?? '',
      closeImage: json['close_image'] ?? [],
      approverRemark: json['approver_remark'] ?? '',
      approverImages: _approverImgs,
      approverCloseImages: _approverImgs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq_number': seqNumber,
      'nc_id': ncId,
      'project_info_id': projectInfoId,
      'project_info_name': projectInfoName,
      'project_tower_id': projectTowerId,
      'project_tower_name': projectTowerName,
      'project_floor_id': projectFloorId,
      'project_floor_name': projectFloorName,
      'project_flats_id': projectFlatsId,
      'project_flats_name': projectFlatsName,
      'project_activity_id': projectActivityId,
      'project_activity_name': projectActivityName,
      'project_act_type_id': projectActTypeId,
      'project_act_type_name': projectActTypeName,
      'project_check_line_id': projectCheckLineId,
      'project_check_line_name': projectCheckLineName,
      'custom_checklist_item': customChecklistItem,
      'project_create_date': projectCreateDate,
      'project_responsible': projectResponsible,
      'description': description,
      'flag_category': flagCategory,
      'rectified_image': rectifiedImage,
      'status': status,
      'overall_remarks': overallRemarks,
      'close_image': closeImage,
      'approver_remark': approverRemark,
      'approver_image': approverImages,
      'approver_close_img': approverCloseImages,
    };
  }
}
