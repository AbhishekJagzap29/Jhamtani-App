import 'dart:convert';
import 'dart:developer';

NotificationResModel notificationResModelFromJson(String str) =>
    NotificationResModel.fromJson(json.decode(str));

String notificationResModelToJson(NotificationResModel data) =>
    json.encode(data.toJson());

class NotificationResModel {
  String? status;
  String? message;
  List<NotificationData>? notificationData;

  NotificationResModel({
    this.status,
    this.message,
    this.notificationData,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) =>
      NotificationResModel(
        status: json["status"],
        message: json["message"],
        notificationData: json["notification_data"] == null
            ? []
            : List<NotificationData>.from(json["notification_data"]!
                .map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "notification_data": notificationData == null
            ? []
            : List<dynamic>.from(notificationData!.map((x) => x.toJson())),
      };
}

class NotificationData {
  int? id;
  dynamic title;
  DateTime? notificationDt;
  String? redirectId;
  String? seq_no;
  String? detailLine;
  String? checklistStatus;
  String? towerId;
  String? projectId;
  int? locationId;
  String? flatId;

  NotificationData({
    this.id,
    this.title,
    this.notificationDt,
    this.redirectId,
    this.seq_no,
    this.detailLine,
    this.checklistStatus,
    this.towerId,
    this.projectId,
    this.locationId,
    this.flatId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json["id"],
      title: json["title"].toString(),
      notificationDt: json["notification_dt"] == null
          ? null
          : DateTime.parse(json["notification_dt"]),
      redirectId: json["redirect_id"],
      seq_no: (json["seq_no"] ?? 0).toString(),
      detailLine: json["detail_line"] ?? '',
      checklistStatus: json["checklist_status"] ?? '',
      towerId: (json["tower_id"] ?? 0).toString(),
      projectId: (json["project_id"] ?? 0).toString(),
      locationId: json["location_id"] is int ? json["location_id"] : null,
      flatId: json["flat_id"] != null ? (json["flat_id"] ?? 0).toString() : '0',
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notification_dt": notificationDt?.toIso8601String(),
        "redirect_id": redirectId,
        "seq_no": seq_no,
        "detail_line": detailLine,
        "checklist_status": checklistStatus,
        "tower_id": towerId,
        "project_id": projectId,
        "location_id": locationId,
        "flat_id": flatId,
      };
}
