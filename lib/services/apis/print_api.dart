import '../http_services.dart';

class PrintService {
  final CustomHttp _httpHelper = CustomHttp();

  Future<int> sendPrintRequest(String filePath, int teamId) async {
    try {
      final response = await _httpHelper.post(
        '/printPDF',
        {'filePath': filePath, 'teamId': teamId},
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