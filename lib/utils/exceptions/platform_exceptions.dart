/// Exception class for handling various platform-related errors.
class CbPlatformException implements Exception {
  final String code;

  CbPlatformException(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciais de login inválidas. Verifique suas informações.';
      case 'too-many-requests':
        return 'Muitas tentativas em pouco tempo. Tente novamente mais tarde.';
      case 'invalid-argument':
        return 'Argumento inválido fornecido ao método de autenticação.';
      case 'invalid-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-phone-number':
        return 'O número de telefone informado é inválido.';
      case 'operation-not-allowed':
        return 'O provedor de login está desativado neste projeto Firebase.';
      case 'session-cookie-expired':
        return 'A sessão do Firebase expirou. Faça login novamente.';
      case 'uid-already-exists':
        return 'O ID de usuário informado já está em uso.';
      case 'sign_in_failed':
        return 'Falha ao fazer login. Tente novamente.';
      case 'network-request-failed':
        return 'Falha na conexão. Verifique sua internet.';
      case 'internal-error':
        return 'Erro interno. Tente novamente mais tarde.';
      case 'invalid-verification-code':
        return 'Código de verificação inválido. Digite um código válido.';
      case 'invalid-verification-id':
        return 'ID de verificação inválido. Solicite um novo código.';
      case 'quota-exceeded':
        return 'Limite excedido. Tente novamente mais tarde.';
      default:
        return 'Ocorreu um erro inesperado na plataforma. Tente novamente.';
    }
  }
}
