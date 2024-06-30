import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNo = TextEditingController();
  final TextEditingController password = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  AuthStatus _status = AuthStatus.unauthenticated;

  AuthStatus get status => _status;

  final _statusSubject = BehaviorSubject<AuthStatus>.seeded(AuthStatus.unauthenticated);

  Stream<AuthStatus> get statusStream => _statusSubject.stream;

  AuthProvider() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  Future<User?> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      _statusSubject.add(_status);
      notifyListeners();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);

        final User? user = authResult.user;

        _status = AuthStatus.authenticated;
        _statusSubject.add(_status);
        notifyListeners();

        return user;
      } else {
        print('Google Sign-in canceled');
        _status = AuthStatus.unauthenticated;
        _statusSubject.add(_status);
        notifyListeners();
        return null;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      _status = AuthStatus.error;
      _statusSubject.add(_status);
      notifyListeners();
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _statusSubject.add(_status);
      notifyListeners();

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.authenticated;
      _statusSubject.add(_status);
      notifyListeners();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error signing up with email and password: $e');
      _status = AuthStatus.error;
      _statusSubject.add(_status);
      notifyListeners();
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword() async {
    try {
      _status = AuthStatus.authenticating;
      _statusSubject.add(_status);
      notifyListeners();

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      _status = AuthStatus.authenticated;
      _statusSubject.add(_status);
      notifyListeners();

      return userCredential.user;
    } catch (error) {
      print('Error signing in with email and password: $error');
      _status = AuthStatus.error;
      _statusSubject.add(_status);
      notifyListeners();
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    _status = AuthStatus.unauthenticated;
    _statusSubject.add(_status);
    notifyListeners();
  }

  Future<User?> checkAuthState() async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        _status = AuthStatus.authenticated;
        _statusSubject.add(_status);
        notifyListeners();
        return currentUser;
      } else {
        await for (User? user in _auth.authStateChanges()) {
          if (user != null) {
            _status = AuthStatus.authenticated;
            _statusSubject.add(_status);
            notifyListeners();
            return user;
          }
        }
        _status = AuthStatus.unauthenticated;
        _statusSubject.add(_status);
        notifyListeners();
      }
    } catch (error) {
      print('Error checking authentication state: $error');
      _status = AuthStatus.error;
      _statusSubject.add(_status);
      notifyListeners();
      return null;
    }
  }

  void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email).catchError((error) {
      print('Error sending password reset email: $error');
    });
  }

  void _authStateChanged(User? user) {
    if (user == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _status = AuthStatus.authenticated;
    }
    _statusSubject.add(_status);
    notifyListeners();
  }

  @override
  void dispose() {
    _statusSubject.close();
    super.dispose();
  }
}
