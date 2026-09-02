class GenerateNcByAppFlatResponseModel {
  final List<NcGenerateFlat> ncgenerateflat; 
  final String status; 

  GenerateNcByAppFlatResponseModel({required this.ncgenerateflat, required this.status});

  factory GenerateNcByAppFlatResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['flats'] as List<dynamic>; 
    List<NcGenerateFlat> flat_data = list.map((i) => NcGenerateFlat.fromJson(i)).toList();
    

    return GenerateNcByAppFlatResponseModel(
      ncgenerateflat: flat_data, 
      status: status,
    );
  }
}

class NcGenerateFlat {
  int flat_id;
  String flat_name;

  NcGenerateFlat({required this.flat_id, required this.flat_name});

  factory NcGenerateFlat.fromJson(Map<String, dynamic> json) => NcGenerateFlat(
        flat_id: json["flat_id"],
        flat_name: json['flat_name'] ?? '',
      );
}
