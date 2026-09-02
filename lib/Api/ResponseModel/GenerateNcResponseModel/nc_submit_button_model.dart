import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

class SubmitNcDataResponseModel {
  final String status;
  final int? ncId;
  final String? message;
  final SubmitNcData? ncData;

  SubmitNcDataResponseModel({
    required this.status,
    this.ncId,
    this.message,
    this.ncData,
  });

  factory SubmitNcDataResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitNcDataResponseModel(
      status: json['status'] ?? '',
      ncId: json['nc_id'],
      message: json['message'],
      ncData: json['nc_data'] != null
          ? SubmitNcData.fromMap(json['nc_data'])
          : null,
    );
  }
}

class SubmitNcData {
  final int projectId;
  final int towerId;
  final int floorId;
  final int flatId;
  final int projectresId;
  final int activityId;
  final int patnId;
  final int id;
  final String description;
  final String flagCategory;
  final String customChecklistItem;
  final DateTime date;
  File? rectifiedImage;
  final String status;
  final int seq_no;
  bool isNc;
  final String name;

  SubmitNcData({
    required this.projectId,
    required this.towerId,
    required this.floorId,
    required this.flatId,
    required this.projectresId,
    required this.activityId,
    required this.patnId,
    required this.id,
    required this.description,
    required this.flagCategory,
    required this.customChecklistItem,
    required this.date,
    this.rectifiedImage,
    required this.status,
    required this.seq_no,
    required this.isNc,
    required this.name,
  });

  factory SubmitNcData.fromMap(Map<String, dynamic> map) {
    String? rectifiedImagePath = map['rectified_image']?.toString();
    File? rectifiedImage =
        rectifiedImagePath != null ? File(rectifiedImagePath) : null;

    return SubmitNcData(
      projectId: int.tryParse(map['project_id']?.toString() ?? '') ?? 0,
      towerId: int.tryParse(map['tower_id']?.toString() ?? '') ?? 0,
      floorId: int.tryParse(map['floor_id']?.toString() ?? '') ?? 0,
      flatId: int.tryParse(map['flat_id']?.toString() ?? '') ?? 0,
      projectresId: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      activityId: int.tryParse(map['activity_id']?.toString() ?? '') ?? 0,
      patnId: int.tryParse(map['activity_type_id']?.toString() ?? '') ?? 0,
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      flagCategory: map['flag_category']?.toString() ?? '',
      customChecklistItem: map['custom_checklist_item']?.toString() ?? '',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      rectifiedImage: rectifiedImage,
      status: map['status']?.toString() ?? '',
      seq_no: int.tryParse(map['seq_number']?.toString() ?? '') ?? 0,
      isNc: map['isnc'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project_id': projectId,
      'tower_id': towerId,
      'floor_id': floorId,
      'flat_id': flatId,
      'id': projectresId,
      'activity_id': activityId,
      'patn_id': patnId,
      'id': id,
      'name': name,
      'description': description,
      'flag_category': flagCategory,
      'custom_checklist_item': customChecklistItem,
      'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      'rectified_image': rectifiedImage,
      'status': status,
      'seq_no': seq_no,
      'is_nc': isNc,
    };
  }

  String toJson() => json.encode(toMap());

  factory SubmitNcData.fromJson(String source) =>
      SubmitNcData.fromMap(json.decode(source));
}
