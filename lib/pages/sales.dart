import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pts/models/sales_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pts/dialogs/add_sale_dialog.dart';
import 'package:pts/pages/profile.dart';
import 'package:pts/request/customer_request.dart';
import 'package:pts/dialogs/change_price_dialog.dart';
import 'package:pts/network/network_connectivity_status.dart';
import 'package:pts/notifier/connectivity_change_notifier.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final List gradeColors = [
    // Red
    const Color.fromRGBO(251, 38, 0, 1),
    // Green
    const Color.fromRGBO(38, 227, 0, 1),
    // Orange
    const Color.fromRGBO(254, 176, 25, 1),
    // Black
    const Color.fromRGBO(0, 0, 0, 1),
  ];

  @override
  Widget build(BuildContext context) {
    late SalesModel? sales;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sales"),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: const Icon(Icons.refresh_sharp),
                  tooltip: 'Refresh Page',
                  onPressed: () {
                    setState(() {});
                  },
                )),
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
            child: NetworkConnectivityStatus(
                child: SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        padding: const EdgeInsets.all(20.0),
                        child: FutureBuilder<SalesModel>(
                            future: CustomerRequest.sales(context),
                            builder: (context, snapshot) {
                              sales = snapshot.data;
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [CircularProgressIndicator()],
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_off_outlined, size: 100.0),
                                    SizedBox(height: 10.0),
                                    Text("Server error",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Server communication error, please check your network connections and try again.",
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                );
                              }

                              if (sales != null) {
                                int count = -1;
                                return Column(
                                    children: sales!.message.reports!
                                        .map((grade) => gradesReport(context,
                                            grade, gradeColors[count += 1]))
                                        .toList());
                              } else {
                                return Container(
                                  child: const Center(
                                    child: Text("Bucket is empty"),
                                  ),
                                );
                              }
                            }))))),
        floatingActionButton:
            // Consumer<ConnectivityChangeNotifier>(builder:
            //     (BuildContext context,
            //         ConnectivityChangeNotifier connectivityChangeNotifier,
            //         Widget? widget) {
            //   connectivityChangeNotifier.initialLoad();
            //   return connectivityChangeNotifier.connectivity ==
            //           ConnectivityResult.none
            //       ? Container()
            //    :
            FloatingActionButton(
          backgroundColor: const Color.fromRGBO(251, 38, 0, 1),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            final data = await CustomerRequest.getNozzles(context);
            AddSaleDialog().show(context, data, false, null);
          },
        )
        // }
        //)
        );
  }

  Widget gradesReport(
      BuildContext context, SalesReportsModel grade, Color color) {
    print(grade.statistics);
    print("================");
    return Column(
      children: [
        const SizedBox(height: 35),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2.5, color: color),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        grade.gradeName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      grade.gradeName.toLowerCase() != "total revenue"
                          ? Row(
                              children: [
                                const Text(
                                  "Price: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${grade.price}")
                              ],
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Amount"),
                          Text(grade.statistics[0]['amount_sold'].toString())
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Volume"),
                          Text(grade.statistics[0]['volume_sold'].toString())
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Transactions"),
                          Text(grade.statistics[0]['transactions'].toString())
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            grade.gradeName.toLowerCase() != "total revenue"
                ? Positioned(
                    top: -15,
                    right: -15,
                    child: GestureDetector(
                      child: Container(
                        child: const Icon(Icons.edit),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(width: 2.5, color: color)),
                      ),
                      onTap: () {
                        Map<String, dynamic> data = {
                          "gradeName": grade.gradeName,
                          "gradeId": grade.gradeId.toString(),
                          "gradePrice": grade.price.toString()
                        };

                        // List grade (data)-> [gradeName, gradeId, gradePrice]
                        ChangePriceDialog().show(context, data, () {
                          setState(() {});
                        });
                      },
                    ))
                : Container()
          ],
        )
      ],
    );
  }
}
