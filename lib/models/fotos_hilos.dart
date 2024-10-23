class FotosHilos {
  String? nombre;
  String? ruta;

  FotosHilos({this.nombre, this.ruta});

  factory FotosHilos.fromJson(Map<String, dynamic> json) {
    return FotosHilos(
      nombre: json['nombre'],
      ruta: json['ruta'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['ruta'] = ruta;
    return data;
  }
}
