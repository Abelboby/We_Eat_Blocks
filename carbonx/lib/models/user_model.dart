class UserModel {
  final String id;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String? provider;
  final int carbonCredits;
  final double carbonFootprint;
  final int offsetPercentage;

  UserModel({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.lastLoginAt,
    this.provider,
    this.carbonCredits = 0,
    this.carbonFootprint = 0.0,
    this.offsetPercentage = 0,
  });

  factory UserModel.fromFirebase(dynamic user) {
    try {
      return UserModel(
        id: user.uid ?? '',
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
        provider: 'firebase', // Simple default provider name
      );
    } catch (e) {
      print('Error creating UserModel from Firebase user: $e');
      // Create a minimal user model with just the ID
      try {
        return UserModel(
          id: user.uid ?? '',
        );
      } catch (_) {
        // Absolute fallback if we can't even get the UID
        return UserModel(id: '');
      }
    }
  }

  factory UserModel.empty() {
    return UserModel(id: '');
  }

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? provider,
    int? carbonCredits,
    double? carbonFootprint,
    int? offsetPercentage,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      provider: provider ?? this.provider,
      carbonCredits: carbonCredits ?? this.carbonCredits,
      carbonFootprint: carbonFootprint ?? this.carbonFootprint,
      offsetPercentage: offsetPercentage ?? this.offsetPercentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'provider': provider,
      'carbonCredits': carbonCredits,
      'carbonFootprint': carbonFootprint,
      'offsetPercentage': offsetPercentage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : null,
      provider: map['provider'],
      carbonCredits: map['carbonCredits'] ?? 0,
      carbonFootprint: map['carbonFootprint'] ?? 0.0,
      offsetPercentage: map['offsetPercentage'] ?? 0,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt']?.toDate(),
      lastLoginAt: map['lastLoginAt']?.toDate(),
      provider: map['provider'],
      carbonCredits: map['carbonCredits'] ?? 0,
      carbonFootprint: map['carbonFootprint'] ?? 0.0,
      offsetPercentage: map['offsetPercentage'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'provider': provider,
      'carbonCredits': carbonCredits,
      'carbonFootprint': carbonFootprint,
      'offsetPercentage': offsetPercentage,
      // Don't include ID as it's the document ID
      // Use server timestamp for these fields when creating/updating
    };
  }

  bool get isAuthenticated => id.isNotEmpty;
}
