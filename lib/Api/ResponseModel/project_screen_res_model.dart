// To parse this JSON data, do
//
//     final assignedProjectResponseModel = assignedProjectResponseModelFromJson(jsonString);

import 'dart:convert';

AssignedProjectResponseModel assignedProjectResponseModelFromJson(String str) =>
    AssignedProjectResponseModel.fromJson(json.decode(str));

String assignedProjectResponseModelToJson(AssignedProjectResponseModel data) => json.encode(data.toJson());

class AssignedProjectResponseModel {
  String? status;
  String? message;
  final List<ProjectDetails>? projectData;

  AssignedProjectResponseModel({
    this.status,
    this.message,
    this.projectData,
  });

  factory AssignedProjectResponseModel.fromJson(Map<String, dynamic> json) => AssignedProjectResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        projectData: json["project_data"] == null
            ? []
            : List<ProjectDetails>.from(json["project_data"]!.map((x) => ProjectDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project_data": projectData == null ? [] : List<dynamic>.from(projectData!.map((x) => x.toJson())),
      };
}

class ProjectDetails {
  String? name;
  String? image;
  String? progress;
  int? projectId;
  int? buId;

  ProjectDetails({
    this.name,
    this.image,
    this.projectId,
    this.progress,
    required this.buId,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
        name: json["name"].toString(),
        image: json["image"].toString(),
        projectId: json["project_id"],
        progress: json["progress"].toString(),
        
  buId: (json["bu_id"] != null && json["bu_id"].toString().isNotEmpty)
            ? int.tryParse(json["bu_id"].toString())
            : null, 
      
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "project_id": projectId,
        "progress": progress,
        "bu_id" : buId,
      };
}
