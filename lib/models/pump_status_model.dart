class PumpStatusModel {
  String? protocol;
  List<Packets>? packets;

  PumpStatusModel({this.protocol, this.packets});

  factory PumpStatusModel.fromJson(Map<String, dynamic> json) {
    return PumpStatusModel(
      protocol: json['Protocol'],
      packets: List.from(json['Packets'])
          .map((item) => Packets.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'Protocol': protocol, 'Packets': packets};
}

class Packets {
  int id;
  Data data;
  String type;

  Packets({required this.id, required this.data, required this.type});

  factory Packets.fromJson(Map<String, dynamic> json) {
    return Packets(
        id: json['Id'], type: json['Type'], data: Data.fromJson(json['Data']));
  }

  Map<String, dynamic> toJson() => {'Id': id, 'Type': type, 'Data': data};
}

class Data {
  dynamic pump;
  dynamic user;
  dynamic nozzle;
  dynamic request;
  dynamic nozzleUp;
  dynamic price = 0;
  dynamic volume = 0;
  dynamic amount = 0;
  dynamic transaction;
  dynamic lastPrice = 0;
  dynamic lastNozzle = 0;
  dynamic lastVolume = 0;
  dynamic lastAmount = 0;
  dynamic lastTransaction;

  Data({
    this.pump,
    this.user,
    this.price,
    this.volume,
    this.amount,
    this.nozzle,
    this.request,
    this.nozzleUp,
    this.lastPrice,
    this.lastNozzle,
    this.lastVolume,
    this.lastAmount,
    this.transaction,
    this.lastTransaction,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      pump: json['Pump'],
      user: json['User'],
      price: json['Price'],
      nozzle: json['Nozzle'],
      request: json['Request'],
      nozzleUp: json['NozzleUp'],
      lastPrice: json['LastPrice'],
      volume: json['Volume'] ?? "0",
      amount: json['Amount'] ?? "0",
      lastNozzle: json['LastNozzle'],
      lastAmount: json['LastAmount'],
      transaction: json['Transaction'],
      lastVolume: json['LastVolume'] ?? "0",
      lastTransaction: json['LastTransaction'],
    );
  }

  Map<String, dynamic> toJson() => {
        "Pump": pump,
        "User": user,
        "Price": price,
        "Nozzle": nozzle,
        "Volume": volume,
        "Amount": amount,
        "Request": request,
        "NozzleUp": nozzleUp,
        "LastPrice": lastPrice,
        "LastNozzle": lastNozzle,
        "LastVolume": lastVolume,
        "LastAmount": lastAmount,
        "Transaction": transaction,
        "LastTransaction": lastTransaction,
      };
}
