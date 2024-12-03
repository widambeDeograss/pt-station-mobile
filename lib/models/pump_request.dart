class PumpRequest {
  String? protocol;
  List<Packets>? packets;
  PumpRequest({this.protocol, this.packets});

  PumpRequest.fromJson(Map<String, dynamic> json) {
    protocol = json['Protocol'];
    if (json['Packets'] != null) {
      packets = <Packets>[];
      json['Packets'].forEach((v) {
        packets!.add(Packets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Protocol'] = protocol;
    if (packets != null) {
      data['Packets'] = packets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packets {
  int? id;
  String? type;
  Data? data;

  Packets({this.id, this.type, this.data});

  Packets.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    type = json['Type'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['Type'] = type;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? pump;

  Data({this.pump});

  Data.fromJson(Map<String, dynamic> json) {
    pump = json['Pump'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Pump'] = pump;
    return data;
  }
}
