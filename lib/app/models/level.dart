class Level {
  // Level({required this.id, required this.map});

  // final int id;
  // final List<List<String>> map;

  // /// Retorna o valor na posição específica (x, y) do mapa.
  // String getValueAtPosition(int x, int y) {
  //   if (x >= 0 && x < map.length && y >= 0 && y < map[x].length) {
  //     return map[x][y];
  //   } else {
  //     throw Exception('Posição fora dos limites do mapa!');
  //   }
  // }

  /// Gera um nível de exemplo com linhas de tamanhos variáveis.
  static List<List<String>> generateLevel(int id) {
    List<List<String>> generatedMap = [
      ['X', '0', 'X', '0'], // Linha com 4 itens
      ['0', 'X', '0'], // Linha com 3 itens
      ['X', 'X', '0', 'X'], // Linha com 4 itens
      ['0', '0', 'X'], // Linha com 3 itens
    ];

    return generatedMap;
  }

  /// Imprime o mapa no console para depuração.
  // void printMap() {
  //   for (var row in map) {
  //     print(row.join(' '));
  //   }
  // }
}
