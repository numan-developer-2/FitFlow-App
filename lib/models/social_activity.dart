// import 'package:cloud_firestore/cloud_firestore.dart';

class SocialActivity {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String activityType;
  final String activityDescription;
  final DateTime timestamp;
  final int? workoutDuration;
  final String? workoutType;
  final int? caloriesBurned;
  final List<String> likes;
  final List<ActivityComment> comments;
  final bool isPublic;

  SocialActivity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.activityType,
    required this.activityDescription,
    required this.timestamp,
    this.workoutDuration,
    this.workoutType,
    this.caloriesBurned,
    required this.likes,
    required this.comments,
    required this.isPublic,
  });

  // Getter for likedByUsers (alias for likes)
  List<String> get likedByUsers => likes;

  // factory SocialActivity.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return SocialActivity(
  //     id: doc.id,
  //     userId: data['userId'] ?? '',
  //     userName: data['userName'] ?? '',
  //     userProfileImage: data['userProfileImage'] ?? '',
  //     activityType: data['activityType'] ?? '',
  //     activityDescription: data['activityDescription'] ?? '',
  //     timestamp: (data['timestamp'] as Timestamp).toDate(),
  //     workoutDuration: data['workoutDuration'],
  //     workoutType: data['workoutType'],
  //     caloriesBurned: data['caloriesBurned'],
  //     likes: List<String>.from(data['likes'] ?? []),
  //     comments: (data['comments'] as List<dynamic>?)
  //             ?.map((comment) => ActivityComment.fromMap(comment))
  //             .toList() ??
  //         [],
  //     isPublic: data['isPublic'] ?? true,
  //   );
  // }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'activityType': activityType,
      'activityDescription': activityDescription,
      'timestamp': timestamp,
      'workoutDuration': workoutDuration,
      'workoutType': workoutType,
      'caloriesBurned': caloriesBurned,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'isPublic': isPublic,
    };
  }

  SocialActivity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? activityType,
    String? activityDescription,
    DateTime? timestamp,
    int? workoutDuration,
    String? workoutType,
    int? caloriesBurned,
    List<String>? likes,
    List<ActivityComment>? comments,
    bool? isPublic,
  }) {
    return SocialActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      activityType: activityType ?? this.activityType,
      activityDescription: activityDescription ?? this.activityDescription,
      timestamp: timestamp ?? this.timestamp,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      workoutType: workoutType ?? this.workoutType,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}

class ActivityComment {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String content;
  final DateTime timestamp;
  final List<String> likes;

  ActivityComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  // Additional constructor for backward compatibility
  ActivityComment.create({
    required String userId,
    required String userName,
    required String content,
    required DateTime timestamp,
    String? userPhotoUrl,
    String? text,
    DateTime? createdAt,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        userId = userId,
        userName = userName,
        userProfileImage = userPhotoUrl ?? '',
        content = text ?? content,
        timestamp = createdAt ?? timestamp,
        likes = [];

  // factory ActivityComment.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return ActivityComment(
  //     id: doc.id,
  //     userId: data['userId'] ?? '',
  //     userName: data['userName'] ?? '',
  //     userProfileImage: data['userProfileImage'] ?? '',
  //     content: data['content'] ?? '',
  //     timestamp: (data['timestamp'] as Timestamp).toDate(),
  //     likes: List<String>.from(data['likes'] ?? []),
  //   );
  // }

  factory ActivityComment.fromMap(Map<String, dynamic> map) {
    return ActivityComment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      content: map['content'] ?? '',
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
    };
  }
}

enum ActivityType {
  general,
  workoutCompleted,
  achievementUnlocked,
  milestoneReached,
  challengeStarted,
  challengeCompleted,
  sharedWorkout,
}
