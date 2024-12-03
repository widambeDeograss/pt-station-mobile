// ignore_for_file: public_member_api_docs, sort_constructors_first
class TransactionModel {
  int? id;
  String? receiptType;
  String? receiptMode;
  String? merchantReference;
  String? invoiceNumber;
  String? invoiceId;
  String? volume;
  dynamic? grossAmount;
  double? netAmount;
  double? taxAmount;
  String? qrCode;
  String? branchName;
  String? branchCode;
  String? pumpNo;
  String? nozzleNo;
  String? unitPrice;
  String? goodsName;
  String? goodsCode;
  String? currency;
  String? status;
  String? buyerLegalName;
  String? buyerBusinessName;
  String? buyerTin;
  String? mvrn;
  String? issuedAt;
  String? issuedBy;
  String? createdAt;

  TransactionModel(
      {this.id,
      this.receiptType,
      this.receiptMode,
      this.merchantReference,
      this.invoiceNumber,
      this.invoiceId,
      this.volume,
      this.grossAmount,
      this.netAmount,
      this.taxAmount,
      this.qrCode,
      this.branchName,
      this.branchCode,
      this.pumpNo,
      this.nozzleNo,
      this.unitPrice,
      this.goodsName,
      this.goodsCode,
      this.currency,
      this.status,
      this.buyerLegalName,
      this.buyerBusinessName,
      this.buyerTin,
      this.mvrn,
      this.issuedAt,
      this.issuedBy,
      this.createdAt});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptType = json['receiptType'];
    receiptMode = json['receiptMode'];
    merchantReference = json['merchantReference'];
    invoiceNumber = json['invoiceNumber'];
    invoiceId = json['invoiceId'];
    volume = json['volume'];
    grossAmount = json['grossAmount'];
    netAmount = json['netAmount'];
    taxAmount = json['taxAmount'];
    qrCode = json['qrCode'];
    branchName = json['branchName'];
    branchCode = json['branchCode'];
    pumpNo = json['pumpNo'];
    nozzleNo = json['nozzleNo'];
    unitPrice = json['unitPrice'];
    goodsName = json['goodsName'];
    goodsCode = json['goodsCode'];
    currency = json['currency'];
    status = json['status'];
    buyerLegalName = json['buyerLegalName'];
    buyerBusinessName = json['buyerBusinessName'];
    buyerTin = json['buyerTin'];
    mvrn = json['mvrn'];
    issuedAt = json['issuedAt'];
    issuedBy = json['issuedBy'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiptType'] = this.receiptType;
    data['receiptMode'] = this.receiptMode;
    data['merchantReference'] = this.merchantReference;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceId'] = this.invoiceId;
    data['volume'] = this.volume;
    data['grossAmount'] = this.grossAmount;
    data['netAmount'] = this.netAmount;
    data['taxAmount'] = this.taxAmount;
    data['qrCode'] = this.qrCode;
    data['branchName'] = this.branchName;
    data['branchCode'] = this.branchCode;
    data['pumpNo'] = this.pumpNo;
    data['nozzleNo'] = this.nozzleNo;
    data['unitPrice'] = this.unitPrice;
    data['goodsName'] = this.goodsName;
    data['goodsCode'] = this.goodsCode;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['buyerLegalName'] = this.buyerLegalName;
    data['buyerBusinessName'] = this.buyerBusinessName;
    data['buyerTin'] = this.buyerTin;
    data['mvrn'] = this.mvrn;
    data['issuedAt'] = this.issuedAt;
    data['issuedBy'] = this.issuedBy;
    data['createdAt'] = this.createdAt;
    return data;
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, receiptType: $receiptType, receiptMode: $receiptMode, merchantReference: $merchantReference, invoiceNumber: $invoiceNumber, invoiceId: $invoiceId, volume: $volume, grossAmount: $grossAmount, netAmount: $netAmount, taxAmount: $taxAmount, qrCode: $qrCode, branchName: $branchName, branchCode: $branchCode, pumpNo: $pumpNo, nozzleNo: $nozzleNo, unitPrice: $unitPrice, goodsName: $goodsName, goodsCode: $goodsCode, currency: $currency, status: $status, buyerLegalName: $buyerLegalName, buyerBusinessName: $buyerBusinessName, buyerTin: $buyerTin, mvrn: $mvrn, issuedAt: $issuedAt, issuedBy: $issuedBy, createdAt: $createdAt)';
  }
}
