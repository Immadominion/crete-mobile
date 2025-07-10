import 'package:equatable/equatable.dart';

/// Base class for all API response models
abstract class BaseResponse<T> extends Equatable {
  const BaseResponse();

  /// Whether the response was successful
  bool get isSuccess;

  /// The response data
  T? get data;

  /// Error message if any
  String? get error;

  /// Status code
  int? get statusCode;
}

/// Standard API response wrapper
class ApiResponse<T> extends BaseResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) => ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : json['data'] as T?,
      message: json['message'] as String?,
      statusCode: json['status_code'] as int?,
      errors: json['errors'] as Map<String, dynamic>?,
    );

  final bool success;
  @override
  final T? data;
  final String? message;
  @override
  final int? statusCode;
  final Map<String, dynamic>? errors;

  @override
  bool get isSuccess => success;

  @override
  String? get error => message;

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T)? toJsonT) => {
      'success': success,
      'data': toJsonT != null && data != null ? toJsonT(data as T) : data,
      'message': message,
      'status_code': statusCode,
      'errors': errors,
    };

  @override
  List<Object?> get props => [success, data, message, statusCode, errors];
}

/// Paginated response wrapper
class PaginatedResponse<T> extends BaseResponse<List<T>> {
  const PaginatedResponse({
    required this.success,
    required this.data,
    required this.pagination,
    this.message,
    this.statusCode,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) => PaginatedResponse<T>(
      success: json['success'] as bool? ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationMeta.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
      message: json['message'] as String?,
      statusCode: json['status_code'] as int?,
    );

  final bool success;
  @override
  final List<T> data;
  final PaginationMeta pagination;
  final String? message;
  @override
  final int? statusCode;

  @override
  bool get isSuccess => success;

  @override
  String? get error => message;

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
      'success': success,
      'data': data.map(toJsonT).toList(),
      'pagination': pagination.toJson(),
      'message': message,
      'status_code': statusCode,
    };

  @override
  List<Object?> get props => [success, data, pagination, message, statusCode];
}

/// Pagination metadata
class PaginationMeta extends Equatable {
  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalItems: json['total_items'] as int? ?? 0,
      itemsPerPage: json['items_per_page'] as int? ?? 20,
      hasNextPage: json['has_next_page'] as bool? ?? false,
      hasPreviousPage: json['has_previous_page'] as bool? ?? false,
    );

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Map<String, dynamic> toJson() => {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'items_per_page': itemsPerPage,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
    hasNextPage,
    hasPreviousPage,
  ];
}
