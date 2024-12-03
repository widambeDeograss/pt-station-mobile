// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pts/models/error_response.dart';
import 'package:pts/models/resolve_customer.dart';

class ResolveCustomerWarapper {
  ResolveCustomer? customers;
  ErrorResponse? errorResponse;
  ResolveCustomerWarapper({
    this.customers,
    this.errorResponse,
  });

  ResolveCustomerWarapper copyWith({
    ResolveCustomer? customers,
    ErrorResponse? errorResponse,
  }) {
    return ResolveCustomerWarapper(
      customers: customers ?? this.customers,
      errorResponse: errorResponse ?? this.errorResponse,
    );
  }

  @override
  String toString() =>
      'ResolveCustomerWarapper(customers: $customers, errorResponse: $errorResponse)';

  @override
  bool operator ==(covariant ResolveCustomerWarapper other) {
    if (identical(this, other)) return true;

    return other.customers == customers && other.errorResponse == errorResponse;
  }

  @override
  int get hashCode => customers.hashCode ^ errorResponse.hashCode;
}
