import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/campus_remote_datasource.dart';
import '../DTOs/campus_dto.dart';
import '../DTOs/campus_dto.dart';
import '../../core/network/dio_client.dart';
import '../../core/cache/cache_service.dart';

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

  /// Busca todos os campus (com cache de 30 minutos)
  Future<List<CampusDTO>> getAllCampus() async {
    return await CacheService.getCampus<CampusDTO>(
      key: 'all_campus',
      fetchFromApi: () => _dataSource.getAll(),
      fromJson: (json) => CampusDTO.fromJson(json),
      toJson: (campus) => campus.toJson(),
    );
  }

  /// Busca campus ativos (com cache de 30 minutos)
  Future<List<CampusDTO>> getCampusAtivos() async {
    return await CacheService.getCampus<CampusDTO>(
      key: 'active_campus',
      fetchFromApi: () => _dataSource.getAllActive(),
      fromJson: (json) => CampusDTO.fromJson(json),
      toJson: (campus) => campus.toJson(),
    );
  }

  /// Busca campus por ID (com cache de 30 minutos)
  Future<CampusDTO> getCampusById(int id) async {
    return await CacheService.get<CampusDTO>(
      key: 'campus_$id',
      boxName: 'campus_cache',
      fetchFromApi: () => _dataSource.getById(id),
      ttl: const Duration(minutes: 30),
      fromJson: (json) => CampusDTO.fromJson(json),
      toJson: (campus) => campus.toJson(),
    ) ?? await _dataSource.getById(id);
  }

  /// Busca campus por instituição (com cache de 30 minutos)
  Future<List<CampusDTO>> getCampusByInstituicao(int instituicaoId) async {
    return await CacheService.getCampus<CampusDTO>(
      key: 'campus_instituicao_$instituicaoId',
      fetchFromApi: () => _dataSource.getByInstituicao(instituicaoId),
      fromJson: (json) => CampusDTO.fromJson(json),
      toJson: (campus) => campus.toJson(),
    );
  }

  /// Cria um novo campus (invalida cache)
  Future<CampusDTO> createCampus(CampusCreateDTO dto) async {
    final campus = await _dataSource.create(dto);
    await CacheService.invalidateCampus('all_campus');
    await CacheService.invalidateCampus('active_campus');
    return campus;
  }

  /// Atualiza um campus (invalida cache)
  Future<CampusDTO> updateCampus(int id, CampusUpdateDTO dto) async {
    final campus = await _dataSource.update(id, dto);
    await CacheService.invalidateCampus('campus_$id');
    await CacheService.invalidateCampus('all_campus');
    await CacheService.invalidateCampus('active_campus');
    return campus;
  }

  /// Deleta um campus (invalida cache)
  Future<void> deleteCampus(int id) async {
    await _dataSource.delete(id);
    await CacheService.invalidateCampus('campus_$id');
    await CacheService.invalidateCampus('all_campus');
    await CacheService.invalidateCampus('active_campus');
  }
}


