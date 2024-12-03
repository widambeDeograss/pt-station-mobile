import 'package:flutter/material.dart';
import 'package:pts/dialogs/dialog.dart';
import 'package:pts/models/sales_model.dart';
import 'package:pts/models/customers_model.dart';
import 'package:pts/request/customer_request.dart';

class AddSaleDialog {
  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  var pumpIdValue;
  SalesPumpsModel? salesModel;
  late double price = 0;
  late double newPrice = 0;
  late TextEditingController customerId;
  late TextEditingController customerTIN;
  late TextEditingController customerName;
  late TextEditingController pumpId = TextEditingController();
  late TextEditingController discount = TextEditingController();

  show(BuildContext context, List<SalesPumpsModel>? pumps, bool customerNav,
      CustomersReportsModel? customers) {
    if (!customerNav) {
      customerId = TextEditingController();
      customerTIN = TextEditingController();
      customerName = TextEditingController();
    } else {
      customerName = TextEditingController()
        ..text = customers!.customerName!.split(",")[0];
      customerTIN = TextEditingController()..text = customers.tinNumber!;
      customerId = TextEditingController()..text = customers.id.toString();
    }
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                insetPadding: const EdgeInsets.all(20),
                child: Container(
                    width: double.infinity,
                    // height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: SingleChildScrollView(
                        child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    // height: 265,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Add Sale",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold)),
                                          const Divider(),
                                          Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                const SizedBox(height: 10.0),
                                                // Customer Name
                                                textFormField(
                                                    customerName,
                                                    TextInputType.text,
                                                    false,
                                                    TextInputAction.next,
                                                    "Customer Name",
                                                    "customer name required"),

                                                // Customer TIN
                                                const SizedBox(height: 10.0),
                                                textFormField(
                                                    customerTIN,
                                                    TextInputType.number,
                                                    false,
                                                    TextInputAction.next,
                                                    "Customer TIN",
                                                    "customer TIN required"),

                                                // Pump ID
                                                const SizedBox(height: 10.0),
                                                SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text("Pump ID"),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      DropdownButtonFormField<
                                                              String>(
                                                          value: pumpIdValue,
                                                          hint:
                                                              const Text("..."),
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                pumpIdValue =
                                                                    value;

                                                                var pump = pumps!
                                                                    .firstWhere((e) =>
                                                                        e.id.toString() ==
                                                                        value);
                                                                salesModel =
                                                                    pump;
                                                                price = double
                                                                    .parse(pump
                                                                        .totalAmount!);
                                                                newPrice = 0;
                                                                discount =
                                                                    TextEditingController();
                                                              }),
                                                          validator: (value) =>
                                                              value == null
                                                                  ? 'field required'
                                                                  : null,
                                                          items: pumps!.map<
                                                                  DropdownMenuItem<
                                                                      String>>(
                                                              (SalesPumpsModel
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value.id
                                                                  .toString(),
                                                              child: Text("Pump " +
                                                                  value.pumpNo
                                                                      .toString() +
                                                                  " " +
                                                                  "Nozzle " +
                                                                  value
                                                                      .nozzleNo!
                                                                      .toString() +
                                                                  " " +
                                                                  value
                                                                      .gradeName!
                                                                      .toString()),
                                                            );
                                                          }).toList(),
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            hintStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                            enabledBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white10)),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    bottom:
                                                                        0.0),
                                                          ))
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 20.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text("Discount"),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                                "New Price: "),
                                                            Text(newPrice > 0
                                                                ? newPrice
                                                                    .toString()
                                                                : price
                                                                    .toString())
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    TextFormField(
                                                      controller: discount,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      cursorColor: Colors.black,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        enabledBorder:
                                                            const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white10)),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                bottom: 0.0),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          int discount =
                                                              int.parse(
                                                                  value == ""
                                                                      ? "0"
                                                                      : value);
                                                          discount >= 1
                                                              ? newPrice =
                                                                  price -
                                                                      discount
                                                              : newPrice = 0;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (discount
                                                            .text.isEmpty) {
                                                          return "discount required";
                                                        } else {}
                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                  ],
                                                ),

                                                const SizedBox(height: 10.0),
                                                Container(
                                                  child: ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints
                                                              .tightFor(
                                                              width: 300,
                                                              height: 50),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            final navigator =
                                                                Navigator.of(
                                                                    context);

                                                            final scaffoldMessenger =
                                                                ScaffoldMessenger
                                                                    .of(context);

                                                            Map<String, dynamic>
                                                                body = {
                                                              "pump":
                                                                  salesModel!
                                                                      .pumpNo!,
                                                              "nozzle":
                                                                  salesModel!
                                                                      .nozzleNo,
                                                              "grade":
                                                                  salesModel!
                                                                      .gradeName,
                                                              "buyerType":
                                                                  "WALK_IN",
                                                              "tinNumber":
                                                                  customerTIN
                                                                      .text,
                                                              "buyerLegalName":
                                                                  customerName
                                                                      .text,
                                                              "buyerBrn": "",
                                                              "discountPerLiter":
                                                                  discount.text,
                                                              "buyerMobilePhone":
                                                                  "",
                                                              "buyerEmail": "",
                                                              "buyerAddress":
                                                                  "",
                                                            };
                                                            print(body);
                                                            navigator.pop();

                                                            CustomerDialog.show(
                                                                context,
                                                                Colors.white,
                                                                const Color
                                                                    .fromRGBO(
                                                                    12,
                                                                    56,
                                                                    97,
                                                                    1),
                                                                "Adding sale...");

                                                            await Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        500));

                                                            var res =
                                                                // ignore: use_build_context_synchronously
                                                                await CustomerRequest
                                                                    .sharedPost(
                                                                        context,
                                                                        "/sales",
                                                                        body);

                                                            navigator.pop();

                                                            scaffoldMessenger
                                                                .showSnackBar(SnackBar(
                                                                    content:
                                                                        Text(res[
                                                                            "message"])));
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Submit',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
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
  }

  SizedBox textFormField(
      TextEditingController controller,
      TextInputType inputType,
      bool obscureText,
      TextInputAction textInputAction,
      String labelText,
      String error) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            obscureText: obscureText,
            cursorColor: Colors.black,
            textInputAction: textInputAction,
            style: const TextStyle(color: Colors.black),
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            ),
            validator: (value) {
              if (controller.text.isEmpty) {
                return error;
              } else {}
              return null;
            },
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
