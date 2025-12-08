/// Utilitários para manipulação de dados de usuário
class UserUtils {
  /// Gera as iniciais do usuário a partir do nome completo
  /// 
  /// Exemplos:
  /// - "João Silva" -> "JS"
  /// - "Maria" -> "MA"
  /// - "Pedro" -> "PE"
  static String generateInitials(String nomeCompleto) {
    if (nomeCompleto.trim().isEmpty) {
      return '?';
    }

    final nomes = nomeCompleto.trim().split(' ').where((n) => n.isNotEmpty).toList();
    
    if (nomes.isEmpty) {
      return '?';
    }
    
    if (nomes.length > 1 && nomes[1].isNotEmpty) {
      return (nomes[0][0] + nomes[1][0]).toUpperCase();
    } else {
      final nome = nomes[0];
      if (nome.isEmpty) return '?';
      final maxLength = nome.length > 1 ? 2 : 1;
      return nome.substring(0, maxLength).toUpperCase();
    }
  }

  /// Extrai o primeiro nome do nome completo
  static String getFirstName(String nomeCompleto) {
    if (nomeCompleto.trim().isEmpty) {
      return 'Usuário';
    }
    return nomeCompleto.trim().split(' ').first;
  }
}

