class ActivityDataConstModel {
  dynamic floorFlatData;
  dynamic activityData;
  String? activityName;
  String? flatFloorName;
  String? towerName;
  String? activityId;

  ActivityDataConstModel({
    this.floorFlatData,
    this.activityData,
    this.activityName,
    this.flatFloorName,
    this.towerName,
    this.activityId,
  });
}

class ConstDataModel {
  dynamic data;
  String? screen;
  String? flatFloorName;
  String? towerName;
  String? activityName;
  String? activityId;

  ConstDataModel({
    this.data,
    this.screen,
    this.flatFloorName,
    this.towerName,
    this.activityName,
    this.activityId,
  });
}

class TowerIdDataModal {
  String? id;
  String? towerName;

  TowerIdDataModal({this.id, this.towerName});
}
