class CubeRecordsModel {
  final int id;
  final String srNo;
  final String towerName;
  final String dateCasting;
  final String dateTesting;

  CubeRecordsModel({
    required this.id,
    required this.srNo,
    required this.towerName,
    required this.dateCasting,
    required this.dateTesting,
  });

  factory CubeRecordsModel.fromJson(Map<String, dynamic> json) {
    return CubeRecordsModel(
      id: json['id'] ?? 0,
      srNo: json['sr_no']?.toString() ?? "",
      towerName: json['tower_name']?.toString() ?? "",
      dateCasting: json['date_casting']?.toString() ?? "",
      dateTesting: json['date_testing']?.toString() ?? "",
    );
  }
}