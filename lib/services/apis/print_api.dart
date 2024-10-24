import '../http_services.dart';
import 'dart:io';

class PrintService {
  final CustomHttp _httpHelper = CustomHttp();

  Future<int> sendPrintRequest(String filePath, int teamId) async {
    try {
      final file = File(filePath);
      final response = await _httpHelper.postMultipart(
        '/printOrder',
        {'teamId': teamId},
        file,
      );
      if (response['status'] != 'success') {
        throw Exception('Error al enviar la impresión: ${response['message']}');
      }
      return response['orderNumber'];
    } catch (e) {
      throw Exception('Error al enviar la impresión: $e');
    }
  }
}
