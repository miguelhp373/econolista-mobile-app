import 'dart:convert';

class UserStoreModels {
  String storeName;
  UserStoreModels({
    required this.storeName,
  });

  UserStoreModels copyWith({
    String? storeName,
  }) {
    return UserStoreModels(
      storeName: storeName ?? this.storeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
    };
  }

  factory UserStoreModels.fromMap(Map<String, dynamic> map) {
    return UserStoreModels(
      storeName: map['storeName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStoreModels.fromJson(String source) =>
      UserStoreModels.fromMap(json.decode(source));

  @override
  String toString() => 'UserStoreModels(storeName: $storeName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserStoreModels && other.storeName == storeName;
  }

  @override
  int get hashCode => storeName.hashCode;
}
