class ApproverCloseNcResponseModel {
  String? status;
  String? message;
  int? ncId;
  String? approverRemark;
  //15/12
  List<dynamic>? approverCloseImages;


  ApproverCloseNcResponseModel({
    this.status,
    this.message,
    this.ncId,
    this.approverRemark,
    this.approverCloseImages,
  });

  ApproverCloseNcResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    ncId = json['nc_id'];
    approverRemark = json['nc_data']?['approver_remark'];
    //15/12
    if (json['nc_data'] != null) {
  if (json['nc_data']['approver_close_img'] != null &&
      json['nc_data']['approver_close_img'] is List) {
    approverCloseImages = json['nc_data']['approver_close_img'];
  } else if (json['nc_data']['approver_reject_image'] != null &&
      json['nc_data']['approver_reject_image'] is List) {
    approverCloseImages = json['nc_data']['approver_reject_image'];
  } else {
    approverCloseImages = [];
  }
}
//==================
  }
}
