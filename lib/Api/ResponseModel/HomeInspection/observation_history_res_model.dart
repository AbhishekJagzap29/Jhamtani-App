import 'dart:convert';

ObservationHistoryModel observationHistoryModelFromJson(String str) =>
    ObservationHistoryModel.fromJson(json.decode(str));

String observationHistoryModelToJson(ObservationHistoryModel data) =>
    json.encode(data.toJson());

class ObservationHistoryModel {
  String? status;
  String? message;
  ObservationHistory? data; 

  ObservationHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory ObservationHistoryModel.fromJson(Map<String, dynamic> json) =>
      ObservationHistoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ObservationHistory.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

// class ObservationHistory {
//   final String? issueCategoryName;
//   final String? issueTypeName;
//   final bool? checkerName;
//   final bool? makerName;
//   final String? lastUpdate;

//   ObservationHistory({
//     this.issueCategoryName,
//     this.issueTypeName,
//     this.checkerName,
//     this.makerName,
//     this.lastUpdate,
//   });

//   factory ObservationHistory.fromJson(Map<String, dynamic> json) {
//     return ObservationHistory(
//       issueCategoryName: json['issue_category_name'],
//       issueTypeName: json['issue_type_name'],
//      // checkerName: json['checker_name'],
//       checkerName: json['checker_name'] is String ? json['checker_name'] : null,
// makerName: json['maker_name'] is String ? json['maker_name'] : null,      lastUpdate: json['last_update'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'issue_category_name': issueCategoryName,
//       'issue_type_name': issueTypeName,
//       'checker_name': checkerName,
//       'maker_name': makerName,
//       'last_update': lastUpdate,
//     };
//   }
// }














class ObservationHistory {
  final String? issueCategoryName;
  final String? issueTypeName;
  final String? checkerName;
  final String? makerName;
  final String? lastUpdate;

  ObservationHistory({
    this.issueCategoryName,
    this.issueTypeName,
    this.checkerName,
    this.makerName,
    this.lastUpdate,
  });

  factory ObservationHistory.fromJson(Map<String, dynamic> json) {
    return ObservationHistory(
      issueCategoryName: json['issue_category_name'],
      issueTypeName: json['issue_type_name'],
      checkerName: json['checker_name'] is String ? json['checker_name'] : null,
      makerName: json['maker_name'] is String ? json['maker_name'] : null,
      lastUpdate: json['last_update'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issue_category_name': issueCategoryName,
      'issue_type_name': issueTypeName,
      'checker_name': checkerName,
      'maker_name': makerName,
      'last_update': lastUpdate,
    };
  }
}








