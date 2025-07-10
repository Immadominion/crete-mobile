/// Base exception class for all application exceptions
abstract class AppException implements Exception {

  const AppException(this.message, {this.code, this.details});
  final String message;
  final String? code;
  final dynamic details;

  @override
  String toString() => 'AppException: $message';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkException: $message';
}

/// API related exceptions
class ApiException extends AppException {

  const ApiException(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});

  @override
  String toString() => 'AuthException: $message';
}

/// Wallet related exceptions
class WalletException extends AppException {
  const WalletException(super.message, {super.code, super.details});

  @override
  String toString() => 'WalletException: $message';
}

/// DAO related exceptions
class DaoException extends AppException {
  const DaoException(super.message, {super.code, super.details});

  @override
  String toString() => 'DaoException: $message';
}

/// Chat related exceptions
class ChatException extends AppException {
  const ChatException(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatException: $message';
}

/// Governance related exceptions
class GovernanceException extends AppException {
  const GovernanceException(super.message, {super.code, super.details});

  @override
  String toString() => 'GovernanceException: $message';
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.details});

  @override
  String toString() => 'CacheException: $message';
}

/// Storage related exceptions
class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageException: $message';
}

/// Validation related exceptions
class ValidationException extends AppException {

  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.code,
    super.details,
  });
  final Map<String, List<String>>? fieldErrors;

  @override
  String toString() => 'ValidationException: $message';
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.details});

  @override
  String toString() => 'PermissionException: $message';
}

/// Rate limiting exceptions
class RateLimitException extends AppException {

  const RateLimitException(
    super.message, {
    this.retryAfter,
    super.code,
    super.details,
  });
  final DateTime? retryAfter;

  @override
  String toString() => 'RateLimitException: $message';
}

/// Server maintenance exceptions
class MaintenanceException extends AppException {

  const MaintenanceException(
    super.message, {
    this.estimatedEnd,
    super.code,
    super.details,
  });
  final DateTime? estimatedEnd;

  @override
  String toString() => 'MaintenanceException: $message';
}

/// Timeout related exceptions
class TimeoutException extends AppException {

  const TimeoutException(
    super.message, {
    this.timeout,
    super.code,
    super.details,
  });
  final Duration? timeout;

  @override
  String toString() => 'TimeoutException: $message';
}

/// Data parsing exceptions
class ParsingException extends AppException {
  const ParsingException(super.message, {super.code, super.details});

  @override
  String toString() => 'ParsingException: $message';
}

/// Specific wallet connection exceptions
class WalletConnectionException extends WalletException {
  const WalletConnectionException(
    super.message, {
    super.code,
    super.details,
  });
}

class WalletNotConnectedException extends WalletException {
  const WalletNotConnectedException() : super('Wallet is not connected');
}

class WalletRejectionException extends WalletException {
  const WalletRejectionException(super.message)
    : super(code: 'USER_REJECTED');
}

class InsufficientFundsException extends WalletException {
  const InsufficientFundsException(super.message)
    : super(code: 'INSUFFICIENT_FUNDS');
}

/// Specific DAO exceptions
class DaoNotFoundException extends DaoException {
  const DaoNotFoundException(String daoId)
    : super('DAO not found: $daoId', code: 'DAO_NOT_FOUND');
}

class DaoAccessDeniedException extends DaoException {
  const DaoAccessDeniedException(super.message)
    : super(code: 'ACCESS_DENIED');
}

class DaoMembershipRequiredException extends DaoException {
  const DaoMembershipRequiredException(super.message)
    : super(code: 'MEMBERSHIP_REQUIRED');
}

/// Specific governance exceptions
class ProposalNotFoundException extends GovernanceException {
  const ProposalNotFoundException(String proposalId)
    : super('Proposal not found: $proposalId', code: 'PROPOSAL_NOT_FOUND');
}

class VotingPeriodEndedException extends GovernanceException {
  const VotingPeriodEndedException()
    : super('Voting period has ended', code: 'VOTING_ENDED');
}

class AlreadyVotedException extends GovernanceException {
  const AlreadyVotedException()
    : super('User has already voted on this proposal', code: 'ALREADY_VOTED');
}

class InsufficientVotingPowerException extends GovernanceException {
  const InsufficientVotingPowerException(super.message)
    : super(code: 'INSUFFICIENT_VOTING_POWER');
}

/// Specific chat exceptions
class MessageNotFoundException extends ChatException {
  const MessageNotFoundException(String messageId)
    : super('Message not found: $messageId', code: 'MESSAGE_NOT_FOUND');
}

class RoomNotFoundException extends ChatException {
  const RoomNotFoundException(String roomId)
    : super('Chat room not found: $roomId', code: 'ROOM_NOT_FOUND');
}

class MessageTooLongException extends ChatException {
  const MessageTooLongException(int maxLength)
    : super(
        'Message exceeds maximum length of $maxLength characters',
        code: 'MESSAGE_TOO_LONG',
      );
}

/// Specific API exceptions
class UnauthorizedException extends ApiException {
  const UnauthorizedException()
    : super('Unauthorized access', statusCode: 401, code: 'UNAUTHORIZED');
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message)
    : super(statusCode: 403, code: 'FORBIDDEN');
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message)
    : super(statusCode: 404, code: 'NOT_FOUND');
}

class ConflictException extends ApiException {
  const ConflictException(super.message)
    : super(statusCode: 409, code: 'CONFLICT');
}

class ServerException extends ApiException {
  const ServerException(super.message, {int? statusCode})
    : super(statusCode: statusCode ?? 500, code: 'SERVER_ERROR');
}

/// Specific validation exceptions
class InvalidEmailException extends ValidationException {
  const InvalidEmailException()
    : super('Invalid email format', code: 'INVALID_EMAIL');
}

class InvalidWalletAddressException extends ValidationException {
  const InvalidWalletAddressException()
    : super('Invalid wallet address format', code: 'INVALID_WALLET_ADDRESS');
}

class RequiredFieldException extends ValidationException {
  const RequiredFieldException(String fieldName)
    : super('$fieldName is required', code: 'REQUIRED_FIELD');
}

class InvalidInputLengthException extends ValidationException {
  const InvalidInputLengthException(
    String fieldName,
    int minLength,
    int maxLength,
  ) : super(
        '$fieldName must be between $minLength and $maxLength characters',
        code: 'INVALID_LENGTH',
      );
}
