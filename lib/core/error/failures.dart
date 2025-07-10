/// Base failure class for all application failures
abstract class Failure {

  const Failure(this.message, {this.code, this.details});
  final String message;
  final String? code;
  final dynamic details;

  @override
  String toString() => 'Failure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.code == code &&
        other.details == details;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode ^ details.hashCode;
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Server related failures
class ServerFailure extends Failure {

  const ServerFailure(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });
  final int? statusCode;

  @override
  String toString() => 'ServerFailure($statusCode): $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServerFailure &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode =>
      message.hashCode ^ code.hashCode ^ details.hashCode ^ statusCode.hashCode;
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'CacheFailure: $message';
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'AuthFailure: $message';
}

/// Wallet related failures
class WalletFailure extends Failure {
  const WalletFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'WalletFailure: $message';
}

/// DAO related failures
class DaoFailure extends Failure {
  const DaoFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'DaoFailure: $message';
}

/// Chat related failures
class ChatFailure extends Failure {
  const ChatFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'ChatFailure: $message';
}

/// Governance related failures
class GovernanceFailure extends Failure {
  const GovernanceFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'GovernanceFailure: $message';
}

/// Validation related failures
class ValidationFailure extends Failure {

  const ValidationFailure(
    super.message, {
    this.fieldErrors,
    super.code,
    super.details,
  });
  final Map<String, List<String>>? fieldErrors;

  @override
  String toString() => 'ValidationFailure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationFailure &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.fieldErrors == fieldErrors;
  }

  @override
  int get hashCode =>
      message.hashCode ^
      code.hashCode ^
      details.hashCode ^
      fieldErrors.hashCode;
}

/// Permission related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'PermissionFailure: $message';
}

/// Data parsing failures
class ParsingFailure extends Failure {
  const ParsingFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'ParsingFailure: $message';
}

/// Storage related failures
class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageFailure: $message';
}

/// Notification related failures
class NotificationFailure extends Failure {
  const NotificationFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'NotificationFailure: $message';
}

/// Deep link related failures
class DeepLinkFailure extends Failure {
  const DeepLinkFailure(super.message, {super.code, super.details});

  @override
  String toString() => 'DeepLinkFailure: $message';
}

/// Specific wallet failures
class WalletConnectionFailure extends WalletFailure {
  const WalletConnectionFailure(super.message, {super.code, super.details});
}

class WalletNotConnectedFailure extends WalletFailure {
  const WalletNotConnectedFailure()
    : super('Wallet is not connected', code: 'WALLET_NOT_CONNECTED');
}

class WalletRejectionFailure extends WalletFailure {
  const WalletRejectionFailure(super.message)
    : super(code: 'USER_REJECTED');
}

class InsufficientFundsFailure extends WalletFailure {
  const InsufficientFundsFailure(super.message)
    : super(code: 'INSUFFICIENT_FUNDS');
}

class TransactionFailure extends WalletFailure {

  const TransactionFailure(
    super.message, {
    this.transactionId,
    super.code,
    super.details,
  });
  final String? transactionId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionFailure &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode =>
      message.hashCode ^
      code.hashCode ^
      details.hashCode ^
      transactionId.hashCode;
}

/// Specific DAO failures
class DaoNotFoundFailure extends DaoFailure {
  const DaoNotFoundFailure(String daoId)
    : super('DAO not found: $daoId', code: 'DAO_NOT_FOUND');
}

class DaoAccessDeniedFailure extends DaoFailure {
  const DaoAccessDeniedFailure(super.message)
    : super(code: 'ACCESS_DENIED');
}

class DaoMembershipRequiredFailure extends DaoFailure {
  const DaoMembershipRequiredFailure(super.message)
    : super(code: 'MEMBERSHIP_REQUIRED');
}

class DaoCreationFailure extends DaoFailure {
  const DaoCreationFailure(super.message)
    : super(code: 'DAO_CREATION_FAILED');
}

/// Specific governance failures
class ProposalNotFoundFailure extends GovernanceFailure {
  const ProposalNotFoundFailure(String proposalId)
    : super('Proposal not found: $proposalId', code: 'PROPOSAL_NOT_FOUND');
}

