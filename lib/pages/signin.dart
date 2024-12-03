import 'package:flutter/material.dart';
import 'package:pts/dialogs/dialog.dart';
import 'package:pts/manager/manager.dart';
import 'package:pts/request/customer_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pts/network/network_connectivity_status.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late SharedPreferences preferences;
  final _formKey = GlobalKey<FormState>();
  final _networkFormKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  getSharedPreference() async {
    ipController.text = "192.168.1.130";
    portController.text = "5556";
    preferences = await SharedPreferences.getInstance();
    preferences.setString("networkIpAddress", "192.168.1.130");
    preferences.setString("networkPort", "5556");
  }

  @override
  void initState() {
    super.initState();

    getSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Form(
                          key: _networkFormKey,
                          child: Column(
                            children: [
                              // username
                              textFormField(
                                  ipController,
                                  TextInputType.text,
                                  false,
                                  TextInputAction.next,
                                  "Ip address",
                                  "Ip address required"),
                              textFormField(
                                  portController,
                                  TextInputType.text,
                                  false,
                                  TextInputAction.next,
                                  "port number",
                                  "port number required"),
                            ],
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () async {
                        if (_networkFormKey.currentState!.validate()) {
                          final navigator = Navigator.of(context);
                          //  SharedPreferences preferences = await SharedPreferences.getInstance();
                          preferences.setString(
                              "networkIpAddress", ipController.text);
                          preferences.setString(
                              "networkPort", portController.text);
                          navigator.pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: const Icon(Icons.network_check),
        ),
        body: SafeArea(
          child: NetworkConnectivityStatus(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset("assets/images/login.png",
                                      width: 250),
                                ),
                                const SizedBox(height: 30.0),
                                Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      // username
                                      textFormField(
                                          username,
                                          TextInputType.text,
                                          false,
                                          TextInputAction.next,
                                          "Username",
                                          "Username required"),

                                      // passwordR
                                      const SizedBox(height: 5.0),
                                      textFormField(
                                          password,
                                          TextInputType.text,
                                          true,
                                          TextInputAction.done,
                                          "Password",
                                          "Password required"),

                                      const SizedBox(height: 20.0),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 15.0),
                                        child: ConstrainedBox(
                                            constraints:
                                                const BoxConstraints.tightFor(
                                                    width: 300, height: 50),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final navigator =
                                                      Navigator.of(context);

                                                  final scaffoldMessenger =
                                                      ScaffoldMessenger.of(
                                                          context);

                                                  Map<String, String> body;

                                                  body = {
                                                    "username": username.text
                                                        .replaceAll(
                                                            RegExp(r"\s+"), ""),
                                                    "password": password.text
                                                        .replaceAll(
                                                            RegExp(r"\s+"), ""),
                                                  };

                                                  CustomerDialog.show(
                                                      context,
                                                      Colors.white,
                                                      const Color.fromRGBO(
                                                          12, 56, 97, 1),
                                                      "Signing into account");

                                                  await Future.delayed(
                                                      const Duration(
                                                          microseconds: 500));

                                                  var res =
                                                      // ignore: use_build_context_synchronously
                                                      await CustomerRequest
                                                          .signIn(
                                                              context, body);
                                                  print("response");
                                                  print(res);
                                                  navigator.pop();

                                                  scaffoldMessenger
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              res['message'])));
                                                  if (res['success'] == true) {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const ManagerDashboard(
                                                                          pageIndex:
                                                                              0,
                                                                        )),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }
                                                }
                                              },
                                              child: const Text('Submit',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )),
                                      )
                                    ]))
                              ]))))),
        ));
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
