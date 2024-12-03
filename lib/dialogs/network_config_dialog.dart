import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkConfigurationDialog {
  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();

  late TextEditingController ipController = TextEditingController();
  late TextEditingController portController = TextEditingController();

  Future<void> loadSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ipController.text =
        preferences.getString('networkIpAddress') ?? '192.168.100.33';
    portController.text = preferences.getString('networkPort') ?? '3010';
  }

  show(BuildContext context, VoidCallback cb) {
    // Load shared preferences asynchronously
    loadSharedPreference();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                insetPadding: const EdgeInsets.all(20),
                child: Container(
                    width: double.infinity,
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
                                          const Text("Network Configuration",
                                              style: TextStyle(fontSize: 20.0)),
                                          Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                // IP Address
                                                const SizedBox(height: 10.0),
                                                textFormField(
                                                    ipController,
                                                    TextInputType.text,
                                                    false,
                                                    TextInputAction.next,
                                                    "IP Address",
                                                    "IP address required"),

                                                const SizedBox(height: 10.0),

                                                // Port Number
                                                textFormField(
                                                    portController,
                                                    TextInputType.text,
                                                    false,
                                                    TextInputAction.done,
                                                    "Port Number",
                                                    "Port number required"),

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

                                                            SharedPreferences
                                                                preferences =
                                                                await SharedPreferences
                                                                    .getInstance();

                                                            await preferences
                                                                .setString(
                                                                    "networkIpAddress",
                                                                    ipController
                                                                        .text);
                                                            await preferences
                                                                .setString(
                                                                    "networkPort",
                                                                    portController
                                                                        .text);

                                                            navigator.pop();

                                                            cb(); // Callback after saving

                                                            scaffoldMessenger
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Network configuration saved successfully")));
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Save',
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
