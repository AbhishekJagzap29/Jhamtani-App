import 'dart:convert';

class GenerateNcCloseStateResponseModel {
  final String status;
  final String? message;
  final CloseStateNc? result;

  GenerateNcCloseStateResponseModel({
    required this.status,
    this.message,
    this.result,
  });

  factory GenerateNcCloseStateResponseModel.fromJson(
      Map<String, dynamic> json) {
    return GenerateNcCloseStateResponseModel(
      status: json['status'] ?? '',
      message: json['message'],
      result: json['result'] != null
          ? json['result'] is List
              ? CloseStateNc.fromMap(json['result'].first)
              : CloseStateNc.fromMap(json['result'])
          : null,
    );
  }
}

class CloseStateNc {
  final int ncId;
  final String description;
  final String image;
  final String status;
  final String customChecklistItem;
  final String overallRemarks;
  

  CloseStateNc({
    required this.ncId,
    required this.description,
    required this.image,
    required this.customChecklistItem,
    required this.status,
    required this.overallRemarks,
  });

  factory CloseStateNc.fromMap(Map<String, dynamic> map) {
    return CloseStateNc(
      ncId: map['nc_id'] ?? 0,
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      customChecklistItem: map[' custom_checklist_item '] ?? '',
      overallRemarks: map['overall_remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nc_id': ncId,
      'description': description,
      'image': image,
      'status': status,
      'custom_checklist_item': customChecklistItem,
      'overall_remarks': overallRemarks,
    };
  }

  String toJson() => json.encode(toMap());

  factory CloseStateNc.fromJson(String source) =>
      CloseStateNc.fromMap(json.decode(source));
}

