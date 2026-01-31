/// Custom exception class to handle various Firebase authentication-related errors.
class CbFirebaseAuthException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  CbFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Este endereço de e-mail já está em uso. Utilize um e-mail diferente.';
      case 'invalid-email':
        return 'O endereço de e-mail informado é inválido. Digite um e-mail válido.';
      case 'weak-password':
        return 'A senha é muito fraca. Escolha uma senha mais forte.';
      case 'user-disabled':
        return 'Esta conta de usuário foi desativada. Entre em contato com o suporte.';
      case 'user-not-found':
        return 'Dados de login inválidos. Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta. Verifique a senha e tente novamente.';
      case 'invalid-verification-code':
        return 'Código de verificação inválido. Digite um código válido.';
      case 'invalid-verification-id':
        return 'ID de verificação inválido. Solicite um novo código de verificação.';
      case 'quota-exceeded':
        return 'Limite excedido. Tente novamente mais tarde.';
      case 'email-already-exists':
        return 'Este endereço de e-mail já existe. Utilize um e-mail diferente.';
      case 'provider-already-linked':
        return 'A conta já está vinculada a outro provedor.';
      case 'requires-recent-login':
        return 'Esta operação é sensível e requer um login recente. Faça login novamente.';
      case 'credential-already-in-use':
        return 'Esta credencial já está associada a outra conta de usuário.';
      case 'user-mismatch':
        return 'As credenciais fornecidas não correspondem ao usuário autenticado.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este e-mail, mas com credenciais de login diferentes.';
      case 'operation-not-allowed':
        return 'Esta operação não é permitida. Entre em contato com o suporte.';
      case 'expired-action-code':
        return 'O código de ação expirou. Solicite um novo código.';
      case 'invalid-action-code':
        return 'O código de ação é inválido. Verifique e tente novamente.';
      case 'missing-action-code':
        return 'O código de ação não foi fornecido. Informe um código válido.';
      case 'user-token-expired':
        return 'A sessão expirou. Faça login novamente.';
      case 'invalid-credential':
        return 'A credencial fornecida é inválida ou expirou.';
      case 'user-token-revoked':
        return 'A sessão foi revogada. Faça login novamente.';
      case 'invalid-message-payload':
        return 'O conteúdo da mensagem de verificação de e-mail é inválido.';
      case 'invalid-sender':
        return 'O remetente do e-mail é inválido. Verifique o endereço do remetente.';
      case 'invalid-recipient-email':
        return 'O endereço de e-mail do destinatário é inválido.';
      case 'missing-iframe-start':
        return 'O template de e-mail está sem a tag inicial do iframe.';
      case 'missing-iframe-end':
        return 'O template de e-mail está sem a tag final do iframe.';
      case 'missing-iframe-src':
        return 'O template de e-mail está sem o atributo src do iframe.';
      case 'auth-domain-config-required':
        return 'A configuração authDomain é necessária para o link de verificação.';
      case 'missing-app-credential':
        return 'A credencial do aplicativo não foi fornecida.';
      case 'invalid-app-credential':
        return 'A credencial do aplicativo é inválida.';
      case 'session-cookie-expired':
        return 'A sessão do Firebase expirou. Faça login novamente.';
      case 'uid-already-exists':
        return 'O ID de usuário informado já está em uso.';
      case 'invalid-cordova-configuration':
        return 'A configuração do Cordova é inválida.';
      case 'app-deleted':
        return 'Esta instância do FirebaseApp foi excluída.';
      case 'user-token-mismatch':
        return 'O token do usuário não corresponde ao usuário autenticado.';
      case 'web-storage-unsupported':
        return 'O armazenamento web não é suportado ou está desativado.';
      case 'app-not-authorized':
        return 'O aplicativo não está autorizado a usar o Firebase Authentication.';
      case 'keychain-error':
        return 'Ocorreu um erro no Keychain. Tente novamente.';
      case 'internal-error':
        return 'Ocorreu um erro interno de autenticação. Tente novamente mais tarde.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciais de login inválidas.';
      default:
        return 'Ocorreu um erro inesperado de autenticação. Tente novamente.';
    }
  }
}
