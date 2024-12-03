// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomersModel {
  final bool status;
  final List<CustomersReportsModel> customers; // Change to List

  CustomersModel({required this.status, required this.customers});

  factory CustomersModel.fromJson(dynamic json) {
    return CustomersModel(
      status: json['success'],
      customers: List.from(json['data']) // Handle as List directly
          .map((item) => CustomersReportsModel.fromJson(item))
          .toList(),
    );
  }
}

class CustomersReportsModel {
  int? id;
  String? customerName;
  String? customerType;
  String? tinNumber;
  String? phoneNumber;
  String? mvrn;
  dynamic? volume;
  dynamic? amount;
  int? numberOfTransactions;
  dynamic? createdBy;
  dynamic? createdByName;
  String? createdAt;
  String? updatedAt;

  CustomersReportsModel(
      {this.id,
      this.customerName,
      this.customerType,
      this.tinNumber,
      this.phoneNumber,
      this.mvrn,
      this.volume,
      this.amount,
      this.numberOfTransactions,
      this.createdBy,
      this.createdByName,
      this.createdAt,
      this.updatedAt});

  CustomersReportsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    customerType = json['customerType'];
    tinNumber = json['tinNumber'];
    phoneNumber = json['phoneNumber'];
    mvrn = json['mvrn'];
    volume = json['volume'];
    amount = json['amount'];
    numberOfTransactions = json['numberOfTransactions'];
    createdBy = json['createdBy'];
    createdByName = json['createdByName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerName'] = this.customerName;
    data['customerType'] = this.customerType;
    data['tinNumber'] = this.tinNumber;
    data['phoneNumber'] = this.phoneNumber;
    data['mvrn'] = this.mvrn;
    data['volume'] = this.volume;
    data['amount'] = this.amount;
    data['numberOfTransactions'] = this.numberOfTransactions;
    data['createdBy'] = this.createdBy;
    data['createdByName'] = this.createdByName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'CustomersReportsModel(id: $id, customerName: $customerName, customerType: $customerType, tinNumber: $tinNumber, phoneNumber: $phoneNumber, mvrn: $mvrn, volume: $volume, amount: $amount, numberOfTransactions: $numberOfTransactions, createdBy: $createdBy, createdByName: $createdByName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
