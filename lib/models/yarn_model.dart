import 'fotos_hilos.dart';
import 'search_by_category_model.dart';

class Hilo {
  int? id;
  String? cod;
  String? item;
  String? description;
  String? vendor;
  String? yarnType;
  FotosHilos? fotosHilos;
  FotosHilos? fotosDescripcionesHilos;

  Hilo({
    this.id,
    this.cod,
    this.item,
    this.description,
    this.vendor,
    this.yarnType,
    this.fotosHilos,
    this.fotosDescripcionesHilos,
  });

  factory Hilo.fromJson(Map<String, dynamic> json) {
    return Hilo(
      id: json['id'],
      cod: json['cod'],
      item: json['item'],
      description: json['description'],
      vendor: json['vendor'],
      yarnType: json['yarn_type'],
      fotosHilos: json['fotosHilos'] != null
          ? FotosHilos.fromJson(json['fotosHilos'])
          : null,
      fotosDescripcionesHilos: json['fotosDescripcionesHilos'] != null
          ? FotosHilos.fromJson(json['fotosDescripcionesHilos'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cod'] = cod;
    data['item'] = item;
    data['description'] = description;
    data['vendor'] = vendor;
    data['yarn_type'] = yarnType;
    if (fotosHilos != null) {
      data['fotosHilos'] = fotosHilos!.toJson();
    }
    if (fotosDescripcionesHilos != null) {
      data['fotosDescripcionesHilos'] = fotosDescripcionesHilos!.toJson();
    }
    return data;
  }

  factory Hilo.fromCategoryResult(CategoryResult categoryResult) {
    return Hilo(
      id: categoryResult.id,
      cod: categoryResult.cod,
      item: categoryResult.item,
      description: categoryResult.description,
      vendor: categoryResult.vendor,
      yarnType: categoryResult.yarnType,
      fotosHilos: categoryResult.fotosHilos,
      fotosDescripcionesHilos: categoryResult.fotosDescripcionesHilos,
    );
  }
}
