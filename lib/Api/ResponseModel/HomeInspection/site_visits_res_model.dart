import 'dart:convert';

FlatVisitsResponseModel flatVisitsResponseModelFromJson(String str) =>
    FlatVisitsResponseModel.fromJson(json.decode(str));

String flatVisitsResponseModelToJson(FlatVisitsResponseModel data) =>
    json.encode(data.toJson());

class FlatVisitsResponseModel {
  String? status;
  String? message;
  List<FlatVisitData>? data;

  FlatVisitsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FlatVisitsResponseModel.fromJson(Map<String, dynamic> json) =>
      FlatVisitsResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FlatVisitData>.from(
                json["data"].map((x) => FlatVisitData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FlatVisitData {
  int? visitId;
  String? visitName;
  List<LocationData>? locationData;
  String? color;
  bool? activity_type_status;
  dynamic desc;
  int? sequence;
  int? totalObservationCount;
  int? pendingObservationCount;
  int? completedObservationCount;
  int? checkerCompletedCount;
  int? checkerPendingCount;
  int? makerCompletedCount;
  int? makerPendingCount;

  FlatVisitData({
    this.visitId,
    this.visitName,
    this.locationData,
    this.color,
    this.activity_type_status,
    this.desc,
    this.sequence,
    this.totalObservationCount,
    this.pendingObservationCount,
    this.completedObservationCount,
    this.checkerCompletedCount,
    this.checkerPendingCount,
    this.makerCompletedCount,
    this.makerPendingCount,
  });

  factory FlatVisitData.fromJson(Map<String, dynamic> json) => FlatVisitData(
        visitId: json["visit_id"],
        visitName: json["visit_name"],
        color: json["color"]?.toString(),
        sequence: json["sequence"],
        activity_type_status: json["activity_type_status"] ?? false,
        desc: json["desc"].toString(),
        totalObservationCount: json["total_observation_count"],
        pendingObservationCount: json["pending_observation_count"],
        completedObservationCount: json["completed_observation_count"],
        checkerCompletedCount: json["checker_completed_count"],
        checkerPendingCount: json["checker_pending_count"],
        makerCompletedCount: json["maker_completed_count"],
        makerPendingCount: json["maker_pending_count"],
        locationData: json["location_data"] == null
            ? []
            : List<LocationData>.from(
                json["location_data"].map((x) => LocationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visit_id": visitId,
        "visit_name": visitName,
        "color": color,
        "activity_type_status": activity_type_status,
        "desc": desc,
        "sequence": sequence,
        "total_observation_count": totalObservationCount,
        "pending_observation_count": pendingObservationCount,
        "completed_observation_count": completedObservationCount,
        "checker_completed_count": checkerCompletedCount,
        "checker_pending_count": checkerPendingCount,
        "maker_completed_count": makerCompletedCount,
        "maker_pending_count": makerPendingCount,
        "location_data": locationData == null
            ? []
            : List<dynamic>.from(locationData!.map((x) => x.toJson())),
      };
}

class LocationData {
  int? locationId;
  String? unitType;
  String? locationName;
  String? color;
  bool? activity_type_status;
  dynamic desc;
  DateTime? writeDate;
  int? userId;
  int? locationobservationCount;
  int? locationpendingObservationCount;
  int? locationcompletedObservationCount;
  int? checkerCompletedCount;
  int? checkerPendingCount;
  int? makerCompletedCount;
  int? makerPendingCount;

  LocationData({
    this.locationId,
    this.unitType,
    this.locationName,
    this.color,
    this.activity_type_status,
    this.desc,
    this.writeDate,
    this.userId,
    this.locationcompletedObservationCount,
    this.locationobservationCount,
    this.locationpendingObservationCount,
    this.checkerCompletedCount,
    this.checkerPendingCount,
    this.makerCompletedCount,
    this.makerPendingCount,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        locationId: json["location_id"],
        unitType: json["unit_type"],
        locationName: json["location_name"],
        color: json["color"]?.toString(),
        writeDate: json["write_date"] == null
            ? null
            : DateTime.parse(json["write_date"]),
        activity_type_status: json["activity_type_status"] ?? false,
        desc: json["desc"].toString(),
        userId: json["user_id"],
        locationobservationCount: json["observation_count"],
        locationpendingObservationCount: json["pending_observation_count"],
        locationcompletedObservationCount: json["completed_observation_count"],
        checkerCompletedCount: json["checker_completed_count"],
        checkerPendingCount: json["checker_pending_count"],
        makerCompletedCount: json["maker_completed_count"],
        makerPendingCount: json["maker_pending_count"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "unit_type": unitType,
        "location_name": locationName,
        "color": color,
        "activity_type_status": activity_type_status,
        "desc": desc,
        "write_date": writeDate?.toIso8601String(),
        "user_id": userId,
        "observation_count": locationobservationCount,
        "pending_observation_count": locationpendingObservationCount,
        "completed_observation_count": locationcompletedObservationCount,
        "checker_completed_count": checkerCompletedCount,
        "checker_pending_count": checkerPendingCount,
        "maker_completed_count": makerCompletedCount,
        "maker_pending_count": makerPendingCount,
      };
}
