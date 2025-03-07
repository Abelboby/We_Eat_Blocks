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
  final String? walletAddress;
  final DateTime? walletConnectedAt;
  final String? previousWalletAddress;
  final String? lastWalletAddress;
  final DateTime? walletReplacedAt;
  final DateTime? walletDisconnectedAt;
  final String? bio;

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
    this.walletAddress,
    this.walletConnectedAt,
    this.previousWalletAddress,
    this.lastWalletAddress,
    this.walletReplacedAt,
    this.walletDisconnectedAt,
    this.bio,
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
    String? walletAddress,
    DateTime? walletConnectedAt,
    String? previousWalletAddress,
    String? lastWalletAddress,
    DateTime? walletReplacedAt,
    DateTime? walletDisconnectedAt,
    String? bio,
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
      walletAddress: walletAddress ?? this.walletAddress,
      walletConnectedAt: walletConnectedAt ?? this.walletConnectedAt,
      previousWalletAddress:
          previousWalletAddress ?? this.previousWalletAddress,
      lastWalletAddress: lastWalletAddress ?? this.lastWalletAddress,
      walletReplacedAt: walletReplacedAt ?? this.walletReplacedAt,
      walletDisconnectedAt: walletDisconnectedAt ?? this.walletDisconnectedAt,
      bio: bio ?? this.bio,
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
      'walletAddress': walletAddress,
      'walletConnectedAt': walletConnectedAt?.millisecondsSinceEpoch,
      'previousWalletAddress': previousWalletAddress,
      'lastWalletAddress': lastWalletAddress,
      'walletReplacedAt': walletReplacedAt?.millisecondsSinceEpoch,
      'walletDisconnectedAt': walletDisconnectedAt?.millisecondsSinceEpoch,
      'bio': bio,
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
      walletAddress: map['walletAddress'],
      walletConnectedAt: map['walletConnectedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['walletConnectedAt'])
          : null,
      previousWalletAddress: map['previousWalletAddress'],
      lastWalletAddress: map['lastWalletAddress'],
      walletReplacedAt: map['walletReplacedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['walletReplacedAt'])
          : null,
      walletDisconnectedAt: map['walletDisconnectedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['walletDisconnectedAt'])
          : null,
      bio: map['bio'],
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
      walletAddress: map['walletAddress'],
      walletConnectedAt: map['walletConnectedAt']?.toDate(),
      previousWalletAddress: map['previousWalletAddress'],
      lastWalletAddress: map['lastWalletAddress'],
      walletReplacedAt: map['walletReplacedAt']?.toDate(),
      walletDisconnectedAt: map['walletDisconnectedAt']?.toDate(),
      bio: map['bio'],
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
      'walletAddress': walletAddress,
      'bio': bio,
      // Don't include ID as it's the document ID
      // Use server timestamp for these fields when creating/updating
    };
  }

  bool get isAuthenticated => id.isNotEmpty;
  bool get hasWallet => walletAddress != null && walletAddress!.isNotEmpty;
  bool get hasReplacedWallet =>
      previousWalletAddress != null && previousWalletAddress!.isNotEmpty;
}
