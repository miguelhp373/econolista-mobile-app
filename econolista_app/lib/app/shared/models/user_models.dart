// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModels {
  String userEmail;
  String userName;
  DateTime userDateTimeCreated;
  Map<String, dynamic>? userStoreCollection; // Campo opcional

  UserModels({
    required this.userEmail,
    this.userName = '',
    DateTime? userDateTimeCreated, // Modificado para DateTime
    this.userStoreCollection, // Adicionado campo opcional
  }) : userDateTimeCreated = userDateTimeCreated ?? DateTime.now();

  UserModels copyWith({
    String? userEmail,
    String? userName,
    DateTime? userDateTimeCreated, // Modificado para DateTime
    Map<String, dynamic>? userStoreCollection, // Adicionado campo opcional
  }) {
    return UserModels(
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userDateTimeCreated: userDateTimeCreated ?? this.userDateTimeCreated,
      userStoreCollection: userStoreCollection ?? this.userStoreCollection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'userName': userName,
      'userDateTimeCreated': userDateTimeCreated
          .toUtc()
          .toIso8601String(), // Convertendo para String no formato ISO
      'userStoreCollection': userStoreCollection, // Adicionando campo opcional
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? '',
      userDateTimeCreated: DateTime.parse(map['userDateTimeCreated'] ?? ''),
      userStoreCollection:
          map['userStoreCollection'], // Adicionando campo opcional
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModels.fromJson(String source) =>
      UserModels.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModels(userEmail: $userEmail, userName: $userName, userDateTimeCreated: $userDateTimeCreated, userStoreCollection: $userStoreCollection)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModels &&
        other.userEmail == userEmail &&
        other.userName == userName &&
        other.userDateTimeCreated == userDateTimeCreated &&
        mapEquals(
            other.userStoreCollection, userStoreCollection); // Comparando Mapas
  }

  @override
  int get hashCode =>
      userEmail.hashCode ^
      userName.hashCode ^
      userDateTimeCreated.hashCode ^
      userStoreCollection.hashCode; // Adicionando o hashCode do campo opcional
}
