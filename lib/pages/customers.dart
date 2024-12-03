import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pts/dialogs/add_customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pts/models/customers_model.dart';
import 'package:pts/dialogs/add_sale_dialog.dart';
import 'package:pts/request/customer_request.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:pts/network/network_connectivity_status.dart';
import 'package:pts/notifier/connectivity_change_notifier.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);
  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  late List<DatatableHeader> _headers;

  int _total = 100;
  String? _sortColumn;
  int _currentPage = 1;
  List<bool>? _expanded;
  var random = Random();
  bool _isLoading = true;
  bool _isSearch = false;
  int? _currentPerPage = 10;
  bool _sortAscending = true;
  String? _searchKey = "name";
  final bool _showSelect = true;
  final List<int> _perPages = [10, 20, 50, 100];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];

  List<Map<String, dynamic>> _generateData(
      List<CustomersReportsModel>? customers) {
    List<Map<String, dynamic>> items = [];
    // ignore: unused_local_variable
    if (customers != null) {
      for (var item in customers) {
        items.add({
          "id": item.id,
          "tin": item.tinNumber,
          "name": item.customerName!.split(",")[0],
          "amount": item.amount,
          "volume": item.volume,
          "issued_date": "0",
        });
      }
    }
    return items;
  }

  late List<CustomersReportsModel> customers;
  _customers() async {
    customers = await CustomerRequest.customers(context);
    _mockPullData(customers.reversed.toList());
  }

  _mockPullData(List<CustomersReportsModel> customers) async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(customers));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered
          .getRange(
              0,
              _currentPerPage! < _sourceFiltered.length
                  ? _currentPerPage!
                  : _sourceFiltered.length)
          .toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
          text: "Name",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          editable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "TIN Number",
          value: "tin",
          show: true,
          flex: 2,
          sortable: true,
          editable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Amount",
          value: "amount",
          show: true,
          sortable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Volume",
          value: "volume",
          show: true,
          sortable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Total transactions",
          value: "issued_date",
          show: true,
          sortable: false,
          textAlign: TextAlign.left),
    ];

    _customers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Customers"),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: const Icon(Icons.refresh_sharp),
                  tooltip: 'Refresh Page',
                  onPressed: () {
                    _customers();
                  },
                ))
          ],
        ),
        body: SafeArea(
          child: NetworkConnectivityStatus(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                Container(
                  // height: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(
                    maxHeight: 600,
                  ),
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.black,
                    clipBehavior: Clip.none,
                    child: ResponsiveDatatable(
                      reponseScreenSizes: const [ScreenSize.xs],
                      actions: [
                        if (_isSearch)
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Search by ' +
                                    _searchKey!
                                        .replaceAll(RegExp('[\\W_]+'), ' ')
                                        .toUpperCase(),
                                prefixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        _isSearch = false;
                                      });
                                      _customers();
                                    }),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {})),
                            onSubmitted: (value) {
                              _filterData(value);
                            },
                          )),
                        if (!_isSearch)
                          IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _isSearch = true;
                                });
                              })
                      ],
                      source: _source,
                      headers: _headers,
                      selecteds: _selecteds,
                      showSelect: _showSelect,
                      autoHeight: false,
                      dropContainer: (data) {
                        if (int.tryParse(data['id'].toString())!.isEven) {
                          return const Text("is Even");
                        }
                        return _DropDownContainer(data: data);
                      },
                      onChangedRow: (value, header) {},
                      onSubmittedRow: (value, header) {},
                      onTabRow: (rest) async {
                        CustomersReportsModel? customersReportsModel =
                            CustomersReportsModel(
                                id: rest["id"],
                                customerName: rest["name"],
                                amount: rest["amount"],
                                volume: rest["volume"],
                                tinNumber: rest["tin"],
                                createdAt: rest["issued_date"],
                                createdBy: "",
                                createdByName: "MANAGER",
                                mvrn: "",
                                customerType: "",
                                numberOfTransactions: 0,
                                phoneNumber: "",
                                updatedAt: rest["issued_date"]);
                        final data = await CustomerRequest.getNozzles(context);
                        AddSaleDialog()
                            .show(context, data, true, customersReportsModel);
                      },
                      onSort: (value) {
                        setState(() => _isLoading = true);

                        setState(() {
                          _sortColumn = value;
                          _sortAscending = !_sortAscending;
                          if (_sortAscending) {
                            _sourceFiltered.sort((a, b) =>
                                b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                          } else {
                            _sourceFiltered.sort((a, b) =>
                                a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                          }
                          var _rangeTop =
                              _currentPerPage! < _sourceFiltered.length
                                  ? _currentPerPage!
                                  : _sourceFiltered.length;
                          _source =
                              _sourceFiltered.getRange(0, _rangeTop).toList();
                          _searchKey = value;

                          _isLoading = false;
                        });
                      },
                      expanded: _expanded,
                      sortAscending: _sortAscending,
                      sortColumn: _sortColumn,
                      isLoading: _isLoading,
                      onSelect: null,
                      onSelectAll: null,
                      footers: null,
                    ),
                  ),
                ),
              ]))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Consumer<ConnectivityChangeNotifier>(builder:
            (BuildContext context,
                ConnectivityChangeNotifier connectivityChangeNotifier,
                Widget? widget) {
          connectivityChangeNotifier.initialLoad();
          return connectivityChangeNotifier.connectivity ==
                  ConnectivityResult.none
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 85.0, right: 5.0),
                  child: Container(
                      width: 40.0,
                      height: 40.0,
                      child: RawMaterialButton(
                          elevation: 0.0,
                          shape: const CircleBorder(),
                          fillColor: const Color(0xFFFF5733),
                          child: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            AddCustomerDialog().show(context, Colors.white, () {
                              _customers();
                            });
                          })));
        }));
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      child: Column(
        children: _children,
      ),
    );
  }
}
