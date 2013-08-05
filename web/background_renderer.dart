part of infinite_mario_bros;

class BackgroundRenderer extends Drawable {
  final Resources _resources = new Resources();
  final Level _level;
  final int _width;
  final int _height;
  final int _distance;
  final List<List<Rect>> _background = backgroundSheet;

  BackgroundRenderer(Level this._level, int this._width, int this._height,
      int this._distance);

  @override
  void draw(CanvasRenderingContext2D context, Camera camera) {
    var cameraX = camera.point.x / _distance;

    var xTileStart = cameraX ~/ 32;
    var xTileEnd = (cameraX + _width) ~/ 32;
    var yTiles = _height ~/ 32 + 1;

    for (var x = xTileStart; x <= xTileEnd; x++) {
      for (var y = 0; y < yTiles; y++) {
        var block = _level.map[x][y] & 0xff;
        var frame = _background[block % 8][block ~/ 8];

        context.drawImageScaledFromSource(_resources.images['background'],
            frame.left, frame.top, frame.width, frame.height,
            x * 32 - cameraX.floor(), y * 32, frame.width, frame.height);
      }
    }
  }
}