import '../../models/yarn_model.dart';
import '../../utils/constants.dart';
import '../http_services.dart';

class YarnApi {
  final CustomHttp _httpHelper = CustomHttp();

  Future<List<Hilo>> fetchYarns() async {
    try {

      final data = await _httpHelper.get('/${Consts.getHilos}');
        List<Hilo> hilos = (data as List).map((json) => Hilo.fromJson(json)).toList();

      return hilos;
      
    } catch (e) {
      throw Exception('CATCH-Error al obtener los hilos: $e');
    }
  }
}
