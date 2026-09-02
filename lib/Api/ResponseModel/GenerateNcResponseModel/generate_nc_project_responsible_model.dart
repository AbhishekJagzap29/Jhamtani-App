class GenerateNcProjectResponsibleTypeResponseModel {
  final List<NcGenerateProjectResponsible> ncGenerateProjectResponsible;
  final String status;

  GenerateNcProjectResponsibleTypeResponseModel(
      {required this.ncGenerateProjectResponsible, required this.status});

  factory GenerateNcProjectResponsibleTypeResponseModel.fromJson(
      Map<String, dynamic> json) {
    var status = json['status'] as String;
    var list = json['responsibles'] as List<dynamic>;
    List<NcGenerateProjectResponsible> partner_data =
        list.map((i) => NcGenerateProjectResponsible.fromJson(i)).toList();

    return GenerateNcProjectResponsibleTypeResponseModel(
      ncGenerateProjectResponsible: partner_data,
      status: status,
    );
  }
}

class NcGenerateProjectResponsible {
  int projectresId;
  String name;

  NcGenerateProjectResponsible(
      {required this.projectresId, required this.name});

  factory NcGenerateProjectResponsible.fromJson(Map<String, dynamic> json) =>
      NcGenerateProjectResponsible(
        projectresId: json["id"],
        name: json['name'] ?? '',
      );
}
