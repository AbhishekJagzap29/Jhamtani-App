import 'dart:convert';

import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/site_visits_res_model.dart';

OfflineHqiFlateResponseModel offlineHqiFlateResponseModelFromJson(String str) =>
    OfflineHqiFlateResponseModel.fromJson(json.decode(str));

String offlineHqiFlateResponseModelToJson(OfflineHqiFlateResponseModel data) =>
    json.encode(data.toJson());

class OfflineHqiFlateResponseModel {
  String? status;
  String? message;
  List<OfflineHQIData>? data;

  OfflineHqiFlateResponseModel({
    this.status,
    this.message,
    this.data,
  });

  OfflineHqiFlateResponseModel copyWith({
    String? status,
    String? message,
    List<OfflineHQIData>? data,
  }) =>
      OfflineHqiFlateResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OfflineHqiFlateResponseModel.fromJson(Map<String, dynamic> json) =>
      OfflineHqiFlateResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<OfflineHQIData>.from(
                json["data"]!.map((x) => OfflineHQIData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class OfflineHQIData {
  int? visitId;
  String? visitName;
  int? projectId;
  String? projectName;
  int? flatId;
  String? flatName;
  int? towerId;
  String? towerName;
  int? sequence;
  String? color;
  int? totalObservationCount;
  int? pendingObservationCount;
  int? completedObservationCount;
  List<OfflineLocationData>? locationData;
  int? checkerCompletedCount;
  int? checkerPendingCount;
  int? makerCompletedCount;
  int? makerPendingCount;
  String? desc;

  OfflineHQIData({
    this.visitId,
    this.visitName,
    this.projectId,
    this.projectName,
    this.flatId,
    this.flatName,
    this.towerId,
    this.towerName,
    this.sequence,
    this.color,
    this.totalObservationCount,
    this.pendingObservationCount,
    this.completedObservationCount,
    this.locationData,
    this.checkerCompletedCount,
    this.checkerPendingCount,
    this.makerCompletedCount,
    this.makerPendingCount,
    this.desc,
  });

  OfflineHQIData copyWith({
    int? visitId,
    String? visitName,
    int? projectId,
    String? projectName,
    int? flatId,
    String? flatName,
    int? towerId,
    String? towerName,
    int? sequence,
    String? color,
    int? totalObservationCount,
    int? pendingObservationCount,
    int? completedObservationCount,
    List<OfflineLocationData>? locationData,
    int? checkerCompletedCount,
    int? checkerPendingCount,
    int? makerCompletedCount,
    int? makerPendingCount,
    String? desc,
  }) =>
      OfflineHQIData(
        visitId: visitId ?? this.visitId,
        visitName: visitName ?? this.visitName,
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
        flatId: flatId ?? this.flatId,
        flatName: flatName ?? this.flatName,
        towerId: towerId ?? this.towerId,
        towerName: towerName ?? this.towerName,
        sequence: sequence ?? this.sequence,
        color: color ?? this.color,
        totalObservationCount:
            totalObservationCount ?? this.totalObservationCount,
        pendingObservationCount:
            pendingObservationCount ?? this.pendingObservationCount,
        completedObservationCount:
            completedObservationCount ?? this.completedObservationCount,
        locationData: locationData ?? this.locationData,
        checkerCompletedCount:
            checkerCompletedCount ?? this.checkerCompletedCount,
        checkerPendingCount: checkerPendingCount ?? this.checkerPendingCount,
        makerCompletedCount: makerCompletedCount ?? this.makerCompletedCount,
        makerPendingCount: makerPendingCount ?? this.makerPendingCount,
        desc: desc ?? this.desc,
      );

  factory OfflineHQIData.fromJson(Map<String, dynamic> json) => OfflineHQIData(
        visitId: json["visit_id"],
        visitName: json["visit_name"],
        projectId: json["project_id"],
        projectName: json["project_name"],
        flatId: json["flat_id"],
        flatName: json["flat_name"],
        towerId: json["tower_id"],
        towerName: json["tower_name"],
        sequence: json["sequence"],
        color: _parseString(json["color"]),
        totalObservationCount: json["total_observation_count"],
        pendingObservationCount: json["pending_observation_count"],
        completedObservationCount: json["completed_observation_count"],
        locationData: json["location_data"] == null
            ? []
            : List<OfflineLocationData>.from(json["location_data"]!
                .map((x) => OfflineLocationData.fromJson(x))),
        checkerCompletedCount: json["checker_completed_count"],
        checkerPendingCount: json["checker_pending_count"],
        makerCompletedCount: json["maker_completed_count"],
        makerPendingCount: json["maker_pending_count"],
        desc: "${json["desc"] ?? ''}",
      );

  Map<String, dynamic> toJson() => {
        "visit_id": visitId,
        "visit_name": visitName,
        "project_id": projectId,
        "project_name": projectName,
        "flat_id": flatId,
        "flat_name": flatName,
        "tower_id": towerId,
        "tower_name": towerName,
        "sequence": sequence,
        "color": color,
        "total_observation_count": totalObservationCount,
        "pending_observation_count": pendingObservationCount,
        "completed_observation_count": completedObservationCount,
        "location_data": locationData == null
            ? []
            : List<dynamic>.from(locationData!.map((x) => x.toJson())),
        "checker_completed_count": checkerCompletedCount,
        "checker_pending_count": checkerPendingCount,
        "maker_completed_count": makerCompletedCount,
        "maker_pending_count": makerPendingCount,
        "desc": desc,
      };
}

String? _parseString(dynamic value) {
  if (value is String) return value;
  if (value is int || value is double || value is bool) {
    return value.toString();
  }
  return null;
}

class OfflineLocationData {
  int? locationId;
  String? locationName;
  String? unitType;
  String? color;
  int? observationCount;
  int? pendingObservationCount;
  int? completedObservationCount;
  int? checkerCompletedCount;
  int? checkerPendingCount;
  int? makerCompletedCount;
  int? makerPendingCount;
  List<OfflineObservationData>? observations;
  String? locationOverallColor;
  bool? activity_type_status;

  OfflineLocationData({
    this.locationId,
    this.locationName,
    this.unitType,
    this.color,
    this.observationCount,
    this.pendingObservationCount,
    this.completedObservationCount,
    this.checkerCompletedCount,
    this.checkerPendingCount,
    this.makerCompletedCount,
    this.makerPendingCount,
    this.observations,
    this.locationOverallColor,
    this.activity_type_status,
  });

  OfflineLocationData copyWith({
    int? locationId,
    String? locationName,
    String? unitType,
    String? color,
    int? observationCount,
    int? pendingObservationCount,
    int? completedObservationCount,
    int? checkerCompletedCount,
    int? checkerPendingCount,
    int? makerCompletedCount,
    int? makerPendingCount,
    List<OfflineObservationData>? observations,
    String? locationOverallColor,
    bool? activity_type_status,
  }) =>
      OfflineLocationData(
        locationId: locationId ?? this.locationId,
        locationName: locationName ?? this.locationName,
        unitType: unitType ?? this.unitType,
        color: color ?? this.color,
        observationCount: observationCount ?? this.observationCount,
        pendingObservationCount:
            pendingObservationCount ?? this.pendingObservationCount,
        completedObservationCount:
            completedObservationCount ?? this.completedObservationCount,
        checkerCompletedCount:
            checkerCompletedCount ?? this.checkerCompletedCount,
        checkerPendingCount: checkerPendingCount ?? this.checkerPendingCount,
        makerCompletedCount: makerCompletedCount ?? this.makerCompletedCount,
        makerPendingCount: makerPendingCount ?? this.makerPendingCount,
        observations: observations ?? this.observations,
        locationOverallColor: locationOverallColor ?? this.locationOverallColor,
        activity_type_status: activity_type_status ?? this.activity_type_status,
      );

  factory OfflineLocationData.fromJson(Map<String, dynamic> json) =>
      OfflineLocationData(
        locationId: json["location_id"],
        locationName: json["location_name"],
        unitType: json["unit_type"],
        color: _parseString(json["color"]),
        observationCount: json["observation_count"],
        pendingObservationCount: json["pending_observation_count"],
        completedObservationCount: json["completed_observation_count"],
        checkerCompletedCount: json["checker_completed_count"],
        checkerPendingCount: json["checker_pending_count"],
        makerCompletedCount: json["maker_completed_count"],
        makerPendingCount: json["maker_pending_count"],
        observations: json["observations"] == null
            ? []
            : List<OfflineObservationData>.from(json["observations"]!
                .map((x) => OfflineObservationData.fromJson(x))),
        locationOverallColor: _parseString(json["location_overall_color"]),
        activity_type_status: json["activity_type_status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "location_name": locationName,
        "unit_type": unitType,
        "color": color,
        "observation_count": observationCount,
        "pending_observation_count": pendingObservationCount,
        "completed_observation_count": completedObservationCount,
        "checker_completed_count": checkerCompletedCount,
        "checker_pending_count": checkerPendingCount,
        "maker_completed_count": makerCompletedCount,
        "maker_pending_count": makerPendingCount,
        "observations": observations == null
            ? []
            : List<dynamic>.from(observations!.map((x) => x.toJson())),
        "location_overall_color": locationOverallColor,
        "activity_type_status": activity_type_status,
      };
}

class OfflineObservationData {
  VisitDetails? visitDetails;
  List<ObservationImageData>? imgData;
  int? observationId;
  String? name;
  String? state;
  DateTime? date;
  DateTime? targetDate;
  int? issueCategoryId;
  String? issueCategoryName;
  int? issueTypeId;
  String? issueTypeName;
  String? description;
  String? remark;
  String? impact;
  int? locationId;
  bool? checkerSubmitted;
  bool? makerSubmitted;
  String? color;
  String? locationOverallColor;
  // 🔹 Additional fields from FetchObservationData
  int? projectId;
  int? towerId;
  int? flatId;
  int? userId;
  String? userType;
  int? companyId;
  bool? activity_type_status;
  int? sequence;
  bool? isNewlyAdded;
  bool? isUpdated;
  DateTime? lastModified;
  String? syncStatus;
  String? syncErrorMessage;
  String? observationCategory;
  String? impactType;

  OfflineObservationData({
    this.visitDetails,
    this.imgData,
    this.observationId,
    this.name,
    this.state,
    this.date,
    this.targetDate,
    this.issueCategoryId,
    this.issueCategoryName,
    this.issueTypeId,
    this.issueTypeName,
    this.description,
    this.remark,
    this.impact,
    this.locationId,
    this.checkerSubmitted,
    this.makerSubmitted,
    this.color,
    this.locationOverallColor,
    this.isNewlyAdded,
    this.isUpdated,
    this.lastModified,
    this.syncStatus,
    this.syncErrorMessage,
    this.projectId,
    this.towerId,
    this.flatId,
    this.userId,
    this.userType,
    this.companyId,
    this.activity_type_status,
    this.sequence,
    this.observationCategory,
    this.impactType,
  });

  OfflineObservationData copyWith(
          {VisitDetails? visitDetails,
          List<ObservationImageData>? imgData,
          int? observationId,
          String? name,
          String? state,
          DateTime? date,
          DateTime? targetDate,
          int? issueCategoryId,
          String? issueCategoryName,
          int? issueTypeId,
          String? issueTypeName,
          String? description,
          String? remark,
          String? impact,
          int? locationId,
          bool? checkerSubmitted,
          bool? makerSubmitted,
          String? color,
          String? locationOverallColor,
          bool? isNewlyAdded,
          bool? isUpdated,
          DateTime? lastModified,
          String? syncStatus,
          String? syncErrorMessage,
          int? projectId,
          int? towerId,
          int? flatId,
          int? userId,
          String? userType,
          int? companyId,
          bool? activity_type_status,
          int? sequence,
          String? observationCategory,
          String? impactType}) =>
      OfflineObservationData(
          visitDetails: visitDetails ?? this.visitDetails,
          imgData: imgData ?? this.imgData,
          observationId: observationId ?? this.observationId,
          name: name ?? this.name,
          state: state ?? this.state,
          date: date ?? this.date,
          targetDate: targetDate ?? this.targetDate,
          issueCategoryId: issueCategoryId ?? this.issueCategoryId,
          issueCategoryName: issueCategoryName ?? this.issueCategoryName,
          issueTypeId: issueTypeId ?? this.issueTypeId,
          issueTypeName: issueTypeName ?? this.issueTypeName,
          description: description ?? this.description,
          remark: remark ?? this.remark,
          impact: impact ?? this.impact,
          locationId: locationId ?? this.locationId,
          checkerSubmitted: checkerSubmitted ?? this.checkerSubmitted,
          makerSubmitted: makerSubmitted ?? this.makerSubmitted,
          color: color ?? this.color,
          locationOverallColor:
              locationOverallColor ?? this.locationOverallColor,
          isNewlyAdded: isNewlyAdded ?? this.isNewlyAdded,
          isUpdated: isUpdated ?? this.isUpdated,
          lastModified: lastModified ?? this.lastModified,
          syncStatus: syncStatus ?? this.syncStatus,
          syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
          projectId: projectId ?? this.projectId,
          towerId: towerId ?? this.towerId,
          flatId: flatId ?? this.flatId,
          userId: userId ?? this.userId,
          userType: userType ?? this.userType,
          companyId: companyId ?? this.companyId,
          activity_type_status:
              activity_type_status ?? this.activity_type_status,
          sequence: sequence ?? this.sequence,
          observationCategory: observationCategory ?? this.observationCategory,
          impactType: impactType ?? this.impactType);

  factory OfflineObservationData.fromJson(Map<String, dynamic> json) =>
      OfflineObservationData(
        visitDetails: json["visit_details"] == null
            ? null
            : VisitDetails.fromJson(json["visit_details"]),
        imgData: json["img_data"] == null
            ? []
            : List<ObservationImageData>.from(
                json["img_data"]!.map((x) => ObservationImageData.fromJson(x))),
        observationId: json["observation_id"],
        name: json["name"],
        state: json["state"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        targetDate: json["target_date"] == null
            ? null
            : DateTime.parse(json["target_date"]),
        issueCategoryId: json["issue_category_id"],
        issueCategoryName: json["issue_category_name"],
        issueTypeId: json["issue_type_id"],
        issueTypeName: json["issue_type_name"],
        description: json["description"],
        remark: json["remark"],
        impact: json["impact"],
        locationId: json["location_id"],
        checkerSubmitted: json["checker_submitted"],
        makerSubmitted: json["maker_submitted"],
        color: _parseString(json["color"]),
        locationOverallColor: _parseString(json["location_overall_color"]),
        isNewlyAdded: json["is_newly_added"],
        isUpdated: json["is_updated"],
        lastModified: json["last_modified"] == null
            ? null
            : DateTime.parse(json["last_modified"]),
        syncStatus: json["sync_status"],
        syncErrorMessage: json["sync_error_message"],
        projectId: json["project_id"],
        towerId: json["tower_id"],
        flatId: json["flat_id"],
        userId: json["user_id"],
        userType: json["user_type"],
        companyId: json["company_id"],
        activity_type_status: json["activity_type_status"],
        observationCategory: json["impact_type"],
        sequence: json["sequence"],
        impactType: json["impact_type"],
        // observationCategory: json["observation_category"] ??
        //     json["observation_category_name"] ??
        //     json["condition_rating"],
      );

  Map<String, dynamic> toJson() => {
        "visit_details": visitDetails?.toJson(),
        "img_data": imgData == null
            ? []
            : List<dynamic>.from(imgData!.map((x) => x.toJson())),
        "observation_id": observationId,
        "name": name,
        "state": state,
        "date": date != null
            ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
            : null,
        "target_date": targetDate != null
            ? "${targetDate!.year.toString().padLeft(4, '0')}-${targetDate!.month.toString().padLeft(2, '0')}-${targetDate!.day.toString().padLeft(2, '0')}"
            : null,
        "issue_category_id": issueCategoryId,
        "issue_category_name": issueCategoryName,
        "issue_type_id": issueTypeId,
        "issue_type_name": issueTypeName,
        "description": description,
        "remark": remark,
        "impact": impact,
        "location_id": locationId,
        "checker_submitted": checkerSubmitted,
        "maker_submitted": makerSubmitted,
        "color": color,
        "location_overall_color": locationOverallColor,
        "is_newly_added": isNewlyAdded,
        "is_updated": isUpdated,
        "last_modified": lastModified?.toIso8601String(),
        "sync_status": syncStatus,
        "sync_error_message": syncErrorMessage,
        "project_id": projectId,
        "tower_id": towerId,
        "flat_id": flatId,
        "user_id": userId,
        "user_type": userType,
        "company_id": companyId,
        "activity_type_status": activity_type_status,
        "sequence": sequence,
        "impact_type": impactType,

        // "observation_category": observationCategory,
      };
}

class ObservationImageData {
  final String imgUrl;
  final bool userChecker;
  final int userMaker;
  final String? checkerUploadedImg;
  final String? makerUploadedImg;

  ObservationImageData({
    required this.imgUrl,
    required this.userChecker,
    required this.userMaker,
    this.checkerUploadedImg,
    this.makerUploadedImg,
  });

  factory ObservationImageData.fromJson(Map<String, dynamic> json) =>
      ObservationImageData(
        imgUrl: json['img_url'] ?? '',
        userChecker: json['user_checker'] is bool
            ? json['user_checker']
            : (json['user_checker'] is int ? json['user_checker'] != 0 : false),
        userMaker: json['user_maker'] is int
            ? json['user_maker']
            : (int.tryParse(json['user_maker']?.toString() ?? '') ?? 0),
        checkerUploadedImg: json['checker_img_url'],
        makerUploadedImg: json["maker_img_url"],
      );

  Map<String, dynamic> toJson() => {
        "img_url": imgUrl,
        "user_checker": userChecker,
        "user_maker": userMaker,
        "checker_img_url": checkerUploadedImg,
        "maker_img_url": makerUploadedImg,
      };
}

/*class ObservationImageData {
  final String imgUrl;
  final dynamic userChecker;
  final dynamic userMaker;
  final String? checkerUploadedImg;
  final String? makerUploadedImg;

  ObservationImageData({
    this.imgUrl = '',
    this.userChecker = false,
    this.userMaker = 0,
    this.checkerUploadedImg,
    this.makerUploadedImg,
  });

  ObservationImageData copyWith({
    String? imgUrl,
    bool? userChecker,
    int? userMaker,
    String? checkerUploadedImg,
    String? makerUploadedImg,
  }) {
    return ObservationImageData(
      imgUrl: imgUrl ?? this.imgUrl,
      userChecker: userChecker ?? this.userChecker,
      userMaker: userMaker ?? this.userMaker,
      checkerUploadedImg: checkerUploadedImg ?? this.checkerUploadedImg,
      makerUploadedImg: makerUploadedImg ?? this.makerUploadedImg,
    );
  }

  factory ObservationImageData.fromJson(Map<String, dynamic> json) {
    return ObservationImageData(
      imgUrl: json['img_url'] ?? '',
      userChecker: _parseToBool(json['user_checker']),
      userMaker: _parseToInt(json['user_maker']),
      checkerUploadedImg: json['checker_img_url'],
      makerUploadedImg: json['maker_img_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        "img_url": imgUrl,
        "user_checker": userChecker,
        "user_maker": userMaker,
        "checker_img_url": checkerUploadedImg,
        "maker_img_url": makerUploadedImg,
      };

  static bool _parseToBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is bool) return value ? 1 : 0;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}*/

class VisitDetails {
  String? visitName;
  int? sequence;
  int? visitId;

  VisitDetails({
    this.visitName,
    this.sequence,
    this.visitId,
  });

  VisitDetails copyWith({
    String? visitName,
    int? sequence,
    int? visitId,
  }) =>
      VisitDetails(
        visitName: visitName ?? this.visitName,
        sequence: sequence ?? this.sequence,
        visitId: visitId ?? this.visitId,
      );

  factory VisitDetails.fromJson(Map<String, dynamic> json) => VisitDetails(
        visitName: json["visit_name"],
        sequence: json["sequence"],
        visitId: json["visit_id"],
      );

  Map<String, dynamic> toJson() => {
        "visit_name": visitName,
        "sequence": sequence,
        "visit_id": visitId,
      };
}

///   FlatVisitData class for conversion from OfflineHQIData

class FlatVisitDataOffline {
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

  FlatVisitDataOffline({
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

  // Named constructor for conversion
  FlatVisitDataOffline.fromOffline(OfflineHQIData o)
      : visitId = o.visitId,
        visitName = o.visitName,
        color = o.color?.toString(), // Convert bool to String if needed
        sequence = o.sequence,
        activity_type_status = false, // Default or map if exists
        desc = null, // Provide default or derive from o
        totalObservationCount = o.totalObservationCount,
        pendingObservationCount = o.pendingObservationCount,
        completedObservationCount = o.completedObservationCount,
        checkerCompletedCount = o.checkerCompletedCount,
        checkerPendingCount = o.checkerPendingCount,
        makerCompletedCount = o.makerCompletedCount,
        makerPendingCount = o.makerPendingCount,
        locationData = o.locationData == null
            ? []
            : o.locationData!
                .map((loc) => LocationData(
                      locationId: loc.locationId,
                      unitType: loc.unitType,
                      locationName: loc.locationName,
                      color: loc.color,
                      activity_type_status: false,
                      desc: null,
                      writeDate: null,
                      userId: null,
                      locationobservationCount: loc.observationCount,
                      locationpendingObservationCount:
                          loc.pendingObservationCount,
                      locationcompletedObservationCount:
                          loc.completedObservationCount,
                      checkerCompletedCount: loc.checkerCompletedCount,
                      checkerPendingCount: loc.checkerPendingCount,
                      makerCompletedCount: loc.makerCompletedCount,
                      makerPendingCount: loc.makerPendingCount,
                    ))
                .toList();
}
