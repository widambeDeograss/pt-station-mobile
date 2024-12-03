class SalesModel {
  final bool status;
  final SalesMessageModel message;

  SalesModel({required this.status, required this.message});

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      status: json['status'],
      message: SalesMessageModel.fromJson(json['message']),
    );
  }
}

class SalesMessageModel {
  final List<SalesPumpsModel>? pumps;
  final List<SalesReportsModel>? reports;

  SalesMessageModel({required this.pumps, required this.reports});

  factory SalesMessageModel.fromJson(Map<String, dynamic> json) {
    return SalesMessageModel(
        pumps: List.from(json['pumps'])
            .map((item) => SalesPumpsModel.fromJson(item))
            .toList(),
        reports: List.from(json['reports'])
            .map((item) => SalesReportsModel.fromJson(item))
            .toList());
  }
}

class SalesReportsModel {
  final String gradeId;
  final String gradeName;
  final int price;
  final List<dynamic> statistics;

  SalesReportsModel(
      {required this.gradeId,
      required this.gradeName,
      required this.price,
      required this.statistics});

  factory SalesReportsModel.fromJson(Map<String, dynamic> json) {
    return SalesReportsModel(
      gradeId: json['grade_id'].toString(),
      gradeName: json['grade_name'].toString(),
      statistics: json['statistics'],
      price: json['price'],
    );
  }
}

class SalesPumpsModel {
  int? id;
  String? ptsPumpId;
  String? nozzleName;
  String? nozzleId;
  String? nozzleNo;
  String? nozzleSerialNumber;
  String? pumpId;
  String? pumpNo;
  int? grade;
  String? gradeName;
  String? gradeCode;
  String? tankNo;
  String? tankId;
  String? tankName;
  String? controller;
  String? controllerId;
  String? acquisitionEquipmentId;
  String? acquisitionEquipmentNo;
  String? status;
  String? ptsBatteryVoltage;
  String? totalVolume;
  String? totalAmount;
  String? createdAt;
  String? updatedAt;

  SalesPumpsModel(
      {this.id,
      this.ptsPumpId,
      this.nozzleName,
      this.nozzleId,
      this.nozzleNo,
      this.nozzleSerialNumber,
      this.pumpId,
      this.pumpNo,
      this.grade,
      this.gradeName,
      this.gradeCode,
      this.tankNo,
      this.tankId,
      this.tankName,
      this.controller,
      this.controllerId,
      this.acquisitionEquipmentId,
      this.acquisitionEquipmentNo,
      this.status,
      this.ptsBatteryVoltage,
      this.totalVolume,
      this.totalAmount,
      this.createdAt,
      this.updatedAt});

  SalesPumpsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ptsPumpId = json['ptsPumpId'];
    nozzleName = json['nozzleName'];
    nozzleId = json['nozzleId'];
    nozzleNo = json['nozzleNo'];
    nozzleSerialNumber = json['nozzleSerialNumber'];
    pumpId = json['pumpId'];
    pumpNo = json['pumpNo'];
    grade = json['grade'];
    gradeName = json['gradeName'];
    gradeCode = json['gradeCode'];
    tankNo = json['tankNo'];
    tankId = json['tankId'];
    tankName = json['tankName'];
    controller = json['controller'];
    controllerId = json['controllerId'];
    acquisitionEquipmentId = json['acquisitionEquipmentId'];
    acquisitionEquipmentNo = json['acquisitionEquipmentNo'];
    status = json['status'];
    ptsBatteryVoltage = json['ptsBatteryVoltage'];
    totalVolume = json['totalVolume'];
    totalAmount = json['totalAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ptsPumpId'] = this.ptsPumpId;
    data['nozzleName'] = this.nozzleName;
    data['nozzleId'] = this.nozzleId;
    data['nozzleNo'] = this.nozzleNo;
    data['nozzleSerialNumber'] = this.nozzleSerialNumber;
    data['pumpId'] = this.pumpId;
    data['pumpNo'] = this.pumpNo;
    data['grade'] = this.grade;
    data['gradeName'] = this.gradeName;
    data['gradeCode'] = this.gradeCode;
    data['tankNo'] = this.tankNo;
    data['tankId'] = this.tankId;
    data['tankName'] = this.tankName;
    data['controller'] = this.controller;
    data['controllerId'] = this.controllerId;
    data['acquisitionEquipmentId'] = this.acquisitionEquipmentId;
    data['acquisitionEquipmentNo'] = this.acquisitionEquipmentNo;
    data['status'] = this.status;
    data['ptsBatteryVoltage'] = this.ptsBatteryVoltage;
    data['totalVolume'] = this.totalVolume;
    data['totalAmount'] = this.totalAmount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
