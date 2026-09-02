class GenerateNcByAppActivityTypeChecklistResponseModel {
  final List<NcGenerateActivityTypeChecklist> ncgenerateactivitytypechecklist;
  final String status;

  GenerateNcByAppActivityTypeChecklistResponseModel(
      {required this.ncgenerateactivitytypechecklist, required this.status});

  factory GenerateNcByAppActivityTypeChecklistResponseModel.fromJson(
      Map<String, dynamic> json) {
    var status = json['status'] as String;

    var list = json['data'] as List<dynamic>;
    List<NcGenerateActivityTypeChecklist> checklist_items =
        list.map((i) => NcGenerateActivityTypeChecklist.fromJson(i)).toList();

    return GenerateNcByAppActivityTypeChecklistResponseModel(
      ncgenerateactivitytypechecklist: checklist_items,
      status: status,
    );
  }
}

class NcGenerateActivityTypeChecklist {
  int id;
  String name;

  NcGenerateActivityTypeChecklist({
    required this.id,
    required this.name,
  });

  factory NcGenerateActivityTypeChecklist.fromJson(Map<String, dynamic> json) =>
      NcGenerateActivityTypeChecklist(
        id: json["id"],
        name: json['name'] ?? '',
      );
}