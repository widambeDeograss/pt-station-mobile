// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResolveCustomer {
  String? businessName;
  String? address;
  String? tin;
  String? ninBrn;
  String? contactEmail;
  String? legalName;
  String? contactMobile;
  String? contactNumber;
  String? governmentTIN;
  String? taxpayerStatusCode;
  String? taxpayerStatus;
  String? taxPayerType;
  String? taxPayerTypeCode;

  ResolveCustomer(
      {this.businessName,
      this.address,
      this.tin,
      this.ninBrn,
      this.contactEmail,
      this.legalName,
      this.contactMobile,
      this.contactNumber,
      this.governmentTIN,
      this.taxpayerStatusCode,
      this.taxpayerStatus,
      this.taxPayerType,
      this.taxPayerTypeCode});

  ResolveCustomer.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    address = json['address'];
    tin = json['tin'];
    ninBrn = json['ninBrn'];
    contactEmail = json['contactEmail'];
    legalName = json['legalName'];
    contactMobile = json['contactMobile'];
    contactNumber = json['contactNumber'];
    governmentTIN = json['governmentTIN'];
    taxpayerStatusCode = json['taxpayerStatusCode'];
    taxpayerStatus = json['taxpayerStatus'];
    taxPayerType = json['taxPayerType'];
    taxPayerTypeCode = json['taxPayerTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['address'] = this.address;
    data['tin'] = this.tin;
    data['ninBrn'] = this.ninBrn;
    data['contactEmail'] = this.contactEmail;
    data['legalName'] = this.legalName;
    data['contactMobile'] = this.contactMobile;
    data['contactNumber'] = this.contactNumber;
    data['governmentTIN'] = this.governmentTIN;
    data['taxpayerStatusCode'] = this.taxpayerStatusCode;
    data['taxpayerStatus'] = this.taxpayerStatus;
    data['taxPayerType'] = this.taxPayerType;
    data['taxPayerTypeCode'] = this.taxPayerTypeCode;
    return data;
  }

  @override
  String toString() {
    return 'ResolveCustomer(businessName: $businessName, address: $address, tin: $tin, ninBrn: $ninBrn, contactEmail: $contactEmail, legalName: $legalName, contactMobile: $contactMobile, contactNumber: $contactNumber, governmentTIN: $governmentTIN, taxpayerStatusCode: $taxpayerStatusCode, taxpayerStatus: $taxpayerStatus, taxPayerType: $taxPayerType, taxPayerTypeCode: $taxPayerTypeCode)';
  }
}
