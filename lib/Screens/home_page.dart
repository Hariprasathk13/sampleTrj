import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:http/http.dart' as http;
import 'package:trj_gold/enviroinment.dart';
import 'package:trj_gold/models/scheme.dart';
import 'package:trj_gold/models/user.dart';
import 'package:trj_gold/widgets/scemes._card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.token});
  final String token;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<dynamic> _futureData;

  Future<dynamic> getUserProfile() async {
    const String url = '$apiUrl/getuserprofile';
    var headers = {
      'Authorization': widget.token.toString(),
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      final responseData = json.decode(response.body);

      if (responseData['status'] == 200) {
        return responseData['user'];
      } else {
        throw Exception('Unable to fetch data');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF790007),
      //   title: const Text('Homepage'),
      //   leading: Image.asset("assets/trj.png", width: 40, height: 40),
      //   actions: const [
      //     Icon(Icons.notifications_none_sharp, color: Colors.white),
      //     SizedBox(width: 8),
      //     Icon(Icons.settings, color: Colors.white),
      //   ],
      // ),
      body: FutureBuilder(
        future: _futureData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data as Map<String, dynamic>;
          final plans = data['plans'] as List<dynamic>?;

          // Ensure 'plans' is not null or empty
          if (plans == null || plans.isEmpty) {
            return const Center(child: Text('No plans available.'));
          }

          return Container(
            color: const Color(0xFF790007),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: const Color(0xFF790007),
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              // Image.asset("assets/trj.png",
                              //     width: 40, height: 40),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              const Text(
                                'Thanga Roja Jwellery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notification_add,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF3E0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                'Hello ${data['username']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            metalRateWidget(),
                            const SizedBox(height: 15),
                            adSlider(),
                            const SizedBox(height: 25),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                "Your Schemes",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: plans.map((plan) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Container(
                                      color: const Color(0xFFFAF3E0),
                                      width: 380,
                                      height:
                                          285, // Set a fixed width for each card
                                      child: SchemeCard(
                                        schemeData: Scheme(
                                          schemeid: plan['plan_id'].toString(),
                                          planName: plan['plan_name'] ??
                                              'Unnamed Plan',
                                          isPending:
                                              plan['is_pending'] ?? false,
                                          amount:
                                              plan['amount']?.toString() ?? '0',
                                          dataJoined: plan['data_joined'] ?? '',
                                          totalPaid:
                                              plan['total_paid']?.toString() ??
                                                  '0',
                                          monthsPaid:
                                              plan['months_paid']?.toString() ??
                                                  '0',
                                          pending: plan['months_pending']
                                                  .toString() ??
                                              '0',
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget metalRateWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Metal Rates",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _metalRow("Gold", "\$1800", Icons.arrow_upward, Colors.green),
          const Divider(),
          _metalRow("Silver", "\$25", Icons.arrow_downward, Colors.red),
        ],
      ),
    );
  }

  Widget _metalRow(String metal, String rate, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          metal,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        Row(
          children: [
            Text(
              rate,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Icon(icon, size: 16, color: color),
          ],
        ),
      ],
    );
  }

  Widget adSlider() {
    return FlutterCarousel(
      options: FlutterCarouselOptions(
        height: 150,
        autoPlay: true,
        showIndicator: true,
        indicatorMargin: 5,
        slideIndicator: CircularWaveSlideIndicator(),
      ),
      items: List.generate(5, (i) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(
            'assets/trj.png',
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }
}
