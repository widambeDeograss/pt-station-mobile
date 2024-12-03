import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pts/dialogs/dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pts/pages/profile.dart';
import 'package:pts/request/customer_request.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:pts/network/network_connectivity_status.dart';
import 'package:pts/notifier/connectivity_change_notifier.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);
  @override
  State<Reports> createState() => _TicketsState();
}

class _TicketsState extends State<Reports> {
  var yearValue;
  var monthValue;

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  int _total = 100;
  String? _sortColumn;
  List<bool>? _expanded;
  bool _isLoading = false;
  bool _showSelect = false;
  String? _searchKey = null;
  int? _currentPerPage = 10;
  bool _sortAscending = true;
  late List<String> years = [];
  late List<DatatableHeader> _headers;
  List<int> _perPages = [10, 20, 50, 100];
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 1;
  bool _isSearch = false;
  late List<dynamic> data = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];

  List<Map<String, dynamic>> _generateData(Map<String, dynamic> reports) {
    data = reports["status"] == true ? reports['message'] : [];

    List<Map<String, dynamic>> items = [];
    // ignore: unused_local_variable
    for (var item in data) {
      items.add({
        "pump_iD": item["pump_id"],
        "fuel_grade": item["fuel_grade"],
        "volume_sold": item["volume_sold"],
        "total_amount": item["total_amount"],
        "transactions": item["transactions"],
        "date_time_end": item["date_time_end"],
        "date_time_start": item["date_time_start"],
      });
    }

    return items;
  }

  _initializeData(Map<String, dynamic> reports) async {
    _mockPullData(reports);
  }

  _years() async {
    final yearsResponse = await CustomerRequest.years(context);
    setState(() {
      years = yearsResponse.message;
    });
  }

  _mockPullData(Map<String, dynamic> reports) async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(reports));
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
          text: "Pump ID",
          value: "pump_iD",
          show: true,
          flex: 2,
          sortable: false,
          editable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Fuel Grade",
          value: "fuel_grade",
          show: true,
          flex: 2,
          sortable: false,
          editable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Transactions",
          value: "transactions",
          show: true,
          sortable: false,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Date/Time start",
          value: "date_time_start",
          show: true,
          sortable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Date/Time end",
          value: "date_time_end",
          show: true,
          sortable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Volume Sold",
          value: "volume_sold",
          show: true,
          sortable: false,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Total Amount",
          value: "total_amount",
          show: true,
          sortable: false,
          textAlign: TextAlign.left)
    ];

    _years();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> columns = [
    "Ticket ID",
    "Subject",
    "Organization Name",
    "Status",
    "Priority",
    "Asigned To",
    "Contact",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Reports"), actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Printe Report',
              onPressed: data.isEmpty
                  ? null
                  : () {
                      Map<String, dynamic> body = {
                        "year": yearValue,
                        "month": monthValue,
                      };
                      CustomerRequest.sharedPost(
                          context, "/android_print_report", body);
                    },
            ),
          ),
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
        ]),
        body: SafeArea(
          child: NetworkConnectivityStatus(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                Container(
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
                        IconButton(
                            icon: const Icon(
                              Icons.search,
                              size: 0,
                            ),
                            onPressed: () {
                              setState(() {});
                            })
                      ],
                      headers: _headers,
                      source: _source,
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
                      onTabRow: (data) {},
                      onSort: (value) {},
                      expanded: _expanded,
                      sortAscending: _sortAscending,
                      sortColumn: _sortColumn,
                      isLoading: _isLoading,
                      onSelect: (value, item) {
                        if (value!) {
                          setState(() => _selecteds.add(item));
                        } else {
                          setState(() =>
                              _selecteds.removeAt(_selecteds.indexOf(item)));
                        }
                      },
                      onSelectAll: (value) {
                        if (value!) {
                          setState(() => _selecteds =
                              _source.map((entry) => entry).toList().cast());
                        } else {
                          setState(() => _selecteds.clear());
                        }
                      },
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
                      child: const Icon(Icons.filter_alt_sharp,
                          color: Colors.white),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, StateSetter setState) {
                                return Dialog(
                                    insetPadding: const EdgeInsets.all(20),
                                    child: Container(
                                        width: double.infinity,
                                        // height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: SingleChildScrollView(
                                            child: InkWell(
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                },
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        // height: 265,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                  "Monthly Report",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              const Divider(),
                                                              Form(
                                                                  key: _formKey,
                                                                  child: Column(
                                                                      children: [
                                                                        // User input, year
                                                                        const SizedBox(
                                                                            height:
                                                                                10.0),
                                                                        textInputDropDown(
                                                                            "Year",
                                                                            yearValue,
                                                                            1,
                                                                            years),

                                                                        // User input, month
                                                                        const SizedBox(
                                                                            height:
                                                                                10.0),
                                                                        textInputDropDown(
                                                                            "Month",
                                                                            monthValue,
                                                                            2,
                                                                            months),

                                                                        const SizedBox(
                                                                            height:
                                                                                10.0),
                                                                        Container(
                                                                          child: ConstrainedBox(
                                                                              constraints: const BoxConstraints.tightFor(width: 300, height: 50),
                                                                              child: ElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    final navigator = Navigator.of(context);

                                                                                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                                                                                    Map<String, dynamic> body = {
                                                                                      "year": yearValue,
                                                                                      "month": monthValue,
                                                                                    };

                                                                                    navigator.pop();

                                                                                    CustomerDialog.show(context, Colors.white, const Color.fromRGBO(12, 56, 97, 1), "Generating report...");

                                                                                    await Future.delayed(const Duration(microseconds: 500));

                                                                                    // ignore: use_build_context_synchronously
                                                                                    var res = await CustomerRequest.sharedPost(context, "/android_reports", body);

                                                                                    navigator.pop();

                                                                                    if (res["status"] == true) {
                                                                                      _initializeData(res);
                                                                                      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Report generated successfull.")));
                                                                                    } else {
                                                                                      _initializeData({
                                                                                        "status": false,
                                                                                        "message": []
                                                                                      });
                                                                                      scaffoldMessenger.showSnackBar(SnackBar(content: Text(res["message"])));
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: const Text('Submit', style: TextStyle(color: Colors.white)),
                                                                              )),
                                                                        )
                                                                      ]))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ))))));
                              });
                            });
                      },
                    ),
                  ));
        }));
  }

  SizedBox textInputDropDown(
      String inputTitle, String initValue, int inputCount, List<String>? data) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(inputTitle),
          const SizedBox(height: 5.0),
          DropdownButtonFormField<String>(
              value: initValue,
              hint: const Text("..."),
              onChanged: (value) => setState(() {
                    switch (inputCount) {
                      case 1:
                        yearValue = value;
                        break;
                      case 2:
                        monthValue = value;
                        break;
                    }
                  }),
              validator: (value) => value == null ? 'field required' : null,
              items: data!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toLowerCase(),
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10)),
                contentPadding: const EdgeInsets.only(left: 10, bottom: 0.0),
              ))
        ],
      ),
    );
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
