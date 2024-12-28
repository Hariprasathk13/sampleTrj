import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:trj_gold/enviroinment.dart';
import 'package:http/http.dart' as http;
import 'package:trj_gold/models/PendingPayments.dart';

import 'package:trj_gold/models/user.dart';
import 'package:trj_gold/widgets/pendingrow.dart';

class PendingScreen extends StatefulWidget {
  final String schemeid;

  PendingScreen({super.key, required this.schemeid});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  User user = User();
  String environment = dotenv.env['environment'].toString();
  String appId = "";
  String merchantId = dotenv.env['merchantId'].toString();
  bool enableLogging = true;

  String packageName = "";
  String saltkey = dotenv.env['saltkey'].toString();
  String saltIndex = dotenv.env['saltIndex'].toString();
  String callbackurl = dotenv.env['callbackurl'].toString();

  String body = "";
  String apiEndPoint = dotenv.env['apiEndPoint'].toString();

  Object? _result;
  String _paymentStatus = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    phonepePaymentInit();
  }

  void phonepePaymentInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                _result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }
  void HandleSucces() async{
     String schemeid = widget.schemeid;
    String Token = user.gettoken();
    final String url = '$apiUrl/paymentstatus?plan_id=$schemeid';
    var headers = {
      'Authorization': Token,
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['data'];
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
  void handleError(error) {
    print(error);
  }

  void startPGTransaction(double amount) async {
    final String transactionId =
        DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, Object> requestData = getRequestData(transactionId, amount);

    String body = getBase64Body(requestData);
    String checksum = getCheckSum(requestData);

    PhonePePaymentSdk.startTransaction(body, callbackurl, checksum, packageName)
        .then((response) async {
      String message = "";
      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          HandleSuccess();
          // await checkPaymentStatus(transactionId);
        } else {
          message = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        message = "Flow Incomplete";
      }

      setState(() {
        _result = message;
      });
    }).catchError((error) {
      handleError(error);
      // return <dynamic>{};
    });
  }

  Map<String, Object> getRequestData(String transactionId, double amount) {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "MUID123",
      "amount": amount,
      "callbackUrl": callbackurl,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "UPI_INTENT"}
    };

    return requestData;
  }

  String getBase64Body(Map<String, Object> requestData) {
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    return base64Body;
  }

  String getCheckSum(Map<String, Object> requestData) {
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    String checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltkey)).toString()}###$saltIndex';

    return checksum;
  }

  Future<dynamic> getPendingPayments() async {
    String schemeid = widget.schemeid;
    String Token = user.gettoken();
    final String url = '$apiUrl/pendingpayments?plan_id=$schemeid';
    var headers = {
      'Authorization': Token,
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['data'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pendingpayments"),
      ),
      body: FutureBuilder(
        future: getPendingPayments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData) {
            List pendingmodels = snapshot.data
                .map(
                    (pendingpayments) => PendingModel.fromjson(pendingpayments))
                .toList();
            final totalpending = pendingmodels
                .map((pendings) => pendings.amount)
                .reduce((a, b) => a + b);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: pendingmodels.length,
                  itemBuilder: (context, index) => Pendingrow(
                    model: pendingmodels[index],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    startPGTransaction(totalpending);
                  },
                  child: Text(
                    "pay now",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  height: 50,
                  color: Colors.blueAccent,
                  minWidth: double.infinity,
                )
              ],
            );
          }
          return Text("no data");
        },
      ),
    );
  }
}
