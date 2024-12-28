import 'package:flutter/foundation.dart';

class PendingModel {
  final int payment_id;
  final String plan_name;
  final double amount;
  final String duemonth;
  final String Status;

  PendingModel(
      {required this.payment_id,
      required this.plan_name,
      required this.amount,
      required this.duemonth,
      required this.Status});
  factory PendingModel.fromjson(Map json) {
    return PendingModel(
        payment_id: json['payment_id'],
        plan_name: json['plan_name'],
        amount: double.parse(json['amount']),
        duemonth: json['due_month'],
        Status: json['status']);
  }
}
