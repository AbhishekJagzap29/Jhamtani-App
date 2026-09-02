import 'dart:convert';

MultipleObservationToMakerResponseModel
    multipleObservationToMakerResponseModelFromJson(String str) =>
        MultipleObservationToMakerResponseModel.fromJson(json.decode(str));

String multipleObservationToMakerResponseModelToJson(
        MultipleObservationToMakerResponseModel data) =>
    json.encode(data.toJson());

class MultipleObservationToMakerResponseModel {
  String? status;
  int? successCount;
  int? failedCount;
  List<int>? successIds;
  List<FailedRecord>? failedRecords;

  MultipleObservationToMakerResponseModel({
    this.status,
    this.successCount,
    this.failedCount,
    this.successIds,
    this.failedRecords,
  });

  factory MultipleObservationToMakerResponseModel.fromJson(
          Map<String, dynamic> json) =>
      MultipleObservationToMakerResponseModel(
        status: json["status"],
        successCount: json["success_count"],
        failedCount: json["failed_count"],
        successIds: json["success_ids"] != null
            ? List<int>.from(json["success_ids"])
            : [],
        failedRecords: json["failed_records"] != null
            ? List<FailedRecord>.from(
                json["failed_records"].map((x) => FailedRecord.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success_count": successCount,
        "failed_count": failedCount,
        "success_ids": successIds ?? [],
        "failed_records":
            failedRecords?.map((x) => x.toJson()).toList() ?? [],
      };
}

class FailedRecord {
  int? locationId;
  String? message;

  FailedRecord({
    this.locationId,
    this.message,
  });

  factory FailedRecord.fromJson(Map<String, dynamic> json) => FailedRecord(
        locationId: json["location_id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "message": message,
      };
}