class ReportsModel {
  final bool status;
  final List<ReportsMessageModel> message;

  ReportsModel({required this.status, required this.message});

  factory ReportsModel.fromJson(Map<String, dynamic> json) {
    return ReportsModel(
        status: json['status'],
        message: List.from(json['message'])
            .map((item) => ReportsMessageModel.fromJson(item))
            .toList());
  }
}

class ReportsMessageModel {
  final int pumpId;
  final String fuelGrade;
  final String volumeSold;
  final String totalAmount;
  final String dateTimeEnd;
  final String transactions;
  final String dateTimeStart;

  ReportsMessageModel({
    required this.pumpId,
    required this.fuelGrade,
    required this.volumeSold,
    required this.totalAmount,
    required this.dateTimeEnd,
    required this.transactions,
    required this.dateTimeStart,
  });

  factory ReportsMessageModel.fromJson(Map<String, dynamic> json) {
    return ReportsMessageModel(
      pumpId: json["pump_id"],
      fuelGrade: json["fuel_grade"],
      volumeSold: json["volume_sold"],
      totalAmount: json["total_amount"],
      dateTimeEnd: json["date_time_end "],
      transactions: json["transactions "],
      dateTimeStart: json["date_time_start"],
    );
  }
}
