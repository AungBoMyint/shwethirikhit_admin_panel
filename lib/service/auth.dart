import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Auth._();
  //this technique is single tone,
  //whereever you institate this class,this will be
  //only one object.
  factory Auth() => Auth._();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
/* 
  Stream<User?> onAuthChange() => _firebaseAuth.authStateChanges();

  Future<void> login({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) =>
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

  Future<void> loginWithCerdential(AuthCredential credential) =>
      _firebaseAuth.signInWithCredential(credential);

  Future<void> logout() => _firebaseAuth.signOut(); */
}
