import 'package:flutter/material.dart';
import 'package:trj_gold/Screens/pending_screen.dart';
import 'package:trj_gold/models/scheme.dart';

class SchemeCard extends StatelessWidget {
  const SchemeCard({
    super.key,
    required this.schemeData,
  });

  final Scheme schemeData;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 275,
        width:
            double.infinity, // Ensure height fits within carousel constraints
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFf9e09e), Color(0xFF790007)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize Column height
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  schemeData.planName,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: null,
                  child: Text(
                    (schemeData.isPending) ? 'Pending' : 'no pendings',
                    style: TextStyle(
                        color:
                            (schemeData.isPending) ? Colors.red : Colors.green),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            const Text(
              'Amount',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              '\$${schemeData.amount}',
              style: const TextStyle(fontSize: 60, color: Colors.white),
            ),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dateInfo('Date Joined', '21/12/24'),
                dateInfo('Total Paid', schemeData.totalPaid),
                dateInfo('Months Paid', schemeData.monthsPaid),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Pending: \$500',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                (schemeData.isPending)
                    ? SizedBox(
                        height: 30,
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PendingScreen(
                                      schemeid: schemeData.schemeid),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFf9e09e),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: const Text('Pay Now'),
                        ),
                      )
                    : const Text('No Months Pending ',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column dateInfo(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
