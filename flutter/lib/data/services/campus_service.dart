import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/campus_remote_datasource.dart';
import '../DTOs/campus_dto.dart';
import '../DTOs/campus_dto.dart';
import '../../core/network/dio_client.dart';

/// Service para gerenciamento de campus
/// Conecta os datasources às páginas
class CampusService {
  late final CampusRemoteDataSource _dataSource;

  CampusService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = CampusRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Busca todos os campus
  Future<List<CampusDTO>> getAllCampus() async {
    return await _dataSource.getAll();
  }

  /// Busca campus ativos
  Future<List<CampusDTO>> getCampusAtivos() async {
    return await _dataSource.getAllActive();
  }

  /// Busca campus por ID
  Future<CampusDTO> getCampusById(int id) async {
    return await _dataSource.getById(id);
  }

  /// Busca campus por instituição
  Future<List<CampusDTO>> getCampusByInstituicao(int instituicaoId) async {
    return await _dataSource.getByInstituicao(instituicaoId);
  }

  /// Cria um novo campus
  Future<CampusDTO> createCampus(CampusCreateDTO dto) async {
    return await _dataSource.create(dto);
  }

  /// Atualiza um campus
  Future<CampusDTO> updateCampus(int id, CampusUpdateDTO dto) async {
    return await _dataSource.update(id, dto);
  }

  /// Deleta um campus
  Future<void> deleteCampus(int id) async {
    return await _dataSource.delete(id);
  }
}


