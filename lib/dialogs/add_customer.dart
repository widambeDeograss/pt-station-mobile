import 'package:flutter/material.dart';
import 'package:pts/dialogs/dialog.dart';
import 'package:pts/request/customer_request.dart';

class AddCustomerDialog {
  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  late TextEditingController customerTIN = TextEditingController();
  late TextEditingController mobileNumber = TextEditingController();
  late TextEditingController customerName = TextEditingController();
  late TextEditingController mvrnController = TextEditingController();

  show(BuildContext context, Color bg, VoidCallback cb) {
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
                                          const Text("Add Customer",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold)),
                                          const Divider(),
                                          Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                // lastname
                                                const SizedBox(height: 10.0),
                                                // first name
                                                textFormField(
                                                    customerName,
                                                    TextInputType.text,
                                                    false,
                                                    TextInputAction.next,
                                                    "Customer Name",
                                                    "customer name required"),

                                                // lastname
                                                const SizedBox(height: 10.0),
                                                textFormField(
                                                  customerTIN,
                                                  TextInputType.number,
                                                  false,
                                                  TextInputAction.next,
                                                  "Customer TIN",
                                                  null,
                                                ),

                                                // username
                                                const SizedBox(height: 10.0),
                                                textFormField(
                                                    mobileNumber,
                                                    TextInputType.number,
                                                    false,
                                                    TextInputAction.done,
                                                    "Mobile Number",
                                                    "mobile number required"),
                                                const SizedBox(height: 10.0),
                                                textFormField(
                                                    mvrnController,
                                                    TextInputType.text,
                                                    false,
                                                    TextInputAction.done,
                                                    "MVRN Number",
                                                    "MVRN number required"),
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

                                                            CustomerDialog.show(
                                                                context,
                                                                Colors.white,
                                                                const Color
                                                                    .fromRGBO(
                                                                    12,
                                                                    56,
                                                                    97,
                                                                    1),
                                                                "Adding customer details...");
                                                            await Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        500));

                                                            var resolveResponse =
                                                                await CustomerRequest
                                                                    .resolveCustomer(
                                                                        context,
                                                                        customerTIN
                                                                            .text);
                                                            if (resolveResponse
                                                                    .customers ==
                                                                null) {
                                                              scaffoldMessenger.showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      resolveResponse
                                                                          .errorResponse!
                                                                          .errorDescription!)));
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  body = {
                                                                "tinNumber":
                                                                    customerTIN
                                                                        .text,
                                                                "customerType": customerTIN
                                                                        .text
                                                                        .isEmpty
                                                                    ? "Individual"
                                                                    : "Non Individual",
                                                                "phoneNumber":
                                                                    mobileNumber
                                                                        .text,
                                                                "customerName":
                                                                    customerName
                                                                        .text,
                                                                "mvrn":
                                                                    mvrnController
                                                                        .text,
                                                                "created_by":
                                                                    "system admin",
                                                              };
                                                              navigator.pop();
                                                              var res = await CustomerRequest
                                                                  .sharedPost(
                                                                      context,
                                                                      "/customers",
                                                                      body);
                                                              print(res);
                                                            }
                                                            navigator.pop();
                                                            cb();
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
      String? error) {
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
              // If the TIN field is optional, return null (no validation error)
              if (error != null && controller.text.isEmpty) {
                return error;
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
