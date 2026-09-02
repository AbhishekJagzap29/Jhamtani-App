class CubeTestingModel {
  int? id;
  int? floorId;
  String srNo;
  String cubeId;
  String dateCasting;
  String dateTesting;
  String gradeConcrete;
  double gradeValue;
  int quantity;
  String locationStructure;
  String concreteSource;
  int ageDays;

  double weight1;
  double weight2;
  double weight3;

  double density1;
  double density2;
  double density3;

  double load1;
  double load2;
  double load3;

  double strength1;
  double strength2;
  double strength3;

  double avgStrength;
  double strengthPercent;

  CubeTestingModel({
    this.id,
    this.floorId,
    required this.srNo,
    required this.cubeId,
    required this.dateCasting,
    required this.dateTesting,
    required this.gradeConcrete,
    required this.gradeValue,
    required this.quantity,
    required this.locationStructure,
    required this.concreteSource,
    required this.ageDays,
    required this.weight1,
    required this.weight2,
    required this.weight3,
    required this.density1,
    required this.density2,
    required this.density3,
    required this.load1,
    required this.load2,
    required this.load3,
    required this.strength1,
    required this.strength2,
    required this.strength3,
    required this.avgStrength,
    required this.strengthPercent,
  });

  /// JSON → MODEL
  factory CubeTestingModel.fromJson(Map<String, dynamic> json) {
    return CubeTestingModel(
      id: json['id'],
      floorId: json['floor_id'],
      srNo: json['sr_no'] ?? "",
      cubeId: json['cube_id'] ?? "",
      dateCasting: json['date_casting'] ?? "",
      dateTesting: json['date_testing'] ?? "",
      gradeConcrete: json['grade_concrete'] ?? "",
      gradeValue: (json['grade_value'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      locationStructure: json['location_structure'] ?? "",
      concreteSource: json['concrete_source'] ?? "",
      ageDays: json['age_days'] ?? 0,
      weight1: (json['weight1'] ?? 0).toDouble(),
      weight2: (json['weight2'] ?? 0).toDouble(),
      weight3: (json['weight3'] ?? 0).toDouble(),
      density1: (json['density1'] ?? 0).toDouble(),
      density2: (json['density2'] ?? 0).toDouble(),
      density3: (json['density3'] ?? 0).toDouble(),
      load1: (json['load1'] ?? 0).toDouble(),
      load2: (json['load2'] ?? 0).toDouble(),
      load3: (json['load3'] ?? 0).toDouble(),
      strength1: (json['strength1'] ?? 0).toDouble(),
      strength2: (json['strength2'] ?? 0).toDouble(),
      strength3: (json['strength3'] ?? 0).toDouble(),
      avgStrength: (json['avg_strength'] ?? 0).toDouble(),
      strengthPercent: (json['strength_percent'] ?? 0).toDouble(),
    );
  }

  /// MODEL → JSON (POST API)

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "floor_id": floorId,
      "sr_no": srNo,
      "cube_id": cubeId,
      "date_casting": dateCasting,
      "date_testing": dateTesting,
      "grade_concrete": gradeConcrete,
      "grade_value": gradeValue,
      "quantity": quantity,
      "location_structure": locationStructure,
      "concrete_source": concreteSource,
      "age_days": ageDays,
      "weight1": weight1,
      "weight2": weight2,
      "weight3": weight3,
      "density1": density1,
      "density2": density2,
      "density3": density3,
      "load1": load1,
      "load2": load2,
      "load3": load3,
      "strength1": strength1,
      "strength2": strength2,
      "strength3": strength3,
      "avg_strength": avgStrength,
      "strength_percent": strengthPercent,
    };
  }
}
