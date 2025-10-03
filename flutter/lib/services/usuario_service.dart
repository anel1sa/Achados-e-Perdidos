import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

/// Modelo que representa um usuário do sistema
class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final String matricula;
  final int campusId;
  final String telefone;
  final String senha;
  final String? avatar;
  final String? dataCadastro;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    required this.matricula,
    required this.campusId,
    required this.telefone,
    required this.senha,
    this.avatar,
    this.dataCadastro,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      matricula: json['matricula'],
      campusId: json['campusId'],
      telefone: json['telefone'],
      senha: json['senha'],
      avatar: json['avatar'],
      dataCadastro: json['dataCadastro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'matricula': matricula,
      'campusId': campusId,
      'telefone': telefone,
      'senha': senha,
      'avatar': avatar,
      'dataCadastro': dataCadastro,
    };
  }
}

/// Modelo que representa um campus da instituição
class CampusModel {
  final int id;
  final String nome;
  final String endereco;
  final String cidade;
  final String estado;
  final String cep;
  final bool ativo;

  CampusModel({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.ativo,
  });

  factory CampusModel.fromJson(Map<String, dynamic> json) {
    return CampusModel(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      estado: json['estado'],
      cep: json['cep'],
      ativo: json['ativo'],
    );
  }
}

/// Serviço responsável pela gestão de usuários
class UsuarioService {
  // Constants
  static const String _usuariosCadastradosAsset =
      'assets/usuarios_cadastrados.json';
  static const String _databaseAsset = 'assets/db.json';
  static const String _cadastroSchemaAsset = 'assets/cadastro_usuario.json';
  static const String _usuariosFileName = 'usuarios_cadastrados.json';

  /// Carrega o banco de dados principal
  Future<Map<String, dynamic>> _loadDatabase() async {
    try {
      final String response = await rootBundle.loadString(_databaseAsset);
      return json.decode(response);
    } catch (e) {
      throw Exception('Erro ao carregar banco de dados: $e');
    }
  }

  /// Carrega o esquema de validação para cadastro de usuários
  Future<Map<String, dynamic>> _loadCadastroSchema() async {
    try {
      final String response = await rootBundle.loadString(_cadastroSchemaAsset);
      return json.decode(response);
    } catch (e) {
      throw Exception('Erro ao carregar esquema de cadastro: $e');
    }
  }

