import 'package:jwt_decoder/jwt_decoder.dart';
import '../DTOs/auth_dto.dart';

/// DTO para requisição de login
class LoginRequestDTO {
  final String email;
  final String senha;
  final String? deviceToken;
  final String? plataforma;

  LoginRequestDTO({
    required this.email,
    required this.senha,
    this.deviceToken,
    this.plataforma,
  });

  Map<String, dynamic> toJson() {
    // Garante que email e senha não sejam vazios
    final emailTrimmed = email.trim();
    final senhaTrimmed = senha.trim();
    
    if (emailTrimmed.isEmpty) {
      throw ArgumentError('Email não pode ser vazio');
    }
    if (senhaTrimmed.isEmpty) {
      throw ArgumentError('Senha não pode ser vazia');
    }
    
    return {
      'Email_Usuario': emailTrimmed,
      'Senha_Hash': senhaTrimmed,
      if (deviceToken != null && deviceToken!.isNotEmpty) 'Device_Token': deviceToken,
      if (plataforma != null && plataforma!.isNotEmpty) 'Plataforma': plataforma,
    };
  }
}

/// DTO para resposta de login
class LoginResponseDTO {
  final String token;
  final String tokenType;
  final int expiresIn;
  final int id;
  final String nome;
  final String email;
  final String? role;
  final String? campus;

  // Getter de compatibilidade
  int get userId => id;

  LoginResponseDTO({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.id,
    required this.nome,
    required this.email,
    this.role,
    this.campus,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) {
    // A API agora retorna apenas { token: "..." }
    // Precisamos decodificar o JWT para obter os dados do usuário
    final token = json['token'] as String? ?? '';
    
    if (token.isEmpty) {
      return LoginResponseDTO(
        token: '',
        tokenType: 'Bearer',
        expiresIn: 3600,
        id: 0,
        nome: '',
        email: '',
      );
    }
    
    // Decodificar JWT para obter dados do usuário
    try {
      final decodedToken = JwtDecoder.decode(token);
      final exp = decodedToken['exp'] as int?;
      final expiresIn = exp != null ? exp - (DateTime.now().millisecondsSinceEpoch ~/ 1000) : 3600;
      
      return LoginResponseDTO(
        token: token,
        tokenType: 'Bearer',
        expiresIn: expiresIn,
        id: int.tryParse(decodedToken['userId']?.toString() ?? decodedToken['sub']?.toString() ?? '0') ?? 0,
        nome: decodedToken['nome'] as String? ?? decodedToken['nomeCompleto'] as String? ?? '',
        email: decodedToken['email'] as String? ?? decodedToken['sub'] as String? ?? '',
        role: decodedToken['role'] as String? ?? decodedToken['roles'] as String?,
        campus: decodedToken['campus'] as String?,
      );
    } catch (e) {
      // Se falhar ao decodificar, retorna apenas o token
      return LoginResponseDTO(
        token: token,
        tokenType: 'Bearer',
        expiresIn: 3600,
        id: 0,
        nome: '',
        email: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'id': id,
      'nome': nome,
      'email': email,
      if (role != null) 'role': role,
      if (campus != null) 'campus': campus,
    };
  }

  /// Cria um LoginResponseDTO a partir de AuthResponseDTO
  factory LoginResponseDTO.fromAuthDTO(AuthResponseDTO dto) {
    return LoginResponseDTO(
      token: dto.token,
      tokenType: dto.tokenType,
      expiresIn: dto.expiresIn,
      id: dto.id,
      nome: dto.nome,
      email: dto.email,
      role: dto.role,
      campus: dto.campus,
    );
  }
}

/// DTO para requisição de autenticação com Google
class GoogleAuthRequestDTO {
  final String? code;
  final String? idToken;
  final String? token;

  GoogleAuthRequestDTO({
    this.code,
    this.idToken,
    this.token,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (code != null && code!.isNotEmpty) {
      json['code'] = code;
    }
    if (idToken != null && idToken!.isNotEmpty) {
      json['idToken'] = idToken;
    }
    if (token != null && token!.isNotEmpty) {
      json['token'] = token;
    }
    return json;
  }
}

