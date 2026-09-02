class GenerateNcByAppResponseModel {
  final List<NcGenerate> ncgenerate; 
  final String status; 

  GenerateNcByAppResponseModel({required this.ncgenerate, required this.status});

  factory GenerateNcByAppResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['projects'] as List<dynamic>; 
    List<NcGenerate> project_data = list.map((i) => NcGenerate.fromJson(i)).toList();
    

    return GenerateNcByAppResponseModel(
      ncgenerate: project_data, 
      status: status,
    );
  }
}

class NcGenerate {
  int project_id;
  String project_name;

  NcGenerate({required this.project_id, required this.project_name});

  factory NcGenerate.fromJson(Map<String, dynamic> json) => NcGenerate(
        project_id: json["project_id"],
        project_name: json['project_name'] ?? '',
      );
}
