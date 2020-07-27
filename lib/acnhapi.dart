import 'package:http/http.dart' as http;

import 'package:acnh_helper/utils.dart';

class AcnhApi {
  static final AcnhApi instance = AcnhApi._();
  static final _client = http.Client();
  static final _baseUrl = "https://acnhapi.com/v1a";

  AcnhApi._();

  Future<http.Response> getArts() async => _get("$_baseUrl/art");

  Future<http.Response> getBugs() async => _get("$_baseUrl/bugs");

  Future<http.Response> getFishes() async => _get("$_baseUrl/fish");

  Future<http.Response> getFossils() async => _get("$_baseUrl/fossils");

  Future<http.Response> getSeaCreatures() async => _get("$_baseUrl/sea");

  Future<http.Response> getVillagers() async => _get("$_baseUrl/villagers");

  Future<http.Response> _get(String uri) async {
    final response = await _client.get(uri);
    if (response.ok) {
      return response;
    } else {
      throw Exception("Unable to connect to $uri");
    }
  }
}