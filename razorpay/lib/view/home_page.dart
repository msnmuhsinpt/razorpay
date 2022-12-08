import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Razorpay razorpay;
  TextEditingController amount = TextEditingController();
  var msg;

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  //payment successful
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    msg = "SUCCESS: ${response.paymentId}";
    showToast(msg);
  }

  //payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    msg =
        "ERROR: ${response.code} - ${jsonDecode(response.message.toString())['error']['description']}";
    showToast(msg);
  }

//payment wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    msg = "EXTERNAL_WALLET: ${response.walletName}";
    showToast(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amount,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Amount',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                openChecF();
              },
              child: const Text('Pay'),
            )
          ],
        ),
      ),
    );
  }

  void openChecF() async {
    var options = {
      'key': 'rzp_test_WC7STPHErvWsZg',
      'amount': num.parse(amount.text) * 100,
      'name': 'muhsin',
      'description': 'Payment',
      'prefill': {'contact': '2323232323', 'email': 'msnmuhin83@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.withOpacity(0.1),
      textColor: Colors.black54,
    );
  }
}
