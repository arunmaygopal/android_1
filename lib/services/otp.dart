import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static String vId = "";
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
      },
      verificationFailed: (FirebaseAuthException e) {},

      codeSent: (String verificationId, int? resendToken) {
        vId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyOTP( String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: vId,
      smsCode: code,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    return true;
    } catch (e) {     
      return false;
    }

  }
}