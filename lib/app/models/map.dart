import 'package:button_press_game/app/enums/map_type.dart';

class GameMap {
  final int x;
  final int y;
  final MapType mapType;

  GameMap({required this.x, required this.y, required this.mapType});

  /// Cria uma cópia da instância com novos valores.
  GameMap copyWith({int? x, int? y, MapType? mapType}) {
    return GameMap(
      x: x ?? this.x,
      y: y ?? this.y,
      mapType: mapType ?? this.mapType,
    );
  }

  /// Método para exibir as informações do mapa.
  void displayInfo() {
    print('Position: ($x, $y), Type: $mapType');
  }
}
