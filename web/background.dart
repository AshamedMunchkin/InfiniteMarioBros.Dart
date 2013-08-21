part of infinite_mario_bros;

class Background implements Drawable {
  final Resources _resources = new Resources();
  final List<List<Rect>> _distantLayer;
  final List<List<Rect>> _closeLayer;
  final Random _random = new Random();

  Background.overground(int width, int height)
      : _distantLayer = new List<List<Rect>>.generate(width, (index) =>
            new List<Rect>(height)),
        _closeLayer = new List<List<Rect>>.generate(width, (index) =>
            new List<Rect>(height)) {
    {
      var hillHeight = _random.nextInt(4) + 2;
      for (var column in _distantLayer) {
        var oldHillHeight = hillHeight;
        while (oldHillHeight == hillHeight) {
          hillHeight = _random.nextInt(4) + 2;
        }
        for (var y = 0; y < height; y++) {
          var shorterHeight = min(oldHillHeight, hillHeight);
          var tallerHeight = max(oldHillHeight, hillHeight);
          if (7 - y > tallerHeight) {
            column[y] = backgroundSheet[4][min(y, 2)];
          } else if (7 - y == tallerHeight) {
            column[y] = backgroundSheet[tallerHeight == hillHeight ? 2 : 3][0];
          } else if (7 - y == shorterHeight) {
            column[y] = backgroundSheet[tallerHeight == hillHeight ? 2 : 3][2];
          } else {
            column[y] = backgroundSheet[2 + ((7 - y < shorterHeight) ==
                (tallerHeight == oldHillHeight) ? 0 : 1)][1];
          }
        }
      }
    }

    {
      var hillHeight = _random.nextInt(6) + 1;
      for (var column in _closeLayer) {
        var oldHillHeight = hillHeight;
        while (oldHillHeight == hillHeight) {
          hillHeight = _random.nextInt(6) + 1;
        }
        for (var y = 0; y < height; y++) {
          var shorterHeight = min(oldHillHeight, hillHeight);
          var tallerHeight = max(oldHillHeight, hillHeight);
          if (7 - y > tallerHeight) {
            column[y] = backgroundSheet[5][0];
          } else if (7 - y == tallerHeight) {
            column[y] = backgroundSheet[tallerHeight == hillHeight ? 0 : 1][0];
          } else if (7 - y == shorterHeight) {
            column[y] = backgroundSheet[tallerHeight == hillHeight ? 0 : 1][2];
          } else {
            column[y] = backgroundSheet[((7 - y < shorterHeight) ==
                (tallerHeight == oldHillHeight) ? 0 : 1)][1];
          }
        }
      }
    }
  }

  void draw(CanvasRenderingContext2D context, Camera camera) {
    {
      var cameraX = camera.point.x / 2;

      var xTileStart = cameraX ~/ 32;
      var xTileEnd = (cameraX + 320) ~/ 32;

      for (var x = xTileStart; x <= xTileEnd; x++) {
        for (var y = 0; y < _distantLayer[x].length; y++) {
          var frame = _distantLayer[x][y];

          context.drawImageScaledFromSource(_resources.images['background'],
              frame.left, frame.top, frame.width, frame.height,
              x * 32 - cameraX.floor(), y * 32, frame.width, frame.height);
        }
      }
    }

    {
      var cameraX = camera.point.x;

      var xTileStart = cameraX ~/ 32;
      var xTileEnd = (cameraX + 320) ~/ 32;

      for (var x = xTileStart; x <= xTileEnd; x++) {
        for (var y = 0; y < _closeLayer[x].length; y++) {
          var frame = _closeLayer[x][y];

          context.drawImageScaledFromSource(_resources.images['background'],
              frame.left, frame.top, frame.width, frame.height,
              x * 32 - cameraX.floor(), y * 32, frame.width, frame.height);
        }
      }
    }
  }

  void update(num delta) {}
}