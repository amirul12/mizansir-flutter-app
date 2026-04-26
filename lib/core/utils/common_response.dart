// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) =>
    CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) =>
    json.encode(data.toJson());

class CommonResponseModel {
  int? status;
  bool? success;
  String? message;
  String? errorMessage;
  String? data;

  CommonResponseModel({
    this.status,
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        status: json["status"],
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] != null ? jsonEncode(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
