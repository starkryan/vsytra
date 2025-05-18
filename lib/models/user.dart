class User {
  final String id;
  final String username;
  final String displayName;
  final String? profileImage;
  final String? bio;
  final int followers;
  final int following;
  final int diamonds; // Virtual currency
  final bool isLive;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.profileImage,
    this.bio,
    this.followers = 0,
    this.following = 0,
    this.diamonds = 0,
    this.isLive = false,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      profileImage: json['profileImage'],
      bio: json['bio'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      diamonds: json['diamonds'] ?? 0,
      isLive: json['isLive'] ?? false,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'profileImage': profileImage,
      'bio': bio,
      'followers': followers,
      'following': following,
      'diamonds': diamonds,
      'isLive': isLive,
      'isVerified': isVerified,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? profileImage,
    String? bio,
    int? followers,
    int? following,
    int? diamonds,
    bool? isLive,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      diamonds: diamonds ?? this.diamonds,
      isLive: isLive ?? this.isLive,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
