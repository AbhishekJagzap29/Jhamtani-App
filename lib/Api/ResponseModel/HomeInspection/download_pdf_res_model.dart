class DownloadPdfResponseModel {
  final bool? success;
  final String? message;
  final String? pdfBase64; 
  DownloadPdfResponseModel({
    this.success,
    this.message,
    this.pdfBase64,
  });

  factory DownloadPdfResponseModel.fromJson(Map<String, dynamic> json) {
    return DownloadPdfResponseModel(
      success: json['success'],
      message: json['message'],
      pdfBase64: json['pdf_base64'], 
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'pdf_base64': pdfBase64,
      };
}