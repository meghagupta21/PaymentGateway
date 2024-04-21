import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class RazarPay extends StatefulWidget {
  const RazarPay({super.key});

  @override
  State<RazarPay> createState() => _RazarPayState();
}

class _RazarPayState extends State<RazarPay> {
  late Razorpay _razorpay;
  TextEditingController amountController=TextEditingController();
  String _errorMessage='';
  void openCheckout(amount) async {
    String amount = amountController.text.trim();
    if (amount.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid amount.';
      });
    } else {
      // Implement payment logic here

      int amountInPaise = int.parse(amount) * 100;
      var options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag',
        'amount': amountInPaise,
        'name': 'Megha Gupta',
        'description': 'Testing',
        'send_sms_hash': true,
        'prefill': {
          'contact': '8605150612',
          'email': 'megha@razorpay.com'
        },
        'external': {
          'wallets': ['paytm'] //external payment options
        }
      };

      // _razorpay.on(
      //     Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
      //     handlePaymentSuccessResponse);
      // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
      //     handleExternalWalletSelected);
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error :e');
      }
    }
  }


  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg:"External Wallet Selected"+response.walletName!,toastLength: Toast.LENGTH_SHORT);
  }
  void handlePaymentSucess(PaymentSuccessResponse response){
    //print(response.subscriptionId);
    // Map<dynamic, dynamic> responseData = response.data;
    // String subscriptionId = response.subscriptionId; // Assuming this is how you access the subscription ID
    // responseData['razorpay_subscription_id'] = subscriptionId;

    // Use the modified responseData as needed
    Fluttertoast.showToast(msg: "Payment Sucessfull"+response.paymentId!,toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentFailure(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Payment Failure"+response.message!,toastLength: Toast.LENGTH_SHORT);
    print(response.message);
    print(response.message);
  }
  @override
  void dispose(){
    super.dispose();
    _razorpay.clear();
  }
  @override
  void initState(){
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,handlePaymentSucess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handleExternalWalletSelected);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RazorPay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 10.0),
                if (_errorMessage != null)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed:(){openCheckout(amountController.text);},
                  child: Text('Make Payment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