  /// Carrega a lista de usuários cadastrados
  Future<List<UsuarioModel>> _loadUsuariosCadastrados() async {
    try {
      final String response = await rootBundle.loadString(
        _usuariosCadastradosAsset,
      );
      final data = json.decode(response);
      final List<dynamic> usuariosJson = data['usuarios_cadastrados'];
      return usuariosJson.map((json) => UsuarioModel.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar usuários cadastrados: $e');
      return [];
    }
  }

  /// Salva a lista de usuários cadastrados no dispositivo
  Future<void> _saveUsuariosCadastrados(List<UsuarioModel> usuarios) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_usuariosFileName');

      final Map<String, dynamic> data = {
        'usuarios_cadastrados': usuarios.map((u) => u.toJson()).toList(),
      };

      await file.writeAsString(json.encode(data));
      print('Usuários salvos com sucesso em: ${file.path}');
    } catch (e) {
      throw Exception('Erro ao salvar usuários: $e');
    }
  }

  /// Retorna todos os usuários cadastrados
  Future<List<UsuarioModel>> getUsuarios() async {
    return await _loadUsuariosCadastrados();
  }

  /// Autentica um usuário com email e senha
  Future<UsuarioModel?> login(String email, String senha) async {
    final usuarios = await _loadUsuariosCadastrados();
    try {
      return usuarios.firstWhere(
        (usuario) => usuario.email == email && usuario.senha == senha,
      );
    } catch (e) {
      return null; // Usuário não encontrado
    }
  }

  /// Verifica se um email já está cadastrado no sistema
  Future<bool> emailExiste(String email) async {
    final usuarios = await _loadUsuariosCadastrados();
    return usuarios.any((usuario) => usuario.email == email);
  }

  /// Verifica se uma matrícula já está cadastrada no sistema
  Future<bool> matriculaExiste(String matricula) async {
    final usuarios = await _loadUsuariosCadastrados();
    return usuarios.any((usuario) => usuario.matricula == matricula);
  }

  /// Retorna a lista de campi ativos disponíveis para cadastro
  Future<List<CampusModel>> getCampi() async {
    final db = await _loadDatabase();
    final List<dynamic> campiJson = db['campi'];
    return campiJson
        .map((json) => CampusModel.fromJson(json))
        .where((campus) => campus.ativo)
        .toList();
  }

  /// Valida os dados de um usuário de acordo com as regras de negócio
  Future<Map<String, String?>> validarUsuario(UsuarioModel usuario) async {
    final schema = await _loadCadastroSchema();
    final validacoes = schema['esquemaCadastro']['validacoes'];
    final Map<String, String?> erros = {};

    await _validarEmail(usuario.email, validacoes, erros);
    await _validarMatricula(usuario.matricula, validacoes, erros);
    _validarSenha(usuario.senha, validacoes, erros);

    return erros;
  }

  /// Valida o email do usuário
  Future<void> _validarEmail(
    String email,
    Map<String, dynamic> validacoes,
    Map<String, String?> erros,
  ) async {
    if (await emailExiste(email)) {
      erros['email'] = validacoes['email']['mensagemErro'];
    }
  }

  /// Valida a matrícula do usuário
  Future<void> _validarMatricula(
    String matricula,
    Map<String, dynamic> validacoes,
    Map<String, String?> erros,
  ) async {
    if (await matriculaExiste(matricula)) {
      erros['matricula'] = validacoes['matricula']['mensagemErro'];
    }
  }

  /// Valida a senha do usuário
  void _validarSenha(
    String senha,
    Map<String, dynamic> validacoes,
    Map<String, String?> erros,
  ) {
    if (senha.length < validacoes['senha']['minLength']) {
      erros['senha'] = validacoes['senha']['mensagemErro'];
    }
  }

  /// Cadastra um novo usuário no sistema
  Future<Map<String, dynamic>> cadastrarUsuario(
    UsuarioModel novoUsuario,
  ) async {
    try {
      final erros = await validarUsuario(novoUsuario);
      if (erros.isNotEmpty) {
        return _buildErrorResponse('Erro ao cadastrar usuário', erros);
      }

      final usuarios = await _loadUsuariosCadastrados();
      final novoUsuarioCompleto = _criarUsuarioCompleto(novoUsuario, usuarios);

      usuarios.add(novoUsuarioCompleto);
      await _saveUsuariosCadastrados(usuarios);

      return _buildSuccessResponse(novoUsuarioCompleto);
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return _buildErrorResponse('Erro ao cadastrar usuário: $e');
    }
  }

  /// Cria um usuário com dados completos (ID, avatar, data de cadastro)
  UsuarioModel _criarUsuarioCompleto(
    UsuarioModel usuario,
    List<UsuarioModel> usuariosExistentes,
  ) {
    final int novoId = _gerarNovoId(usuariosExistentes);
    final String avatar = usuario.nome.isNotEmpty
        ? usuario.nome.substring(0, 1).toUpperCase()
        : 'U';
    final String dataCadastro = DateTime.now().toIso8601String().split('T')[0];

    return UsuarioModel(
      id: novoId,
      nome: usuario.nome,
      email: usuario.email,
      matricula: usuario.matricula,
      campusId: usuario.campusId,
      telefone: usuario.telefone,
      senha: usuario.senha,
      avatar: avatar,
      dataCadastro: dataCadastro,
    );
  }

  /// Gera um novo ID único para o usuário
  int _gerarNovoId(List<UsuarioModel> usuarios) {
    if (usuarios.isEmpty) return 1;

    final maxId = usuarios
        .map((u) => u.id ?? 0)
        .reduce((a, b) => a > b ? a : b);

    return maxId + 1;
  }

  /// Constrói uma resposta de sucesso padronizada
  Map<String, dynamic> _buildSuccessResponse(UsuarioModel usuario) {
    return {
      'sucesso': true,
      'mensagem': 'Usuário cadastrado com sucesso',
      'dados': {'id': usuario.id, 'nome': usuario.nome, 'email': usuario.email},
    };
  }

  /// Constrói uma resposta de erro padronizada
  Map<String, dynamic> _buildErrorResponse(
    String mensagem, [
    Map<String, String?>? erros,
  ]) {
    return {'sucesso': false, 'mensagem': mensagem, 'erros': erros ?? {}};
  }

  /// Inicializa o arquivo de usuários cadastrados se necessário
  Future<void> inicializarUsuariosCadastrados() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_usuariosFileName');

      if (!await file.exists()) {
        await _criarArquivoInicial(file);
      } else {
        print('Arquivo de usuários cadastrados já existe em: ${file.path}');
      }
    } catch (e) {
      print('Erro ao inicializar usuários cadastrados: $e');
    }
  }

  /// Cria o arquivo inicial de usuários cadastrados
  Future<void> _criarArquivoInicial(File file) async {
    final String initialData = await rootBundle.loadString(
      _usuariosCadastradosAsset,
    );
    await file.writeAsString(initialData);
    print('Arquivo de usuários cadastrados inicializado em: ${file.path}');
  }
}
