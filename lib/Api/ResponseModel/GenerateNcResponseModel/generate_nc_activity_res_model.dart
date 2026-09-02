class GenerateNcByAppActivityResponseModel {
  final List<NcGenerateActivity> ncgenerateactivity; 
  final String status; 

  GenerateNcByAppActivityResponseModel({required this.ncgenerateactivity, required this.status});

  factory GenerateNcByAppActivityResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['data'] as List<dynamic>; 
    List<NcGenerateActivity> activity_list = list.map((i) => NcGenerateActivity.fromJson(i)).toList();
    

    return GenerateNcByAppActivityResponseModel(
      ncgenerateactivity: activity_list, 
      status: status,
    );
  }
}

class NcGenerateActivity {
  int activity_id;
  String name;

  NcGenerateActivity({required this.activity_id, required this.name});

  factory NcGenerateActivity.fromJson(Map<String, dynamic> json) => NcGenerateActivity(
        activity_id: json["activity_id"],
        name: json['name'] ?? '',
      );
}