class VotingPeriodEndedFailure extends GovernanceFailure {
  const VotingPeriodEndedFailure()
    : super('Voting period has ended', code: 'VOTING_ENDED');
}

class AlreadyVotedFailure extends GovernanceFailure {
  const AlreadyVotedFailure()
    : super('User has already voted on this proposal', code: 'ALREADY_VOTED');
}

class InsufficientVotingPowerFailure extends GovernanceFailure {
  const InsufficientVotingPowerFailure(super.message)
    : super(code: 'INSUFFICIENT_VOTING_POWER');
}

class ProposalCreationFailure extends GovernanceFailure {
  const ProposalCreationFailure(super.message)
    : super(code: 'PROPOSAL_CREATION_FAILED');
}

/// Specific chat failures
class MessageNotFoundFailure extends ChatFailure {
  const MessageNotFoundFailure(String messageId)
    : super('Message not found: $messageId', code: 'MESSAGE_NOT_FOUND');
}

class RoomNotFoundFailure extends ChatFailure {
  const RoomNotFoundFailure(String roomId)
    : super('Chat room not found: $roomId', code: 'ROOM_NOT_FOUND');
}

class MessageTooLongFailure extends ChatFailure {
  const MessageTooLongFailure(int maxLength)
    : super(
        'Message exceeds maximum length of $maxLength characters',
        code: 'MESSAGE_TOO_LONG',
      );
}

class MessageSendFailure extends ChatFailure {
  const MessageSendFailure(super.message)
    : super(code: 'MESSAGE_SEND_FAILED');
}

class RoomJoinFailure extends ChatFailure {
  const RoomJoinFailure(super.message)
    : super(code: 'ROOM_JOIN_FAILED');
}

/// Specific auth failures
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
    : super('Invalid credentials provided', code: 'INVALID_CREDENTIALS');
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure()
    : super('Authentication token has expired', code: 'TOKEN_EXPIRED');
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure(super.message)
    : super(code: 'UNAUTHORIZED');
}

class AccountNotFoundFailure extends AuthFailure {
  const AccountNotFoundFailure()
    : super('Account not found', code: 'ACCOUNT_NOT_FOUND');
}

/// Specific validation failures
class InvalidEmailFailure extends ValidationFailure {
  const InvalidEmailFailure()
    : super('Invalid email format', code: 'INVALID_EMAIL');
}

class InvalidWalletAddressFailure extends ValidationFailure {
  const InvalidWalletAddressFailure()
    : super('Invalid wallet address format', code: 'INVALID_WALLET_ADDRESS');
}

class RequiredFieldFailure extends ValidationFailure {
  const RequiredFieldFailure(String fieldName)
    : super('$fieldName is required', code: 'REQUIRED_FIELD');
}

class InvalidInputLengthFailure extends ValidationFailure {
  const InvalidInputLengthFailure(
    String fieldName,
    int minLength,
    int maxLength,
  ) : super(
        '$fieldName must be between $minLength and $maxLength characters',
        code: 'INVALID_LENGTH',
      );
}

/// Specific network failures
class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure()
    : super('Failed to connect to the network', code: 'CONNECTION_FAILED');
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure() : super('Network request timed out', code: 'TIMEOUT');
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure()
    : super('No internet connection available', code: 'NO_INTERNET');
}

/// Rate limiting failure
class RateLimitFailure extends Failure {

  const RateLimitFailure(
    super.message, {
    this.retryAfter,
    super.code,
    super.details,
  });
  final DateTime? retryAfter;

  @override
  String toString() => 'RateLimitFailure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RateLimitFailure &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.retryAfter == retryAfter;
  }

  @override
  int get hashCode =>
      message.hashCode ^ code.hashCode ^ details.hashCode ^ retryAfter.hashCode;
}

/// Maintenance failure
class MaintenanceFailure extends Failure {

  const MaintenanceFailure(
    super.message, {
    this.estimatedEnd,
    super.code,
    super.details,
  });
  final DateTime? estimatedEnd;

  @override
  String toString() => 'MaintenanceFailure: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceFailure &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.estimatedEnd == estimatedEnd;
  }

  @override
  int get hashCode =>
      message.hashCode ^
      code.hashCode ^
      details.hashCode ^
      estimatedEnd.hashCode;
}
