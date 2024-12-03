import 'package:flutter/material.dart';
import 'package:pts/dialogs/dialog.dart';
import 'package:pts/request/customer_request.dart';

class ChangePriceDialog {
  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  late String gradeName;
  late TextEditingController gradeId = TextEditingController();
  late TextEditingController gradePrice = TextEditingController();

  // List grade -> [gradeName, gradeId, gradePrice]
  show(BuildContext context, Map<String, dynamic> grade, VoidCallback cb) {
    // Variable initilizations
    gradeId = TextEditingController()..text = grade["gradeId"];
    gradePrice = TextEditingController()..text = grade["gradePrice"];

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
                                          Text(grade["gradeName"],
                                              style: const TextStyle(
                                                  fontSize: 20.0)),
                                          Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                // lastname
                                                const SizedBox(height: 10.0),
                                                // first name
                                                textFormField(
                                                    gradePrice,
                                                    TextInputType.number,
                                                    false,
                                                    TextInputAction.done,
                                                    "Change price",
                                                    "price required"),

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
                                                              "commands": [
                                                                {
                                                                  "data": {
                                                                    "grade":
                                                                        gradeId
                                                                            .text,
                                                                    "price":
                                                                        gradePrice
                                                                            .text
                                                                  }
                                                                }
                                                              ]
                                                            };

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
                                                                "Changing price...");

                                                            await Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        500));

                                                            var res =
                                                                // ignore: use_build_context_synchronously
                                                                await CustomerRequest
                                                                    .sharedPost(
                                                                        context,
                                                                        "/android_change_price",
                                                                        body);

                                                            navigator.pop();

                                                            cb();
                                                            scaffoldMessenger
                                                                .showSnackBar(SnackBar(
                                                                    content:
                                                                        Text(res[
                                                                            "message"])));
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Update',
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
