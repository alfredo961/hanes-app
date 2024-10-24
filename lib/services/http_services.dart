import 'dart:convert';
import 'dart:io';
import 'package:hilaza/utils/constants.dart';
import 'package:http/http.dart' as http;

class CustomHttp {
  String baseUrl = Consts.emulatorBaseUrl;

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'))
          .timeout(const Duration(seconds: Consts.timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error al realizar la petición GET: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: Consts.timeoutSeconds)); 
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error al realizar la petición POST: $e');
    }
  }

  Future<dynamic> postMultipart(String endpoint, Map<String, dynamic> body, File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      request.fields.addAll(body.map((key, value) => MapEntry(key, value.toString())));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Error al realizar la petición POST: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error al realizar la petición POST Multipart: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: Consts.timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error al realizar la petición PUT: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'))
          .timeout(const Duration(seconds: Consts.timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error al realizar la petición DELETE: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Solicitud incorrecta: ${response.body}');
      case 401:
        throw Exception('No autorizado: ${response.body}');
      case 403:
        throw Exception('Prohibido: ${response.body}');
      case 404:
        throw Exception('No encontrado: ${response.body}');
      case 500:
        throw Exception('Error del servidor: ${response.body}');
      default:
        throw Exception('Error desconocido: ${response.body}');
    }
  }
}