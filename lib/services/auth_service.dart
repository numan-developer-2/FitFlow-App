// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseAuth _auth = FirebaseAuth.instance;

  // static User? get currentUser => _auth.currentUser;

  // static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // static Future<UserCredential> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  // ) async {
  //   return await _auth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  // }

  // static Future<UserCredential> createUserWithEmailAndPassword(
  //   String email,
  //   String password,
  // ) async {
  //   return await _auth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  // }

  // static Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // static Future<void> updateUserProfile({
  //   String? displayName,
  //   String? photoURL,
  // }) async {
  //   await _auth.currentUser?.updateDisplayName(displayName);
  //   await _auth.currentUser?.updatePhotoURL(photoURL);
  // }

  // static Future<void> createUserProfile({
  //   required String userId,
  //   required String email,
  //   required String displayName,
  //   String? photoURL,
  //   Map<String, dynamic>? additionalData,
  // }) async {
  //   await _firestore.collection('users').doc(userId).set({
  //     'email': email,
  //     'displayName': displayName,
  //     'photoURL': photoURL,
  //     'createdAt': FieldValue.serverTimestamp(),
  //     'lastLoginAt': FieldValue.serverTimestamp(),
  //     ...?additionalData,
  //   });
  // }

  // static Future<void> updateUserProfileData({
  //   required String userId,
  //   Map<String, dynamic> data,
  // }) async {
  //   await _firestore.collection('users').doc(userId).update({
  //     ...data,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   });
  // }

  // Mock methods for development
  static bool get isAuthenticated => false;
  static String? get currentUserId => null;

  static Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    // Mock authentication
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    // Mock registration
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<void> signOut() async {
    // Mock sign out
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<User> signUpWithEmail(
    String email,
    String password,
    String name,
    int age,
    double weight,
    double height,
    String fitnessGoal,
  ) async {
    try {
      // final userCredential = await _auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // Mock user creation - in real app this would check Firebase user
      // if (userCredential.user == null) {
      //   throw Exception('Failed to create user');
      // }

      // Store additional user data in Firestore
      // await _firestore.collection('users').doc(userCredential.user!.uid).set({
      //   'name': name,
      //   'email': email,
      //   'age': age,
      //   'weight': weight,
      //   'height': height,
      //   'fitnessGoal': fitnessGoal,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      return User(
        uid: /* userCredential.user!.uid */
            'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    try {
      // final userCredential = await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // Mock user sign in - in real app this would check Firebase user
      // if (userCredential.user == null) {
      //   throw Exception('Failed to sign in');
      // }

      // await _firestore.collection('users').doc(userCredential.user!.uid).update({
      //   'lastSignInTime': FieldValue.serverTimestamp(),
      // });

      return User(
        uid: /* userCredential.user!.uid */
            'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        email: /* userCredential.user!.email ?? '' */ email,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
