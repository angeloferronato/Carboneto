/// Custom exception class to handle various Firebase-related errors.
class CbFirebaseException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  CbFirebaseException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'unknown':
        return 'Ocorreu um erro desconhecido no Firebase. Tente novamente.';
      case 'invalid-custom-token':
        return 'O formato do token personalizado está incorreto. Verifique o token.';
      case 'custom-token-mismatch':
        return 'O token personalizado corresponde a um público diferente.';
      case 'user-disabled':
        return 'Esta conta de usuário foi desativada.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado para o e-mail ou UID informado.';
      case 'invalid-email':
        return 'O endereço de e-mail informado é inválido. Digite um e-mail válido.';
      case 'email-already-in-use':
        return 'Este endereço de e-mail já está em uso. Utilize um e-mail diferente.';
      case 'wrong-password':
        return 'Senha incorreta. Verifique a senha e tente novamente.';
      case 'weak-password':
        return 'A senha é muito fraca. Escolha uma senha mais forte.';
      case 'provider-already-linked':
        return 'A conta já está vinculada a outro provedor.';
      case 'operation-not-allowed':
        return 'Esta operação não é permitida. Entre em contato com o suporte.';
      case 'invalid-credential':
        return 'A credencial fornecida é inválida ou expirou.';
      case 'invalid-verification-code':
        return 'Código de verificação inválido. Digite um código válido.';
      case 'invalid-verification-id':
        return 'ID de verificação inválido. Solicite um novo código de verificação.';
      case 'captcha-check-failed':
        return 'A verificação do reCAPTCHA falhou. Tente novamente.';
      case 'app-not-authorized':
        return 'O aplicativo não está autorizado a usar o Firebase Authentication com a API key fornecida.';
      case 'keychain-error':
        return 'Ocorreu um erro no Keychain. Verifique e tente novamente.';
      case 'internal-error':
        return 'Ocorreu um erro interno de autenticação. Tente novamente mais tarde.';
      case 'invalid-app-credential':
        return 'A credencial do aplicativo é inválida. Forneça uma credencial válida.';
      case 'user-mismatch':
        return 'As credenciais fornecidas não correspondem ao usuário autenticado.';
      case 'requires-recent-login':
        return 'Esta operação é sensível e requer um login recente. Faça login novamente.';
      case 'quota-exceeded':
        return 'Limite excedido. Tente novamente mais tarde.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este e-mail, mas com credenciais de login diferentes.';
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
      case 'session-cookie-expired':
        return 'A sessão do Firebase expirou. Faça login novamente.';
      case 'uid-already-exists':
        return 'O ID de usuário informado já está em uso.';
      case 'web-storage-unsupported':
        return 'O armazenamento web não é suportado ou está desativado.';
      case 'app-deleted':
        return 'Esta instância do FirebaseApp foi excluída.';
      case 'user-token-mismatch':
        return 'O token do usuário não corresponde ao usuário autenticado.';
      case 'invalid-message-payload':
        return 'O conteúdo da mensagem de verificação de e-mail é inválido.';
      case 'invalid-sender':
        return 'O remetente do e-mail é inválido. Verifique o endereço do remetente.';
      case 'invalid-recipient-email':
        return 'O endereço de e-mail do destinatário é inválido.';
      case 'missing-action-code':
        return 'O código de ação não foi fornecido. Informe um código válido.';
      case 'user-token-expired':
        return 'A sessão expirou e é necessário autenticar novamente. Faça login.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciais de login inválidas.';
      case 'expired-action-code':
        return 'O código de ação expirou. Solicite um novo código.';
      case 'invalid-action-code':
        return 'O código de ação é inválido. Verifique e tente novamente.';
      case 'credential-already-in-use':
        return 'Esta credencial já está associada a outra conta de usuário.';
      default:
        return 'Ocorreu um erro inesperado no Firebase. Tente novamente.';
    }
  }
}
