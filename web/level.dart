part of infinite_mario_bros;

class Level {
  final int _exitX = 10;
  final int _exitY = 10;
  final List<List<int>> map;
  final List<List<int>> data;
  // TODO: Find out what a spriteTemplate acutally is.
  final List<List> spriteTemplates;

  Level(int width, int height)
      : map = new List<List<int>>
          .generate(width, (index) => new List.filled(height, 0)),
        data = new List<List<int>>
          .generate(width, (index) => new List.filled(height, 0)),
        spriteTemplates = new List.generate(width, (index) => new List(height));

  void update() => data.forEach(
      (column) => column.where((tile) => tile > 0).forEach((tile) => tile--));
}