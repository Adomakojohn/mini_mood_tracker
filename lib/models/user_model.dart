class UserModel {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
  });

  // Convert from Supabase User object to our UserModel
  factory UserModel.fromSupabase(dynamic user, {String? displayName}) {
    if (user == null) {
      throw Exception('User object is null');
    }

    if (user.id == null) {
      throw Exception('User ID is null');
    }

    DateTime createdAt;
    try {
      createdAt = DateTime.parse(
        user.createdAt ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      createdAt = DateTime.now();
    }

    return UserModel(
      id: user.id.toString(),
      email: user.email?.toString() ?? '',
      name: displayName ?? user.userMetadata?['name']?.toString(),
      createdAt: createdAt,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
