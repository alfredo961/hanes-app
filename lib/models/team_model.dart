class Team {
  int? id;
  String? nombre;
  String? color;

  Team({this.id, this.nombre, this.color});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombre'] = nombre;
    data['Color'] = color;
    return data;
  }
}
