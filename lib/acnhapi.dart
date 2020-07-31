import 'package:http/http.dart' as http;

import 'package:acnh_helper/utils.dart';

class AcnhApi {
  static final AcnhApi instance = AcnhApi._();
  static final _client = http.Client();
  static final _baseUrl = "https://acnhapi.com/v1a";

  AcnhApi._();

  Future<http.Response> getArts({int id}) async => _get("$_baseUrl/art", id: id);

  Future<http.Response> getBugs({int id}) async => _get("$_baseUrl/bugs", id: id);

  Future<http.Response> getFishes({int id}) async => _get("$_baseUrl/fish", id: id);

  Future<http.Response> getFossils({int id}) async => _get("$_baseUrl/fossils", id: id);

  Future<http.Response> getSeaCreatures({int id}) async => _get("$_baseUrl/sea", id: id);

  Future<http.Response> getVillagers({int id}) async => _get("$_baseUrl/villagers", id: id);

  Future<http.Response> _get(String uri, {int id}) async {
    final response = await _client.get("$uri/${id != null ? id.toString() : ''}");
    if (response.ok) {
      return response;
    } else {
      throw Exception("Unable to connect to $uri");
    }
  }
}