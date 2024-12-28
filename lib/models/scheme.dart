import 'dart:core';

class Scheme {
  const Scheme( 
      {required this.planName,
      required this.schemeid,
      required this.isPending,
      required this.amount,
      required this.dataJoined,
      required this.totalPaid,
      required this.monthsPaid,
      required this.pending});
  final String schemeid;
  final String planName;
  final bool isPending;
  final String amount;
  final String dataJoined;
  final String totalPaid;
  final String monthsPaid;
  final String pending;
}

