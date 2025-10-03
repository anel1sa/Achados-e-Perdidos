import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'usuario_service.dart';

/// Modelo que representa um item encontrado (achado)
class ItemAchadoModel {
  final int id;
  final String titulo;
  final String descricao;
  final int categoriaId;
  final String localEncontrado;
  final String dataEncontrado;
  final int usuarioId;
  final String status;
  final List<String> fotos;
  final String contato;
  String? nomeUsuario; // Nome do usuário que postou o item

  ItemAchadoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoriaId,
    required this.localEncontrado,
    required this.dataEncontrado,
    required this.usuarioId,
    required this.status,
    required this.fotos,
    required this.contato,
    this.nomeUsuario,
  });

  factory ItemAchadoModel.fromJson(Map<String, dynamic> json) {
    return ItemAchadoModel(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      categoriaId: json['categoriaId'],
      localEncontrado: json['localEncontrado'],
      dataEncontrado: json['dataEncontrado'],
      usuarioId: json['usuarioId'],
      status: json['status'],
      fotos: List<String>.from(json['fotos']),
      contato: json['contato'],
    );
  }
}

/// Serviço responsável pela gestão de itens achados e perdidos
class ItemService {
  // Constants
  static const String _databaseAsset = 'assets/db.json';

  // Services
  final UsuarioService _usuarioService = UsuarioService();

  // Carrega o banco de dados JSON
  /// Carrega o banco de dados principal
  Future<Map<String, dynamic>> _loadDatabase() async {
    try {
      final String response = await rootBundle.loadString(_databaseAsset);
      return json.decode(response);
    } catch (e) {
      throw Exception('Erro ao carregar banco de dados: $e');
    }
  }

  /// Retorna todos os itens achados com os nomes dos usuários
  Future<List<ItemAchadoModel>> getItensAchados() async {
    try {
      final db = await _loadDatabase();
      final List<dynamic> itensJson = db['itensAchados'];
      final itens = _parseItensFromJson(itensJson);

      return await _enrichWithUserNames(itens);
    } catch (e) {
      print('Erro ao carregar itens achados: $e');
      return [];
    }
  }

  /// Converte JSON em lista de ItemAchadoModel
  List<ItemAchadoModel> _parseItensFromJson(List<dynamic> itensJson) {
    return itensJson.map((json) => ItemAchadoModel.fromJson(json)).toList();
  }

  /// Adiciona os nomes dos usuários aos itens
  Future<List<ItemAchadoModel>> _enrichWithUserNames(
    List<ItemAchadoModel> itens,
  ) async {
    final usuarios = await _usuarioService.getUsuarios();

    for (var item in itens) {
      final usuario = _findUserById(usuarios, item.usuarioId);
      item.nomeUsuario = usuario.nome;
    }

    return itens;
  }

  /// Busca um usuário pelo ID ou retorna um usuário padrão
  UsuarioModel _findUserById(List<UsuarioModel> usuarios, int usuarioId) {
    try {
      return usuarios.firstWhere((u) => u.id == usuarioId);
    } catch (e) {
      return _createUnknownUser();
    }
  }

  /// Cria um usuário padrão para casos onde o usuário não é encontrado
  UsuarioModel _createUnknownUser() {
    return UsuarioModel(
      id: 0,
      nome: "Usuário Desconhecido",
      email: "",
      matricula: "",
      campusId: 0,
      telefone: "",
      senha: "",
    );
  }
}
