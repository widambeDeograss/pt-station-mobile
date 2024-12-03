import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pts/notifier/connectivity_change_notifier.dart';

class NetworkConnectivityStatus extends StatelessWidget {
  final Widget child;
  const NetworkConnectivityStatus({Key? key, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityChangeNotifier>(builder: (BuildContext context,
        ConnectivityChangeNotifier connectivityChangeNotifier, Widget? widget) {
      connectivityChangeNotifier.initialLoad();
      return connectivityChangeNotifier.connectivity == ConnectivityResult.none
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_off_outlined, size: 100.0),
                  SizedBox(height: 10.0),
                  Text("Network error",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  Text("Connect the internet")
                ],
              ),
            )
          : child;
    });
  }
}
