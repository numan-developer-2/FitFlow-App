class User {
  final String uid;
  final String email;
  final String? name;
  final String? fitnessGoal;
  final int? age;
  final double? weight;
  final double? height;

  User({
    required this.uid,
    required this.email,
    this.name,
    this.fitnessGoal,
    this.age,
    this.weight,
    this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'fitnessGoal': fitnessGoal,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      fitnessGoal: map['fitnessGoal'] as String?,
      age: map['age'] as int?,
      weight: map['weight'] as double?,
      height: map['height'] as double?,
    );
  }
}
