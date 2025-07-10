class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Wallet address validation (Solana)
  static String? solanaAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wallet address is required';
    }
    // Solana addresses are 32-44 characters long, base58 encoded
    if (value.length < 32 || value.length > 44) {
      return 'Invalid Solana wallet address length';
    }
    // Basic base58 character check
    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    if (!base58Regex.hasMatch(value)) {
      return 'Invalid Solana wallet address format';
    }
    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  // DAO name validation
  static String? daoName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'DAO name is required';
    }
    if (value.length < 3) {
      return 'DAO name must be at least 3 characters long';
    }
    if (value.length > 50) {
      return 'DAO name must not exceed 50 characters';
    }
    // Allow letters, numbers, spaces, hyphens, and underscores
    final nameRegex = RegExp(r'^[a-zA-Z0-9\s\-_]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'DAO name can only contain letters, numbers, spaces, hyphens, and underscores';
    }
    return null;
  }

  // Display name validation
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 2) {
      return 'Display name must be at least 2 characters long';
    }
    if (value.length > 30) {
      return 'Display name must not exceed 30 characters';
    }
    return null;
  }

  // Proposal title validation
  static String? proposalTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Proposal title is required';
    }
    if (value.length < 5) {
      return 'Proposal title must be at least 5 characters long';
    }
    if (value.length > 100) {
      return 'Proposal title must not exceed 100 characters';
    }
    return null;
  }

  // Proposal description validation
  static String? proposalDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Proposal description is required';
    }
    if (value.length < 20) {
      return 'Proposal description must be at least 20 characters long';
    }
    if (value.length > 5000) {
      return 'Proposal description must not exceed 5000 characters';
    }
    return null;
  }

  // Message content validation
  static String? messageContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    if (value.length > 2000) {
      return 'Message must not exceed 2000 characters';
    }
    return null;
  }

  // URL validation
  static String? url(String? value, [bool required = false]) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return 'Please enter a valid URL';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  // Numeric validation
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a number';
    }
    return null;
  }

  // Positive number validation
  static String? positiveNumber(String? value, [String? fieldName]) {
    final numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'This field'} must be greater than 0';
    }
    return null;
  }

  // Token amount validation
  static String? tokenAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Token amount is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0) {
      return 'Token amount cannot be negative';
    }
    if (number == 0) {
      return 'Token amount must be greater than 0';
    }
    return null;
  }

  // Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}
