// ignore_for_file: public_member_api_docs, sort_constructors_first
class PumpList {
  String? protocol;
  List<Packets>? packets;

  PumpList({this.protocol, this.packets});

  PumpList.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() => 'PumpList(protocol: $protocol, packets: $packets)';
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

  @override
  String toString() => 'Packets(id: $id, type: $type, data: $data)';
}

class Data {
  List<Ports>? ports;
  List<Pumps>? pumps;

  Data({this.ports, this.pumps});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Ports'] != null) {
      ports = <Ports>[];
      json['Ports'].forEach((v) {
        ports!.add(Ports.fromJson(v));
      });
    }
    if (json['Pumps'] != null) {
      pumps = <Pumps>[];
      json['Pumps'].forEach((v) {
        pumps!.add(Pumps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (ports != null) {
      data['Ports'] = ports!.map((v) => v.toJson()).toList();
    }
    if (pumps != null) {
      data['Pumps'] = pumps!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => 'Data(ports: $ports, pumps: $pumps)';
}

class Ports {
  int? id;
  int? protocol;
  int? baudRate;

  Ports({this.id, this.protocol, this.baudRate});

  Ports.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    protocol = json['Protocol'];
    baudRate = json['BaudRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['Protocol'] = protocol;
    data['BaudRate'] = baudRate;
    return data;
  }

  @override
  String toString() =>
      'Ports(id: $id, protocol: $protocol, baudRate: $baudRate)';
}

class Pumps {
  int? id;
  int? port;
  int? address;

  Pumps({this.id, this.port, this.address});

  Pumps.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    port = json['Port'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['Port'] = port;
    data['Address'] = address;
    return data;
  }

  @override
  String toString() => 'Pumps(id: $id, port: $port, address: $address)';
}
