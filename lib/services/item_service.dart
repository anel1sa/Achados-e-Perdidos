import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'usuario_service.dart';

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

class ItemService {
  final UsuarioService _usuarioService = UsuarioService();

  // Carrega o banco de dados JSON
  Future<Map<String, dynamic>> _loadDatabase() async {
    final String response = await rootBundle.loadString('assets/db.json');
    return json.decode(response);
  }

  // Busca todos os itens achados com os nomes dos usuários
  Future<List<ItemAchadoModel>> getItensAchados() async {
    try {
      final db = await _loadDatabase();
      final List<dynamic> itensJson = db['itensAchados'];
      final List<ItemAchadoModel> itens = itensJson
          .map((json) => ItemAchadoModel.fromJson(json))
          .toList();

      // Buscar os usuários para obter os nomes
      final usuarios = await _usuarioService.getUsuarios();

      // Adicionar o nome do usuário a cada item
      for (var item in itens) {
        final usuario = usuarios.firstWhere(
          (u) => u.id == item.usuarioId,
          orElse: () => UsuarioModel(
            id: 0,
            nome: "Usuário Desconhecido",
            email: "",
            matricula: "",
            campusId: 0,
            telefone: "",
            senha: "",
          ),
        );
        item.nomeUsuario = usuario.nome;
      }

      return itens;
    } catch (e) {
      print('Erro ao carregar itens achados: $e');
      return [];
    }
  }
}
