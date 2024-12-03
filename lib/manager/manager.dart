import 'package:pts/models/pumps.dart';
import 'package:pts/pages/Transaction.dart';
import 'package:pts/pages/pump.dart';
import 'package:pts/pages/sales.dart';
import 'package:flutter/material.dart';
import 'package:pts/pages/reports.dart';
import 'package:pts/pages/customers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/profile.dart';

class ManagerDashboard extends StatefulWidget {
  final int pageIndex;
  const ManagerDashboard({Key? key, required this.pageIndex}) : super(key: key);
  @override
  State<ManagerDashboard> createState() => _AManagerDashboardState();
}

class _AManagerDashboardState extends State<ManagerDashboard> {
  late int _pageIndex;

  late List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.monetization_on_outlined), label: "Sales"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.supervisor_account), label: "Customers"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.library_books_outlined), label: "Reports"),
    const BottomNavigationBarItem(icon: Icon(Icons.heat_pump), label: "Pump"),
    const BottomNavigationBarItem(icon: Icon(Icons.money), label: "cash"),
  ];

  // List of pages
  final pages = [
    const Sales(),
    const Customers(),
    const Reports(),
    const PumpScreen(),
    Transaction()
  ];

  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pageIndex = widget.pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: pages[_pageIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFFFF5733),
          currentIndex: _pageIndex,
          items: items,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ));
  }
}
