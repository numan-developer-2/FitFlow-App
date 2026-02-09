// import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/social_connection.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class SocialService {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final CollectionReference _connectionsCollection = _firestore.collection('social_connections');
  // static final CollectionReference _usersCollection = _firestore.collection('users');

  // static Stream<QuerySnapshot> getConnectionsStream(String userId) {
  //   return _connectionsCollection
  //       .where('userId', isEqualTo: userId)
  //       .snapshots();
  // }

  // static Stream<QuerySnapshot> getUsersStream() {
  //   return _usersCollection
  //       .orderBy('displayName')
  //       .limit(50)
  //       .snapshots();
  // }

  // static Future<void> createConnection(SocialConnection connection) async {
  //   await _connectionsCollection.add({
  //     'userId': connection.userId,
  //     'userName': connection.userName,
  //     'userProfileImage': connection.userProfileImage,
  //     'userBio': connection.userBio,
  //     'status': connection.status.name,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     'lastActivity': connection.lastActivity,
  //   });
  // }

  // Mock methods for development
  static List<SocialConnection> getMockConnections() {
    return [
      SocialConnection(
        id: '1',
        userId: 'user2',
        userName: 'Jane Smith',
        userProfileImage: 'https://example.com/profile2.jpg',
        userBio: 'Fitness enthusiast',
        status: ConnectionStatus.accepted,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SocialConnection(
        id: '2',
        userId: 'user3',
        userName: 'Mike Johnson',
        userProfileImage: 'https://example.com/profile3.jpg',
        userBio: 'Gym trainer',
        status: ConnectionStatus.pending,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        lastActivity: null,
      ),
    ];
  }

  static Future<void> createConnection(SocialConnection connection) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> updateConnectionStatus(
      String connectionId, ConnectionStatus status) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 300));
      return User(
        uid: userId,
        email: 'mock@example.com',
        name: 'Mock User',
        fitnessGoal: 'Build muscle',
      );
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      return null;
    }
  }

  // Remove connection
  Future<void> removeConnection(String connectionId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('Error removing connection: $e');
    }
  }

  // Search users
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        {
          'id': 'user1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'profileImageUrl': 'https://example.com/profile1.jpg',
        },
        {
          'id': 'user2',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'profileImageUrl': 'https://example.com/profile2.jpg',
        },
      ];
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  // Get user's connections
  Future<List<SocialConnection>> getUserConnections(String userId) async {
    try {
      // QuerySnapshot snapshot = await _connectionsCollection
      //     .where('userId', isEqualTo: userId)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => SocialConnection.fromFirestore(doc))
      //     .toList();
      return [];
    } catch (e) {
      debugPrint('Error getting user connections: $e');
      return [];
    }
  }

  // Get all users for search
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      // QuerySnapshot snapshot = await _usersCollection
      //     .orderBy('displayName')
      //     .limit(50)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => {
      //       'id': doc.id,
      //       ...doc.data() as Map<String, dynamic>,
      //     })
      //     .toList();
      return [];
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  // Send connection request
  Future<bool> sendConnectionRequest(
      String fromUserId, String toUserId, ConnectionType type) async {
    try {
      // await _connectionsCollection.add({
      //   'fromUserId': fromUserId,
      //   'toUserId': toUserId,
      //   'status': 'pending',
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
      return true;
    } catch (e) {
      debugPrint('Error sending connection request: $e');
      return false;
    }
  }

  // Accept connection request
  Future<bool> acceptConnectionRequest(String connectionId) async {
    try {
      // await _connectionsCollection.doc(connectionId).update({
      //   'status': 'accepted',
      //   'acceptedAt': FieldValue.serverTimestamp(),
      // });
      return true;
    } catch (e) {
      debugPrint('Error accepting connection request: $e');
      return false;
    }
  }

  // Reject connection request
  Future<bool> rejectConnectionRequest(String connectionId) async {
    try {
      // await _connectionsCollection.doc(connectionId).update({
      //   'status': 'rejected',
      //   'rejectedAt': FieldValue.serverTimestamp(),
      // });
      return true;
    } catch (e) {
      debugPrint('Error rejecting connection request: $e');
      return false;
    }
  }

  // Block user
  Future<bool> blockUser(String fromUserId, String toUserId) async {
    try {
      // await _connectionsCollection.add({
      //   'fromUserId': fromUserId,
      //   'toUserId': toUserId,
      //   'status': 'blocked',
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
      return true;
    } catch (e) {
      debugPrint('Error blocking user: $e');
      return false;
    }
  }

  // Unblock user
  Future<bool> unblockUser(String connectionId) async {
    try {
      // await _connectionsCollection.doc(connectionId).delete();
      return true;
    } catch (e) {
      debugPrint('Error unblocking user: $e');
      return false;
    }
  }

  // Get pending requests
  Future<List<SocialConnection>> getPendingRequests(String userId) async {
    try {
      // QuerySnapshot snapshot = await _connectionsCollection
      //     .where('toUserId', isEqualTo: userId)
      //     .where('status', isEqualTo: 'pending')
      //     .get();

      // return snapshot.docs
      //     .map((doc) => SocialConnection.fromFirestore(doc))
      //     .toList();
      return [];
    } catch (e) {
      debugPrint('Error getting pending requests: $e');
      return [];
    }
  }
}

enum ConnectionType {
  friend,
  trainer,
  gym,
}
