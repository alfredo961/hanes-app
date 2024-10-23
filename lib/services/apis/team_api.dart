import 'package:hilaza/utils/constants.dart';
import '../../models/team_model.dart';
import '../http_services.dart';

class TeamService {
  final CustomHttp _httpHelper = CustomHttp();

  Future<List<Team>> fetchTeams() async {
    try {
      final data = await _httpHelper.get('/${Consts.getTeams}');
      return (data as List).map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener los equipos: $e');
    }
  }
}
