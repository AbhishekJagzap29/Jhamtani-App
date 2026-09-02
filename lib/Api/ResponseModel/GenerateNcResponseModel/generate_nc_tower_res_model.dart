class GenerateNcByAppTowerResponseModel {
  final List<NcGenerateTower> ncgeneratetower; 
  final String status; 

  GenerateNcByAppTowerResponseModel({required this.ncgeneratetower, required this.status});

  factory GenerateNcByAppTowerResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['towers'] as List<dynamic>; 
    List<NcGenerateTower> tower_data = list.map((i) => NcGenerateTower.fromJson(i)).toList();
    

    return GenerateNcByAppTowerResponseModel(
      ncgeneratetower: tower_data, 
      status: status,
    );
  }
}

class NcGenerateTower {
  int tower_id;
  String tower_name;
  NcGenerateTower({required this.tower_id, required this.tower_name});

  factory NcGenerateTower.fromJson(Map<String, dynamic> json) => NcGenerateTower(
        tower_id: json["tower_id"],
        tower_name: json['tower_name'] ?? '',
      );
}
