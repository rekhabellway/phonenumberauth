import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen(this.phone, {super.key});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();


  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +1-${widget.phone}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,

              controller: _pinPutController,

              pinAnimationType: PinAnimationType.fade,
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())));
                }
              },
            ),
          )
        ],
      ),
    );
  }


// Future<void> Login() async {
//   await auth.verifyPhoneNumber(
//     phoneNumber: _phoneController.text,
//     verificationCompleted: (PhoneAuthCredential credential) async {
//       await auth.signInWithCredential(credential);
//     },
//     verificationFailed: (FirebaseAuthException e) {
//       if (e.code == 'invalid-phone-number') {
//         if (kDebugMode) {
//           print('The provided phone number is not valid.');
//         }
//       }
//     },
//     codeSent: (String verificationId, int? resendToken)
//     async {
//       String smsCode = 'xxxx';
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
//       await auth.signInWithCredential(credential);
//     },
//     timeout: const Duration(seconds: 60),
//     codeAutoRetrievalTimeout: (String verificationId) {
//     },
//   );
}