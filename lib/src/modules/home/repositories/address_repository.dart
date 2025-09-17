import 'package:dio/dio.dart';
import 'package:fastlocation/src/http/dio_config.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';

class AddressRepository {
  final Dio _dio = DioConfig.dio;
  
  Future<AddressModel> getAddressByCep(String cep) async {
    try {
      final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (cleanCep.length != 8) {
        throw Exception('CEP deve conter 8 dígitos');
      }
      
      final response = await _dio.get('$cleanCep/json/');
      
      if (response.data['erro'] == true) {
        throw Exception('CEP não encontrado');
      }
      
      return AddressModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout de conexão. Verifique sua internet.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout ao receber dados. Tente novamente.');
      } else {
        throw Exception('Erro na consulta: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
  
  Future<List<AddressModel>> getAddressByCity(
    String city, 
    String state, 
    String street,
  ) async {
    try {
      final response = await _dio.get('$state/$city/$street/json/');
      
      if (response.data is List) {
        final List<dynamic> data = response.data;
        if (data.isEmpty) {
          throw Exception('Endereço não encontrado');
        }
        
        return data
            .map((item) => AddressModel.fromJson(item))
            .take(10) // Limitar a 10 resultados
            .toList();
      } else {
        throw Exception('Formato de resposta inválido');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout de conexão. Verifique sua internet.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout ao receber dados. Tente novamente.');
      } else {
        throw Exception('Erro na consulta: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}