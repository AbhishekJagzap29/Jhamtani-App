//patn_id 
//name
//activity_type_names 

class GenerateNcByAppActivityTypeResponseModel {
  final List<NcGenerateActivityType> ncgenerateactivitytype; 
  final String status; 

  GenerateNcByAppActivityTypeResponseModel({required this.ncgenerateactivitytype, required this.status});

  factory GenerateNcByAppActivityTypeResponseModel.fromJson(Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['data'] as List<dynamic>; 
    List<NcGenerateActivityType> activity_type_names = list.map((i) => NcGenerateActivityType.fromJson(i)).toList();
    

    return GenerateNcByAppActivityTypeResponseModel(
      ncgenerateactivitytype: activity_type_names, 
      status: status,
    );
  }
}

class NcGenerateActivityType {
  int patn_id;
  String name;

  NcGenerateActivityType({required this.patn_id, required this.name});

  factory NcGenerateActivityType.fromJson(Map<String, dynamic> json) => NcGenerateActivityType(
        patn_id: json["patn_id"],
        name: json['name'] ?? '',
      );
}