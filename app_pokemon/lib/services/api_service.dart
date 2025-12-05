import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Pokemon>> fetchPokemons({int limit = 20}) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon?limit=$limit');
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        
        return results.map((json) => Pokemon.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar Pokémons');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}