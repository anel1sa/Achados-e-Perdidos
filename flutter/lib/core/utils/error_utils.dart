/// Utilitários para tratamento de erros
class ErrorUtils {
  /// Trata mensagens de erro de rede para exibição amigável
  static String tratarErroRede(String erro) {
    if (erro.contains('SocketException') || 
        erro.contains('Failed host lookup') ||
        erro.contains('Network is unreachable')) {
      return 'Sem conexão com a internet';
    } else if (erro.contains('TimeoutException') || erro.contains('timeout')) {
      return 'Tempo esgotado. Tente novamente';
    } else if (erro.contains('404')) {
      return 'Dados não encontrados';
    } else if (erro.contains('500') || erro.contains('502') || erro.contains('503')) {
      return 'Erro no servidor. Tente mais tarde';
    } else if (erro.contains('401') || erro.contains('403')) {
      return 'Acesso não autorizado';
    }
    return 'Erro ao carregar dados';
  }

  /// Trata mensagens de erro de login para exibição amigável
  static String tratarErroLogin(String erro) {
    if (erro.contains('403') || erro.contains('Forbidden')) {
      return 'Email ou senha incorretos';
    } else if (erro.contains('404')) {
      return 'Usuário não encontrado';
    } else if (erro.contains('401')) {
      return 'Credenciais inválidas';
    } else if (erro.contains('timeout') || erro.contains('conexão')) {
      return 'Erro de conexão. Verifique sua internet';
    }
    return 'Erro ao fazer login';
  }

  /// Trata mensagens de erro de cadastro para exibição amigável
  static String tratarErroCadastro(String erro) {
    if (erro.contains('Email já cadastrado') ||
        erro.contains('email') ||
        erro.contains('409')) {
      return 'Este email já está cadastrado';
    } else if (erro.contains('400')) {
      return 'Dados inválidos. Verifique os campos';
    } else if (erro.contains('timeout') || erro.contains('conexão')) {
      return 'Erro de conexão. Verifique sua internet';
    }
    return 'Erro ao realizar cadastro';
  }
}

