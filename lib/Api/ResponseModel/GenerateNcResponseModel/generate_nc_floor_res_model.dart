class GenerateNcByAppFloorResponseModel {
  final List<NcGenerateFloor> ncgeneratefloor; 
  final String status; 

  GenerateNcByAppFloorResponseModel({required this.ncgeneratefloor, required this.status});

  factory GenerateNcByAppFloorResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['floors'] as List<dynamic>; 
    List<NcGenerateFloor> floor_data = list.map((i) => NcGenerateFloor.fromJson(i)).toList();
    

    return GenerateNcByAppFloorResponseModel(
      ncgeneratefloor: floor_data, 
      status: status,
    );
  }
}

class NcGenerateFloor {
  int floor_id;
  String floor_name;

  NcGenerateFloor({required this.floor_id, required this.floor_name});

  factory NcGenerateFloor.fromJson(Map<String, dynamic> json) => NcGenerateFloor(
        floor_id: json["floor_id"],
        floor_name: json['floor_name'] ?? '',
      );
}
