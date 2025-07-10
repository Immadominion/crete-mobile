import 'dart:io';
import 'package:flutter/material.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  /// Converts exceptions to failures
  static Failure handleException(Exception exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        final e = exception as NetworkException;
        return NetworkFailure(e.message, code: e.code, details: e.details);

      case ApiException:
        final e = exception as ApiException;
        return ServerFailure(
          e.message,
          statusCode: e.statusCode,
          code: e.code,
          details: e.details,
        );

      case AuthException:
        final e = exception as AuthException;
        return AuthFailure(e.message, code: e.code, details: e.details);

      case WalletException:
        final e = exception as WalletException;
        return WalletFailure(e.message, code: e.code, details: e.details);

      case DaoException:
        final e = exception as DaoException;
        return DaoFailure(e.message, code: e.code, details: e.details);

      case ChatException:
        final e = exception as ChatException;
        return ChatFailure(e.message, code: e.code, details: e.details);

      case GovernanceException:
        final e = exception as GovernanceException;
        return GovernanceFailure(e.message, code: e.code, details: e.details);

      case ValidationException:
        final e = exception as ValidationException;
        return ValidationFailure(
          e.message,
          fieldErrors: e.fieldErrors,
          code: e.code,
          details: e.details,
        );

      case CacheException:
        final e = exception as CacheException;
        return CacheFailure(e.message, code: e.code, details: e.details);

      case StorageException:
        final e = exception as StorageException;
        return StorageFailure(e.message, code: e.code, details: e.details);

      case SocketException:
        return const NetworkFailure(
          'No internet connection',
          code: 'NO_INTERNET',
        );

      case HttpException:
        final e = exception as HttpException;
        return ServerFailure(e.message, code: 'HTTP_ERROR');

      case FormatException:
        final e = exception as FormatException;
        return ParsingFailure(e.message, code: 'FORMAT_ERROR');

      default:
        return ServerFailure(
          'An unexpected error occurred: ${exception.toString()}',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  /// Gets user-friendly error message
  static String getUserFriendlyMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return _getNetworkErrorMessage(failure as NetworkFailure);

      case ServerFailure:
        return _getServerErrorMessage(failure as ServerFailure);

      case AuthFailure:
        return _getAuthErrorMessage(failure as AuthFailure);

      case WalletFailure:
        return _getWalletErrorMessage(failure as WalletFailure);

      case DaoFailure:
        return _getDaoErrorMessage(failure as DaoFailure);

      case ChatFailure:
        return _getChatErrorMessage(failure as ChatFailure);

      case GovernanceFailure:
        return _getGovernanceErrorMessage(failure as GovernanceFailure);

      case ValidationFailure:
        return _getValidationErrorMessage(failure as ValidationFailure);

      case PermissionFailure:
        return "You don't have permission to perform this action.";

      case RateLimitFailure:
        return 'Too many requests. Please try again later.';

      case MaintenanceFailure:
        return 'Service is temporarily unavailable for maintenance.';

      default:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Something went wrong. Please try again.';
    }
  }

  static String _getNetworkErrorMessage(NetworkFailure failure) {
    switch (failure.code) {
      case 'NO_INTERNET':
        return 'No internet connection. Please check your network settings.';
      case 'CONNECTION_FAILED':
        return 'Failed to connect to the server. Please try again.';
      case 'TIMEOUT':
        return 'Request timed out. Please check your connection and try again.';
      default:
        return 'Network error occurred. Please check your connection.';
    }
  }

  static String _getServerErrorMessage(ServerFailure failure) {
    switch (failure.statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Authentication required. Please sign in again.';
      case 403:
        return "Access denied. You don't have permission for this action.";
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'Conflict occurred. The resource may have been modified.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Server error occurred. Please try again later.';
      case 502:
        return 'Service temporarily unavailable. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error occurred. Please try again later.';
    }
  }

  static String _getAuthErrorMessage(AuthFailure failure) {
    switch (failure.code) {
      case 'INVALID_CREDENTIALS':
        return 'Invalid credentials. Please check your login information.';
      case 'TOKEN_EXPIRED':
        return 'Your session has expired. Please sign in again.';
      case 'UNAUTHORIZED':
        return 'You need to sign in to access this feature.';
      case 'ACCOUNT_NOT_FOUND':
        return 'Account not found. Please check your credentials.';
      default:
        return 'Authentication error. Please try signing in again.';
    }
  }

  static String _getWalletErrorMessage(WalletFailure failure) {
    switch (failure.code) {
      case 'WALLET_NOT_CONNECTED':
        return 'Please connect your wallet to continue.';
      case 'USER_REJECTED':
        return 'Transaction was rejected by the user.';
      case 'INSUFFICIENT_FUNDS':
        return 'Insufficient funds to complete this transaction.';
      case 'TRANSACTION_FAILED':
        return 'Transaction failed. Please try again.';
      default:
        return 'Wallet error occurred. Please check your wallet connection.';
    }
  }

  static String _getDaoErrorMessage(DaoFailure failure) {
    switch (failure.code) {
      case 'DAO_NOT_FOUND':
        return "DAO not found. It may have been deleted or doesn't exist.";
      case 'ACCESS_DENIED':
        return "You don't have access to this DAO.";
      case 'MEMBERSHIP_REQUIRED':
        return 'You need to be a member of this DAO to perform this action.';
      case 'DAO_CREATION_FAILED':
        return 'Failed to create DAO. Please try again.';
      default:
        return 'DAO error occurred. Please try again.';
    }
  }

  static String _getChatErrorMessage(ChatFailure failure) {
    switch (failure.code) {
      case 'MESSAGE_NOT_FOUND':
        return 'Message not found. It may have been deleted.';
      case 'ROOM_NOT_FOUND':
        return 'Chat room not found. It may have been deleted.';
      case 'MESSAGE_TOO_LONG':
        return 'Message is too long. Please shorten your message.';
      case 'MESSAGE_SEND_FAILED':
        return 'Failed to send message. Please try again.';
      case 'ROOM_JOIN_FAILED':
        return 'Failed to join chat room. Please try again.';
      default:
        return 'Chat error occurred. Please try again.';
    }
  }

  static String _getGovernanceErrorMessage(GovernanceFailure failure) {
    switch (failure.code) {
      case 'PROPOSAL_NOT_FOUND':
        return 'Proposal not found. It may have been deleted.';
      case 'VOTING_ENDED':
        return 'Voting period has ended for this proposal.';
      case 'ALREADY_VOTED':
        return 'You have already voted on this proposal.';
      case 'INSUFFICIENT_VOTING_POWER':
        return "You don't have enough voting power for this proposal.";
      case 'PROPOSAL_CREATION_FAILED':
        return 'Failed to create proposal. Please try again.';
      default:
        return 'Governance error occurred. Please try again.';
    }
  }

  static String _getValidationErrorMessage(ValidationFailure failure) {
    switch (failure.code) {
      case 'INVALID_EMAIL':
        return 'Please enter a valid email address.';
      case 'INVALID_WALLET_ADDRESS':
        return 'Please enter a valid wallet address.';
      case 'REQUIRED_FIELD':
        return failure.message;
      case 'INVALID_LENGTH':
        return failure.message;
      default:
        return 'Please check your input and try again.';
    }
  }

  /// Gets appropriate icon for error type
  static IconData getErrorIcon(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Icons.wifi_off;
      case AuthFailure:
        return Icons.lock_outline;
      case WalletFailure:
        return Icons.account_balance_wallet_outlined;
      case DaoFailure:
        return Icons.group_outlined;
      case ChatFailure:
        return Icons.chat_outlined;
      case GovernanceFailure:
        return Icons.how_to_vote_outlined;
      case ValidationFailure:
        return Icons.error_outline;
      case PermissionFailure:
        return Icons.security;
      default:
        return Icons.error_outline;
    }
  }

  /// Gets appropriate color for error type
  static Color getErrorColor(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Colors.orange;
      case AuthFailure:
        return Colors.red;
      case WalletFailure:
        return Colors.purple;
      case ValidationFailure:
        return Colors.amber;
      case PermissionFailure:
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  /// Determines if error should be logged to external service
  static bool shouldLogError(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return failure.code != 'NO_INTERNET'; // Don't log common network issues
      case ValidationFailure:
        return false; // Don't log validation errors
      case PermissionFailure:
        return false; // Don't log permission errors
      default:
        return true;
    }
  }

  /// Determines if error should trigger retry
  static bool canRetry(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return true;
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        return serverFailure.statusCode == 500 ||
            serverFailure.statusCode == 502 ||
            serverFailure.statusCode == 503;
      case ValidationFailure:
        return false;
      case PermissionFailure:
        return false;
      default:
        return true;
    }
  }

  /// Gets retry delay based on failure type
  static Duration getRetryDelay(Failure failure, int attemptNumber) {
    final baseDelay = Duration(
      seconds: attemptNumber * 2,
    ); // Exponential backoff

    switch (failure.runtimeType) {
      case NetworkFailure:
        return baseDelay;
      case ServerFailure:
        return baseDelay * 2; // Longer delay for server errors
      case RateLimitFailure:
        final rateLimitFailure = failure as RateLimitFailure;
        return rateLimitFailure.retryAfter?.difference(DateTime.now()) ??
            const Duration(seconds: 60); // Default to 1 minute
      default:
        return baseDelay;
    }
  }
}
