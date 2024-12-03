import 'dart:convert';
import 'package:pts/models/error_response.dart';
import 'package:pts/models/resolve_customer.dart';
import 'package:pts/models/resolve_customer_warapper.dart';
import 'package:pts/models/transaction_model.dart';

import 'request_config.dart';
import 'package:flutter/material.dart';
import 'package:pts/pages/signin.dart';
import 'package:http/http.dart' as http;
import 'package:pts/models/years_model.dart';
import 'package:pts/models/sales_model.dart';
import 'package:pts/models/customers_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRequest {
  static Future<Map<String, dynamic>> signIn(
      BuildContext context, Map<String, dynamic> body) async {
    Map<String, dynamic> res = {};
    Map<String, dynamic> user = {};

    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.Response response = await RequestConfig(preferences: preferences).post(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/auth/login",
        body);

    RequestConfig.updateCookie(response);

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<String> session = [];

        user = data['user'];
        final role = data['user']['role'];
        final token = data['token'];
        print("object========");
        print(user['userName']);
        print(user['email']);
        print(role);
        print(token);
        // session.add(role);
        // session.add(token);r
        session.add(json.encode(user));
        preferences.setString("name", user['userName']);
        preferences.setString("email", user['email']);
        preferences.setString("role", role);
        preferences.setString("AccessToken", token);
        preferences.setStringList("session", session);
        print("====================================");
        res['success'] = true;
        res['message'] = "You are logged in.";
      } else if (response.statusCode == 401) {
        res['success'] = false;
        res['message'] = "Invalid username or password";
      } else {
        res['success'] = false;
        res['message'] = "Somethings went wrong try again later.";
      }
    } catch (e) {
      print("========================");
      print(e);
    }

    return res;
  }

  static Future<Map<String, dynamic>> sharedPost(
      BuildContext context, String path, Map<String, dynamic> body) async {
    Map<String, dynamic> res = {};
    SharedPreferences preferences = await SharedPreferences.getInstance();

    http.Response response = await RequestConfig(preferences: preferences).post(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1" +
            path,
        body);
    RequestConfig.updateCookie(response);

    print("object=========");
    print(response.body);
    res = jsonDecode(response.body);
    res["message"] = "saved successfully";
    res["status"] = true;
    print(res);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      return res;
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        res['status'] = false;
        res['message'] = "Somethings went wrong try again later.";
        return res;
      }
    }
    return res;
  }

  static Future<YearsModel> years(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        'http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/android_year_report');
    RequestConfig.updateCookie(response);

    if (response.statusCode == 200) {
      return YearsModel.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get years report.');
      }
    }
  }

  static Future<SalesModel> sales(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/dashboard");
    RequestConfig.updateCookie(response);

    print("===========================");

    // if (response.statusCode == 200) {
    return SalesModel.fromJson(jsonDecode(response.body));
    //  }
    //  else {
    //   if (response.statusCode == 401) {
    //     preferences.remove("session");
    //     // ignore: use_build_context_synchronously
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => const Signin()),
    //         (Route<dynamic> route) => false);
    //     throw Exception();
    //   } else {
    //     throw Exception('Failed to get sales.');
    //   }
    // }
  }

  static Future<List<CustomersReportsModel>> customers(
      BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/customers");
    RequestConfig.updateCookie(response);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<CustomersReportsModel> customers =
          jsonList.map((json) => CustomersReportsModel.fromJson(json)).toList();
      return customers;
      // return CustomersModel.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get customers.');
      }
    }
  }

  static Future<List<SalesPumpsModel>> getNozzles(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/company/nozzles");
    RequestConfig.updateCookie(response);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<SalesPumpsModel>? pumps =
          jsonList.map((json) => SalesPumpsModel.fromJson(json)).toList();
      return pumps;
      // return CustomersModel.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get customers.');
      }
    }
  }

  static Future<List<TransactionModel>> getTransaction(
      BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? localAddress = "http://" +
    //     await preferences.getString("networkIpAddress")! +
    //     ":" +
    //     await preferences.getString("networkPort")! +
    //     "/api/v1/receipts";
    // print(localAddress);

    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/receipts");
    List<dynamic> jsonList = List.from(jsonDecode(response.body));
    List<TransactionModel>? transactionModels =
        jsonList.map((json) => TransactionModel.fromJson(json)).toList();
    print(transactionModels.toString());
    // RequestConfig.updateCookie(response);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = List.from(jsonDecode(response.body));
      List<TransactionModel>? transactionModels =
          jsonList.map((json) => TransactionModel.fromJson(json)).toList();
      print(transactionModels.toString());
      return transactionModels;
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get customers.');
      }
    }
  }

  static Future<ResolveCustomerWarapper> resolveCustomer(
      BuildContext context, String tinNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/customers/queryTin/" +
            tinNumber);
    RequestConfig.updateCookie(response);
    print(response.body);

    print(response.statusCode);
    if (response.statusCode == 200) {
      ResolveCustomer customers = ResolveCustomer.fromJson(response.body);
      return ResolveCustomerWarapper(customers: customers, errorResponse: null);
      // return CustomersModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 400) {
      final error = ErrorResponse.fromJson(jsonDecode(response.body));
      return ResolveCustomerWarapper(customers: null, errorResponse: error);
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get customers.');
      }
    }
  }

  static Future<String> reprintReceipt(
      BuildContext context, String invoiceNo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await RequestConfig(preferences: preferences).get(
        "http://${preferences.getString("networkIpAddress")!}:${preferences.getString("networkPort")!}/api/v1/printers/reprint/" +
            invoiceNo);
    RequestConfig.updateCookie(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap["message"];
    }
    if (response.statusCode == 400) {
      final error = ErrorResponse.fromJson(jsonDecode(response.body));
      return error.errorDescription!;
    } else {
      if (response.statusCode == 401) {
        preferences.remove("session");
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) => false);
        throw Exception();
      } else {
        throw Exception('Failed to get customers.');
      }
    }
  }
}
