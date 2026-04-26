class ErrorResponse {
  int statusCode;
  List<String> message;
  String error;

  ErrorResponse(
      {required this.statusCode, required this.message, required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      statusCode: json['statusCode'],
      message: List<String>.from(json['message']),
      error: json['error'],
    );
  }
}
