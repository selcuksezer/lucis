import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucis/authentication/exceptions.dart';

abstract class AuthService {
  Future<void> register({
    required String userId,
    required String userName,
    required String email,
    required String password,
  });
  Future<String?> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> register({
    required String userId,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      // check auth db if user exists
      final authRef = _firestore.collection('auth');
      final authDoc = await authRef.doc(email).get();
      if (authDoc.data()?.keys.first == userId) {
        throw const UserAlreadyExistsException('User already exists!');
      }
      // add user data to auth db
      await authRef.doc(email).set({userId: userId});

      // register user with firebase auth
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const MailAlreadyExistsException('Mail already in-use!');
      } else if (e.code == 'invalid-email') {
        throw const MailInvalidException('Invalid e-mail!');
      } else if (e.code == 'weak-password') {
        throw const WeakPasswordException('Weak password!!');
      }
    } catch (e) {
      throw (UnknownAuthException(
          'Unknown exception occurred! ${e.toString()}'));
    }
  }

  @override
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // get user id from auth db
      final authRef = _firestore.collection('auth');
      final authDoc = await authRef.doc(email).get();
      final userId = authDoc.data()?.keys.first;
      if (userId == null) {
        throw const UserNotFoundException('User does not exist!');
      }

      // login user with firebase auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return userId;
    } on UserNotFoundException {
      throw const UserNotFoundException('User does not exist!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UserNotFoundException('User not found!');
      } else if (e.code == 'invalid-email') {
        throw const MailInvalidException('Invalid e-mail!');
      } else if (e.code == 'wrong-password') {
        throw const PasswordIncorrectException('Wrong password!');
      } else if (e.code == 'user-disabled') {
        throw const UserDisabledException('User disabled!');
      }
    } catch (e) {
      throw (UnknownAuthException(
          'Unknown exception occurred! ${e.toString()}'));
    }
    return null;
  }

  @override
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw (UnknownAuthException(
          'Unknown exception occurred! ${e.toString()}'));
    }
  }
}
