class ErrorResponse {
  String? error;
  String? errorDescription;

  ErrorResponse({this.error, this.errorDescription});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorDescription = json['errorDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['errorDescription'] = this.errorDescription;
    return data;
  }
}
