class YearsModel {
  final bool status;
  final List<String> message;

  YearsModel({required this.status, required this.message});

  factory YearsModel.fromJson(Map<String, dynamic> json) {
    return YearsModel(
        status: json["status"],
        message:
            List<String>.from(json['message']).map((item) => item).toList());
  }
}
