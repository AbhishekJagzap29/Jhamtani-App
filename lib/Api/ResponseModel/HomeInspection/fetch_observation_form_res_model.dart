import 'dart:convert';

FetchObservationFromResponseModel fetchObservationFromResponseModelFromJson(String str) =>
    FetchObservationFromResponseModel.fromJson(json.decode(str));

String fetchObservationFromResponseModelToJson(FetchObservationFromResponseModel data) => json.encode(data.toJson());

class FetchObservationFromResponseModel {
  String? status;
  String? message;
  List<FetchObservationData>? data;

  FetchObservationFromResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchObservationFromResponseModel.fromJson(Map<String, dynamic> json) => FetchObservationFromResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FetchObservationData>.from(json["data"].map((x) => FetchObservationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FetchObservationData {
  int? observationId;
  int? locationId;
  int? projectId;
  int? towerId;
  int? flatId;
  int? issueCategoryId;
  int? issueTypeId;
  String? remark;
  String? date;
  String? targetDate;
  int? userId;
  String? userType;
  int? companyId;
  String? state;
  String? description;
  String? issueCategoryName;
  String? issueTypeName;
  bool? activity_type_status;
  String? color;
  String? impact;
  List<ObservationImageData>? imgData;
  int? sequence;
  VisitDetails? visitDetails;
  bool? checkerSubmitted;
  bool? makerSubmitted;
//  String? observationCategory;
  String? impactType;

  FetchObservationData({
    this.observationId,
    this.locationId,
    this.projectId,
    this.towerId,
    this.flatId,
    this.issueCategoryId,
    this.issueTypeId,
    this.remark,
    this.date,
    this.targetDate,
    this.userId,
    this.userType,
    this.companyId,
    this.imgData,
    this.state,
    this.issueCategoryName,
    this.issueTypeName,
    this.description,
    this.activity_type_status,
    this.color,
    this.impact,
    this.sequence,
    this.visitDetails,
    this.checkerSubmitted,
    this.makerSubmitted,
  //  this.observationCategory,
    this.impactType,
  });

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null; // handles bool, null, other types
  }

  static String? _parseString(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) {
      return value.toString();
    }
    return null;
  }

  factory FetchObservationData.fromJson(Map<String, dynamic> json) => FetchObservationData(
        observationId: _parseInt(json["observation_id"]),
        locationId: _parseInt(json["location_id"]),
        issueCategoryId: _parseInt(json["issue_category_id"]),
        issueTypeId: _parseInt(json["issue_type_id"]),
        projectId: json["project_id"],
        towerId: json["tower_id"],
        flatId: json["flat_id"],
        impactType: json["impact_type"],
        issueCategoryName: _parseString(json["issue_category_name"]),
        issueTypeName: _parseString(json["issue_type_name"]),
     //   observationCategory: _parseString(json["observation_category"]),
    // observationCategory:
  //  json["observation_category"] ??
    
   // json["observation_category_name"] ??
    // json["condition_rating"],
        description: _parseString(json["description"]),
        color: _parseString(json["color"]),
        impact: _parseString(json["impact"]),
        remark: json["remark"],
        date: json["date"],
        targetDate: json["target_date"],
        userId: json["user_id"],
        userType: json["user_type"],
        companyId: json["company_id"],
        state: json["state"],
        sequence: json["sequence"],
        imgData: json["img_data"] == null
            ? []
            : List<ObservationImageData>.from(json["img_data"].map((x) => ObservationImageData.fromJson(x))),
        visitDetails: json['visit_details'] != null ? VisitDetails.fromJson(json['visit_details']) : null,
        checkerSubmitted: json["checker_submitted"] ?? false, makerSubmitted: json["maker_submitted"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "observation_id": observationId,
        "location_id": locationId,
        "project_id": projectId,
        "tower_id": towerId,
        "flat_id": flatId,
        "issue_category_id": issueCategoryId,
        "issue_type_id": issueTypeId,
        "remark": remark,
        "date": date,
        "target_date": targetDate,
        "user_id": userId,
        "user_type": userType,
        "company_id": companyId,
        "state": state,
        "issue_category_name": issueCategoryName,
        "issue_type_name": issueTypeName,
        "description": description,
        "impact": impact,
        "sequence": sequence,
        'visit_details': visitDetails?.toJson(),
        "img_data": imgData == null ? [] : List<dynamic>.from(imgData!.map((x) => x.toJson())),
        "checker_submitted": checkerSubmitted,
        "maker_submitted": makerSubmitted,
     //   "observation_category" : observationCategory,
        "impact_type": impactType,
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

  factory ObservationImageData.fromJson(Map<String, dynamic> json) => ObservationImageData(
        imgUrl: json['img_url'] ?? '',
        userChecker: json['user_checker'] is bool
            ? json['user_checker']
            : (json['user_checker'] is int ? json['user_checker'] != 0 : false),
        userMaker:
            json['user_maker'] is int ? json['user_maker'] : (int.tryParse(json['user_maker']?.toString() ?? '') ?? 0),
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

class VisitDetails {
  String? visitName;
  int? sequence;
  int? visitId;

  VisitDetails({
    this.visitName,
    this.sequence,
    this.visitId,
  });

  factory VisitDetails.fromJson(Map<String, dynamic> json) {
    return VisitDetails(
      visitName: json['visit_name'],
      sequence: json['sequence'],
      visitId: json['visit_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_name': visitName,
      'sequence': sequence,
      'visit_id': visitId,
    };
  }
}

/// old code(16-8-2025)
/*
import 'dart:convert';

FetchObservationFromResponseModel fetchObservationFromResponseModelFromJson(String str) =>
    FetchObservationFromResponseModel.fromJson(json.decode(str));

String fetchObservationFromResponseModelToJson(FetchObservationFromResponseModel data) => json.encode(data.toJson());

class FetchObservationFromResponseModel {
  String? status;
  String? message;
  List<FetchObservationData>? data;

  FetchObservationFromResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchObservationFromResponseModel.fromJson(Map<String, dynamic> json) => FetchObservationFromResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FetchObservationData>.from(json["data"].map((x) => FetchObservationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FetchObservationData {
  int? observationId;
  int? locationId;
  int? projectId;
  int? towerId;
  int? flatId;
  int? issueCategoryId;
  int? issueTypeId;
  String? remark;
  String? date;
  String? targetDate;
  int? userId;
  String? userType;
  int? companyId;
  String? state;
  String? description;
  String? issueCategoryName;
  String? issueTypeName;
  bool? activity_type_status;
  String? color;
  String? impact;
  List<ObservationImageData>? imgData;
  int? sequence;
  VisitDetails? visitDetails;
  bool? checkerSubmitted;
  bool? makerSubmitted;

  FetchObservationData({
    this.observationId,
    this.locationId,
    this.projectId,
    this.towerId,
    this.flatId,
    this.issueCategoryId,
    this.issueTypeId,
    this.remark,
    this.date,
    this.targetDate,
    this.userId,
    this.userType,
    this.companyId,
    this.imgData,
    this.state,
    this.issueCategoryName,
    this.issueTypeName,
    this.description,
    this.activity_type_status,
    this.color,
    this.impact,
    this.sequence,
    this.visitDetails,
    this.checkerSubmitted,
    this.makerSubmitted,
  });

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null; // handles bool, null, other types
  }

  static String? _parseString(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) {
      return value.toString();
    }
    return null;
  }

  factory FetchObservationData.fromJson(Map<String, dynamic> json) => FetchObservationData(
        observationId: _parseInt(json["observation_id"]),
        locationId: _parseInt(json["location_id"]),
        issueCategoryId: _parseInt(json["issue_category_id"]),
        issueTypeId: _parseInt(json["issue_type_id"]),

        // observationId: json["observation_id"],
        // locationId: json["location_id"],
        projectId: json["project_id"],
        towerId: json["tower_id"],
        flatId: json["flat_id"],
        ////  issueCategoryId: json["issue_category_id"],
        //  issueTypeId: json["issue_type_id"],

        issueCategoryName: _parseString(json["issue_category_name"]),
        issueTypeName: _parseString(json["issue_type_name"]),
        description: _parseString(json["description"]),
        color: _parseString(json["color"]),
        impact: _parseString(json["impact"]),

        remark: json["remark"],
        date: json["date"],
        targetDate: json["target_date"],
        userId: json["user_id"],
        userType: json["user_type"],
        //  issueCategoryName: json["issue_category_name"],
        // issueTypeName: json["issue_type_name"],
        companyId: json["company_id"],
        state: json["state"],
        //  impact: json["impact"],

        //  description: json["description"],
        sequence: json["sequence"],
        imgData:
            json["img_data"] == null ? [] : List<ObservationImageData>.from(json["img_data"].map((x) => ObservationImageData.fromJson(x))),

        visitDetails: json['visit_details'] != null ? VisitDetails.fromJson(json['visit_details']) : null,
        checkerSubmitted: json["checker_submitted"] ?? false, makerSubmitted: json["maker_submitted"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "observation_id": observationId,
        "location_id": locationId,
        "project_id": projectId,
        "tower_id": towerId,
        "flat_id": flatId,
        "issue_category_id": issueCategoryId,
        "issue_type_id": issueTypeId,
        "remark": remark,
        "date": date,
        "target_date": targetDate,
        "user_id": userId,
        "user_type": userType,
        "company_id": companyId,
        "state": state,
        "issue_category_name": issueCategoryName,
        "issue_type_name": issueTypeName,
        "description": description,
        "impact": impact,
        "sequence": sequence,
        'visit_details': visitDetails?.toJson(),
        "img_data": imgData == null ? [] : List<dynamic>.from(imgData!.map((x) => x.toJson())),
        "checker_submitted": checkerSubmitted,
        "maker_submitted": makerSubmitted,
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

  factory ObservationImageData.fromJson(Map<String, dynamic> json) => ObservationImageData(
        imgUrl: json['img_url'] ?? '',
        userChecker:
            json['user_checker'] is bool ? json['user_checker'] : (json['user_checker'] is int ? json['user_checker'] != 0 : false),
        userMaker: json['user_maker'] is int ? json['user_maker'] : (int.tryParse(json['user_maker']?.toString() ?? '') ?? 0),
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

class VisitDetails {
  String? visitName;
  int? sequence;
  int? visitId;

  VisitDetails({
    this.visitName,
    this.sequence,
    this.visitId,
  });

  factory VisitDetails.fromJson(Map<String, dynamic> json) {
    return VisitDetails(
      visitName: json['visit_name'],
      sequence: json['sequence'],
      visitId: json['visit_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_name': visitName,
      'sequence': sequence,
      'visit_id': visitId,
    };
  }
}
*/
