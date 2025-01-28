import '../domain/entity.dart';

/// A base repository interface that defines common CRUD operations
/// Type [T] represents the entity type which must extend Entity
abstract class IRepository<T extends Entity> {
  Future<List<T>> getAll();

  Future<T?> getById(String id);

  Future<T> create(T entity);

  Future<T> update(T entity);

  Future<void> delete(String id);

  Stream<List<T>> watchAll();

  Stream<T?> watchById(String id);
} 