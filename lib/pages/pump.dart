import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pts/global_method.dart';
import 'package:pts/models/pump_status_model.dart';
import 'package:pts/models/pumps.dart';
import 'package:pts/notifier/pump_status_notifier.dart';
import 'package:pts/pages/profile.dart';

class PumpScreen extends StatefulWidget {
  const PumpScreen({super.key});
  @override
  State<PumpScreen> createState() => _PumpScreenState();
}

class _PumpScreenState extends State<PumpScreen> {
  late Timer _timer;
  String username = 'admin';
  String password = 'admin';
  List<Map<String, dynamic>> _pumpList = [];
  // String basicAuth = 'Basic cHRzOkFkdmFAb2NoIzE=';
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('admin:admin'));

  pumpList() async {
    final response = await http
        .post(Uri.parse("http://192.168.1.117:500/jsonPTS"),
            headers: <String, String>{'Authorization': basicAuth},
            body: jsonEncode({
              "Protocol": "jsonPTS",
              "Packets": [
                {"Id": 1, "Type": "GetPumpsConfiguration"}
              ]
            }))
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Request Timeout response status code
        return http.Response('Error', 408);
      },
    );
    print(response.body);
    final data = PumpList.fromJson(jsonDecode(response.body));

    var pumps = data.packets![0].data!.pumps!.map((e) => {
          "Id": e.id,
          "Type": "PumpGetStatus",
          "Data": {"Pump": e.id}
        });

    List<Map<String, dynamic>> pumpsList = pumps.map((pump) {
      Map<String, dynamic> pumpMap = {};
      pumpMap['Id'] = pump['Id'];
      pumpMap['Type'] = pump['Type'];
      pumpMap['Data'] = pump['Data'];
      return pumpMap;
    }).toList();

    _pumpList = pumpsList;
  }

  Future pumpStatusRequest(PumpStatusNotifier pumpStatusNotifier) async {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_pumpList.isNotEmpty) {
          final response = await http
              .post(Uri.parse("http://192.168.1.117:500/jsonPTS"),
                  headers: <String, String>{'Authorization': basicAuth},
                  body:
                      jsonEncode({"Protocol": "jsonPTS", "Packets": _pumpList}))
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              return http.Response('Error', 408);
            },
          );
          print(response.body);
          pumpStatusNotifier
              .pumpStatus(PumpStatusModel.fromJson(jsonDecode(response.body)));
        }
      });
    } catch (e) {
      return PumpStatusModel(protocol: "Packets", packets: []);
    }
  }

  @override
  void initState() {
    super.initState();
    pumpList();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PumpStatusNotifier pumpStatusNotifier =
        Provider.of<PumpStatusNotifier>(context, listen: false);
    pumpStatusRequest(pumpStatusNotifier);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pump Status"),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: const Icon(Icons.person_pin_circle),
                  tooltip: 'Profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  },
                ))
          ],
        ),
        body: SafeArea(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Consumer<PumpStatusNotifier>(builder: (context, provider, _) {
            var pumpstatus = provider.pumpstatus;
            return pumpstatus == null
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off_outlined, size: 100.0),
                      SizedBox(height: 10.0),
                      Text("Connections Error",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      Text(
                        "Check your network connections and try again.",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ))
                : DataTable(
                    columns: const [
                      DataColumn(label: Text('Pump')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Volume')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: pumpstatus.packets!.map((e) {
                      return DataRow(
                          color: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            return getCustomColor(
                                e.type.toString(), e.data.nozzleUp.toString())!;
                          }),
                          cells: [
                            DataCell(Text(
                              e.data.pump.toString(),
                              style: TextStyle(
                                  color: getTextColor(e.type.toString(),
                                      e.data.nozzleUp.toString())),
                            )),
                            DataCell(Text(
                                getCustomText(e.type.toString(),
                                    e.data.nozzleUp.toString()),
                                style: TextStyle(
                                    color: getTextColor(e.type.toString(),
                                        e.data.nozzleUp.toString())))),
                            DataCell(
                              Text(getFormattedText(e, "volume"),
                                  style: TextStyle(
                                      color: getTextColor(e.type.toString(),
                                          e.data.nozzleUp.toString()))),
                            ),
                            DataCell(Text(getFormattedText(e, "amount"),
                                style: TextStyle(
                                    color: getTextColor(e.type.toString(),
                                        e.data.nozzleUp.toString())))),
                          ]);
                    }).toList(),
                  );
          }),
        )));
  }

  String getCustomText(String type, String? nozzle) {
    try {
      String text = "";
      if (nozzle == "0" || nozzle == "null") {
        switch (type) {
          case "PumpOfflineStatus":
            text = "Off line".toUpperCase();
            break;
          case "PumpIdleStatus":
            text = "Idle".toUpperCase();
            break;
          case "PumpFillingStatus":
            text = "Filling".toUpperCase();
            break;
          default:
            text = "Idle".toUpperCase();
        }
      } else if (int.parse(nozzle!) >= 1) {
        text = "Call".toUpperCase();
      }
      return text;
    } catch (e) {
      return "";
    }
  }

  String getFormattedText(dynamic pumpStatus, String? type) {
    try {
      if (type == "volume") {
        if (pumpStatus.type.toString() == "PumpFillingStatus") {
          return pumpStatus.data!.volume.toString();
        }
        if (pumpStatus.type.toString() == "PumpOfflineStatus") {
          return "0.0";
        }
        if (pumpStatus.type.toString() == "PumpIdleStatus") {
          return pumpStatus.data!.lastVolume.toString();
        }
      } else if (type == "amount") {
        if (pumpStatus.type.toString() == "PumpFillingStatus") {
          return GlobalMethod.formatMoney(pumpStatus.data!.amount);
        }
        if (pumpStatus.type.toString() == "PumpOfflineStatus") {
          return "0";
        }
        if (pumpStatus.type.toString() == "PumpIdleStatus") {
          return GlobalMethod.formatMoney(pumpStatus.data!.lastAmount);
        }
      }
      return "0.0";
    } catch (e) {
      return "0.0";
    }
  }

  MaterialColor? getCustomColor(String type, String? nozzle) {
    MaterialColor? colorCustom;
    try {
      if (nozzle == "0" || nozzle == "null") {
        switch (type) {
          case "PumpOfflineStatus":
            colorCustom = GlobalMethod.from(const Color(0xFF808080));

            break;
          case "PumpIdleStatus":
            colorCustom = GlobalMethod.from(const Color(0xffe0ffff));

            break;
          case "PumpFillingStatus":
            colorCustom = GlobalMethod.from(const Color(0xff28a745));
            break;
          default:
            colorCustom = GlobalMethod.from(const Color(0xffe0ffff));
        }
      } else if (int.parse(nozzle!) >= 1) {
        colorCustom = GlobalMethod.from(const Color.fromARGB(255, 250, 250, 2));
      }
      return colorCustom;
    } catch (e) {
      return GlobalMethod.from(const Color(0xffe0ffff));
    }
  }

  Color? getTextColor(String type, String? nozzle) {
    Color? textColor;
    try {
      if (nozzle == "0" || nozzle == "null") {
        switch (type) {
          case "PumpOfflineStatus":
            textColor = Colors.white;
            break;
          case "PumpIdleStatus":
            textColor = Colors.black;
            break;
          case "PumpFillingStatus":
            textColor = Colors.white;
            break;
          default:
            textColor = Colors.black;
        }
      } else if (int.parse(nozzle!) >= 1) {
        textColor = Colors.black;
      }
      return textColor;
    } catch (e) {
      return Colors.black;
    }
  }
}
