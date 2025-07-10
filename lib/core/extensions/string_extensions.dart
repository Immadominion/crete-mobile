extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Converts the string to title case
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Checks if the string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(this);
  }

  /// Checks if the string is a valid URL
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the string is a valid Solana wallet address
  bool get isValidSolanaAddress {
    if (length < 32 || length > 44) {
      return false;
    }
    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    return base58Regex.hasMatch(this);
  }

  /// Shortens a wallet address for display
  String shortenAddress({int startChars = 4, int endChars = 4}) {
    if (length <= startChars + endChars) {
      return this;
    }
    return '${substring(0, startChars)}...${substring(length - endChars)}';
  }

  /// Removes extra whitespace and newlines
  String get cleaned => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Converts string to slug format (lowercase, dashes)
  String get slug => toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp('-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

  /// Truncates string to specified length with ellipsis
  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$ellipsis';
  }

  /// Checks if string contains only numeric characters
  bool get isNumeric => double.tryParse(this) != null;

  /// Checks if string contains only alphabetic characters
  bool get isAlphabetic => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Checks if string contains only alphanumeric characters
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Removes all HTML tags from string
  String get stripHtml => replaceAll(RegExp('<[^>]*>'), '');

  /// Converts string to camelCase
  String get camelCase {
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    final first = words.first.toLowerCase();
    final rest = words.skip(1).map((word) => word.capitalized);
    return '$first${rest.join()}';
  }

  /// Converts string to snake_case
  String get snakeCase => replaceAll(
      RegExp('([A-Z])'),
      r'_$1',
    ).toLowerCase().replaceAll(RegExp('^_'), '');

  /// Converts string to kebab-case
  String get kebabCase => replaceAll(
      RegExp('([A-Z])'),
      r'-$1',
    ).toLowerCase().replaceAll(RegExp('^-'), '');

  /// Reverses the string
  String get reversed => split('').reversed.join();

  /// Counts words in the string
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Checks if string is empty or only whitespace
  bool get isBlank => trim().isEmpty;

  /// Checks if string is not empty and not only whitespace
  bool get isNotBlank => !isBlank;

  /// Wraps string in quotes
  String get quoted => '"$this"';

  /// Removes quotes from string
  String get unquoted {
    if (length >= 2 && startsWith('"') && endsWith('"')) {
      return substring(1, length - 1);
    }
    if (length >= 2 && startsWith("'") && endsWith("'")) {
      return substring(1, length - 1);
    }
    return this;
  }

  /// Converts first character to lowercase
  String get uncapitalized {
    if (isEmpty) return this;
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  /// Checks if string is a valid JSON format
  bool get isValidJson {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extracts numbers from string
  List<int> get extractNumbers {
    final matches = RegExp(r'\d+').allMatches(this);
    return matches.map((match) => int.parse(match.group(0)!)).toList();
  }

  /// Checks if string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Converts string to proper case (first letter of each word capitalized)
  String get properCase => split(
      ' ',
    ).map((word) => word.isEmpty ? word : word.capitalized).join(' ');

  /// Masks the string for security (e.g., passwords, keys)
  String mask({String maskChar = '*', int visibleChars = 4}) {
    if (length <= visibleChars) return this;
    final visible = substring(0, visibleChars);
    final masked = maskChar * (length - visibleChars);
    return '$visible$masked';
  }

  /// Generates initials from full name
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    }
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  /// Checks if string is a valid hex color
  bool get isValidHexColor => RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(this);

  /// Converts hex string to integer color value
  int? get hexToColor {
    if (!isValidHexColor) return null;
    return int.tryParse(replaceFirst('#', '0xFF'));
  }
}
