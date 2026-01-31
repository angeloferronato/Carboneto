/// Custom exception class to handle various format-related errors.
class CbFormatException implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic error message.
  const CbFormatException([this.message = 'An unexpected format error occurred. Please check your input.']);

  /// Create a format exception from a specific error message.
  factory CbFormatException.fromMessage(String message) {
    return CbFormatException(message);
  }

  /// Get the corresponding error message.
  String get formattedMessage => message;

  /// Create a format exception from a specific error code.
  factory CbFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
      return const CbFormatException('O formato do endereço de e-mail é inválido. Digite um e-mail válido.',);
    case 'invalid-phone-number-format':
      return const CbFormatException('O formato do número de telefone informado é inválido. Digite um número válido.',);
    case 'invalid-date-format':
      return const CbFormatException('O formato da data é inválido. Informe uma data válida.',);
    case 'invalid-url-format':
      return const CbFormatException('O formato da URL é inválido. Informe uma URL válida.',);
    case 'invalid-credit-card-format':
      return const CbFormatException('O formato do cartão de crédito é inválido. Informe um número de cartão válido.',);
    case 'invalid-numeric-format':
      return const CbFormatException('O valor informado deve estar em um formato numérico válido.',);
    // Add more cases as needed...
      default:
        return const CbFormatException();
    }
  }
}