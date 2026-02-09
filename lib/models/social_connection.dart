// import 'package:cloud_firestore/cloud_firestore.dart';

class SocialConnection {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String? userBio;
  final ConnectionStatus status;
  final DateTime timestamp;
  final DateTime? lastActivity;

  SocialConnection({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    this.userBio,
    required this.status,
    required this.timestamp,
    this.lastActivity,
  });

  // Getter for connectedUserId (alias for userId)
  String get connectedUserId => userId;

  // factory SocialConnection.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return SocialConnection(
  //     id: doc.id,
  //     userId: data['userId'] ?? '',
  //     userName: data['userName'] ?? '',
  //     userProfileImage: data['userProfileImage'] ?? '',
  //     userBio: data['userBio'],
  //     status: _connectionStatusFromString(data['status'] ?? ''),
  //     timestamp: (data['timestamp'] as Timestamp).toDate(),
  //     lastActivity: data['lastActivity'] != null
  //         ? (data['lastActivity'] as Timestamp).toDate()
  //         : null,
  //   );
  // }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'userBio': userBio,
      'status': status.name,
      'timestamp': timestamp,
      'lastActivity': lastActivity,
    };
  }

  SocialConnection copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? userBio,
    ConnectionStatus? status,
    DateTime? timestamp,
    DateTime? lastActivity,
  }) {
    return SocialConnection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      userBio: userBio ?? this.userBio,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}

enum ConnectionStatus {
  pending,
  accepted,
  blocked,
}
