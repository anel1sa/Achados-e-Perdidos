import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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

class UsuarioService {
  static const String _usuariosCadastradosAsset =
      'assets/usuarios_cadastrados.json';

  // Carrega o banco de dados JSON
  Future<Map<String, dynamic>> _loadDatabase() async {
    final String response = await rootBundle.loadString('assets/db.json');
    return json.decode(response);
  }

  // Carrega o esquema de cadastro
  Future<Map<String, dynamic>> _loadCadastroSchema() async {
    final String response = await rootBundle.loadString(
      'assets/cadastro_usuario.json',
    );
    return json.decode(response);
  }

  // Carrega os usuários cadastrados
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

  // Salva os usuários cadastrados no arquivo
  Future<void> _saveUsuariosCadastrados(List<UsuarioModel> usuarios) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/usuarios_cadastrados.json');

      final Map<String, dynamic> data = {
        'usuarios_cadastrados': usuarios.map((u) => u.toJson()).toList(),
      };

      await file.writeAsString(json.encode(data));
      print('Usuários salvos com sucesso em: ${file.path}');
    } catch (e) {
      print('Erro ao salvar usuários: $e');
      // Em um ambiente de produção, trataria melhor esse erro
    }
  }

  // Busca todos os usuários cadastrados
  Future<List<UsuarioModel>> getUsuarios() async {
    return await _loadUsuariosCadastrados();
  }

  // Busca um usuário pelo email e senha (login)
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

  // Verifica se um email já está cadastrado
  Future<bool> emailExiste(String email) async {
    final usuarios = await _loadUsuariosCadastrados();
    return usuarios.any((usuario) => usuario.email == email);
  }

  // Verifica se uma matrícula já está cadastrada
  Future<bool> matriculaExiste(String matricula) async {
    final usuarios = await _loadUsuariosCadastrados();
    return usuarios.any((usuario) => usuario.matricula == matricula);
  }

  // Busca todos os campi disponíveis
  Future<List<CampusModel>> getCampi() async {
    final db = await _loadDatabase();
    final List<dynamic> campiJson = db['campi'];
    return campiJson
        .map((json) => CampusModel.fromJson(json))
        .where((campus) => campus.ativo) // Filtra apenas os campi ativos
        .toList();
  }

  // Valida um usuário de acordo com as regras do esquema
  Future<Map<String, String?>> validarUsuario(UsuarioModel usuario) async {
    final schema = await _loadCadastroSchema();
    final validacoes = schema['esquemaCadastro']['validacoes'];
    final Map<String, String?> erros = {};

    // Verifica se o email já existe
    if (await emailExiste(usuario.email)) {
      erros['email'] = validacoes['email']['mensagemErro'];
    }

    // Verifica se a matrícula já existe
    if (await matriculaExiste(usuario.matricula)) {
      erros['matricula'] = validacoes['matricula']['mensagemErro'];
    }

    // Verifica o comprimento mínimo da senha
    if (usuario.senha.length < validacoes['senha']['minLength']) {
      erros['senha'] = validacoes['senha']['mensagemErro'];
    }

    return erros;
  }

  // Cadastra um novo usuário
  Future<Map<String, dynamic>> cadastrarUsuario(
    UsuarioModel novoUsuario,
  ) async {
    // Valida o usuário
    final erros = await validarUsuario(novoUsuario);
    if (erros.isNotEmpty) {
      return {
        'sucesso': false,
        'mensagem': 'Erro ao cadastrar usuário',
        'erros': erros,
      };
    }

    try {
      // Obter lista atual de usuários
      final usuarios = await _loadUsuariosCadastrados();

      // Gerar um novo ID único
      final int novoId = usuarios.isEmpty
          ? 1
          : (usuarios.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) +
                1);

      // Criar o novo usuário com ID e data de cadastro
      final novoUsuarioCompleto = UsuarioModel(
        id: novoId,
        nome: novoUsuario.nome,
        email: novoUsuario.email,
        matricula: novoUsuario.matricula,
        campusId: novoUsuario.campusId,
        telefone: novoUsuario.telefone,
        senha: novoUsuario.senha,
        avatar: novoUsuario.nome
            .substring(0, 1)
            .toUpperCase(), // Primeira letra do nome
        dataCadastro: DateTime.now().toIso8601String().split(
          'T',
        )[0], // Formato YYYY-MM-DD
      );

      // Adicionar à lista
      usuarios.add(novoUsuarioCompleto);

      // Salvar a lista atualizada
      await _saveUsuariosCadastrados(usuarios);

      return {
        'sucesso': true,
        'mensagem': 'Usuário cadastrado com sucesso',
        'dados': {
          'id': novoId,
          'nome': novoUsuarioCompleto.nome,
          'email': novoUsuarioCompleto.email,
        },
      };
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return {
        'sucesso': false,
        'mensagem': 'Erro ao cadastrar usuário: $e',
        'erros': {},
      };
    }
  }

  // Inicializa o arquivo de usuários cadastrados se necessário
  Future<void> inicializarUsuariosCadastrados() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/usuarios_cadastrados.json');

      if (!await file.exists()) {
        // Se o arquivo não existir, cria um com os usuários padrão
        final String initialData = await rootBundle.loadString(
          _usuariosCadastradosAsset,
        );
        await file.writeAsString(initialData);
        print('Arquivo de usuários cadastrados inicializado em: ${file.path}');
      } else {
        print('Arquivo de usuários cadastrados já existe em: ${file.path}');
      }
    } catch (e) {
      print('Erro ao inicializar usuários cadastrados: $e');
    }
  }
}
