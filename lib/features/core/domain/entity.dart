import 'package:uuid/uuid.dart';

/// Base class for all domain entities.
/// 
/// Provides common functionality like ID generation, creation timestamp,
/// and JSON serialization support.
abstract class Entity {
  final String id;
  final DateTime createdAt;

  Entity({
    String? id,
    DateTime? createdAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  
  static Entity fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }

  String dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

  DateTime dateTimeFromJson(String dateTime) => DateTime.parse(dateTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
} 