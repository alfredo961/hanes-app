class Hilo {
  int? id;
  String? cod;
  String? item;
  String? description;
  String? vendor;
  String? yarnType;
  FotosHilos? fotosHilos;
  FotosHilos? fotosDescripcionesHilos;

  Hilo(
      {this.id,
      this.cod,
      this.item,
      this.description,
      this.vendor,
      this.yarnType,
      this.fotosHilos,
      this.fotosDescripcionesHilos});

  Hilo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cod = json['cod'];
    item = json['item'];
    description = json['description'];
    vendor = json['vendor'];
    yarnType = json['yarn_type'];
    fotosHilos = json['fotosHilos'] != null
        ? FotosHilos.fromJson(json['fotosHilos'])
        : null;
    fotosDescripcionesHilos = json['fotosDescripcionesHilos'] != null
        ? FotosHilos.fromJson(json['fotosDescripcionesHilos'])
        : null;
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
}

class FotosHilos {
  String? nombre;
  String? ruta;

  FotosHilos({this.nombre, this.ruta});

  FotosHilos.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    ruta = json['ruta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['ruta'] = ruta;
    return data;
  }
}
