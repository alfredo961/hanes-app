import '../../models/search_by_category_model.dart';
import '../http_services.dart';

class SearchByCategoryApi {
  final CustomHttp _httpHelper = CustomHttp();

  Future<List<CategoryResult>> fetchCategories(String category) async {
    try {
      final data = await _httpHelper.get('/getYarnByType?yarn_type=$category');
      return (data as List).map((item) => CategoryResult.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error al obtener las categorías: $e');
    }
  }
}
