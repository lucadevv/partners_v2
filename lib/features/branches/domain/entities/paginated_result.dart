import 'package:equatable/equatable.dart';

/// Meta de paginación (backend: meta.current_page, last_page, per_page, total).
class PaginationMeta extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  int get nextPage => currentPage + 1;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}

/// Resultado paginado genérico para listados (categorías, etc.).
class PaginatedResult<T> extends Equatable {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResult({
    required this.data,
    required this.meta,
  });

  @override
  List<Object?> get props => [data, meta];
}
