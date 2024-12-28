import 'package:flutter/material.dart';
import 'package:trj_gold/models/PendingPayments.dart';

class Pendingrow extends StatelessWidget {
  final PendingModel model;
  Pendingrow({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(model.payment_id.toString()),
      title: Text(model.plan_name),
      subtitle: Text(model.duemonth),
      trailing: Column(
        children: [
          Text(model.amount.toString()),
          Text(model.Status),
        ],
      ),
    );
  }
}
