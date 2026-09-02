// class ApproverRejectNcResponseModel {
//   String? status;
//   String? message;
//   int? ncId;
  
//   List<dynamic>? approverImages;

//   ApproverRejectNcResponseModel({
//     this.status,
//     this.message,
//     this.ncId,
//     this.approverImages,
//   });

//   ApproverRejectNcResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     ncId = json['nc_id'];

    
//     if (json['nc_data'] != null &&
//         json['nc_data']['approver_image'] != null &&
//         json['nc_data']['approver_image'] is List) {
//       approverImages = (json['nc_data']['approver_image'] as List)
//           .map((e) => e is Map<String, dynamic> ? e : {})
//           .toList();
//     } else {
//       approverImages = [];
//     }

//   }
// }

//UPDATED 15/12
class ApproverRejectNcResponseModel {
  String? status;
  String? message;
  int? ncId;
  List<dynamic> approverImages = [];

  ApproverRejectNcResponseModel({
    this.status,
    this.message,
    this.ncId,
    List<dynamic>? approverImages,
  }) {
    this.approverImages = approverImages ?? [];
  }

  ApproverRejectNcResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    ncId = json['nc_id'];

    if (json['nc_data'] != null) {
      // Approver CLOSE
      if (json['nc_data']['approver_close_img'] != null &&
          json['nc_data']['approver_close_img'] is List) {
        approverImages = json['nc_data']['approver_close_img'];
      }
      //  Approver REJECT
      else if (json['nc_data']['approver_reject_image'] != null &&
          json['nc_data']['approver_reject_image'] is List) {
        approverImages = json['nc_data']['approver_reject_image'];
      }
      //  No images
      else {
        approverImages = [];
      }
    } else {
      approverImages = [];
    }
  }
}
