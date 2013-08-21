part of infinite_mario_bros;

class MapState extends GameState {
  static const WIDTH = 320 ~/ 16 + 1;
  static const HEIGHT = 240 ~/ 16 + 1;
  final Random _random = new Random();
  final Camera _camera = new Camera();
  final List<List<MapTile>> _level = new List<List<MapTile>>.generate(WIDTH,
      (index) => new List<MapTile>(HEIGHT));
  final List<List<int>> _data = new List<List<int>>.generate(WIDTH,
      (index) => new List<int>(HEIGHT));
  Point _marioPoint = new Point();
  Vector _marioAcceleration = new Vector(0, 0);
  int _moveTime;
  int _levelId;
  int _farthest;
  Point _farthestCap;
  final CanvasElement _mapImage = new CanvasElement(width: 320, height: 240);
  CanvasRenderingContext2D _mapContext;
  bool _canEnterLevel = false;
  bool _enterLevel;
  int _levelDifficulty;
  int _levelType;
  int _worldNumber = -1;
  var _waterSprite = new AnimatedSprite(resources.images['worldMap'],
      new Rect(0, 0, 16, 16),
      frameDuration: new Duration(milliseconds: 1000 ~/ 3))
  ..sequences['loop'] = new AnimationSequence(
      new Point(0 * 16, 14 * 16), new Point(3 * 16, 14 * 16));

  var _decoSprite = new AnimatedSprite(resources.images['worldMap'],
      new Rect(0, 0, 16, 16),
      frameDuration: new Duration(milliseconds: 1000 ~/ 3))
      ..sequences['world0'] = new AnimationSequence(
          new Point(0 * 16, 10 * 16), new Point(3 * 16, 10 * 16))
      ..sequences['world1'] = new AnimationSequence(
          new Point(0 * 16, 11 * 16), new Point(3 * 16, 11 * 16))
      ..sequences['world2'] = new AnimationSequence(
          new Point(0 * 16, 12 * 16), new Point(3 * 16, 12 * 16))
      ..sequences['world3'] = new AnimationSequence(
          new Point(0 * 16, 13 * 16), new Point(3 * 16, 13 * 16));

  var _helpSprite = new AnimatedSprite(resources.images['worldMap'],
      new Rect(0, 0, 16, 16),
      frameDuration: new Duration(milliseconds: 1000 ~/ 2))
      ..sequences['help'] = new AnimationSequence(
          new Point(3 * 16, 7 * 16), new Point(5 * 16, 7 * 16));

  var _smallMario = new AnimatedSprite(resources.images['worldMap'],
      new Rect(0, 0, 16, 16),
      frameDuration: new Duration(milliseconds: 1000 ~/ 3))
      ..sequences['small'] = new AnimationSequence(
          new Point(0 * 16, 1 * 16), new Point(1 * 16, 1 * 16));

  var _largeMario = new AnimatedSprite(resources.images['worldMap'],
      new Rect(0, 0, 16, 32),
      frameDuration: new Duration(milliseconds: 1000 ~/ 3))
      ..sequences['large'] = new AnimationSequence(
          new Point(2 * 16, 0 * 16), new Point(3 * 16, 0 * 16))
      ..sequences['fire'] = new AnimationSequence(
          new Point(4 * 16, 0 * 16), new Point(5 * 16, 0 * 16));

  final SpriteFont _font = createWhiteFont();
  final SpriteFont _fontShadow = createBlackFont();

  MapState() {
    _mapContext = _mapImage.context2D;
    _nextWorld();
  }

  @override
  void checkForChange(GameStateContext context) {
    /*if (_worldNumber == 8) context.changeState(new WinState());
    if (!_enterLevel) return;
    context.changeState(new LevelState(_levelDifficulty, _levelType));*/
  }

  @override
  void draw(CanvasRenderingContext2D context) {

    if (_worldNumber == 8) return;

    context.drawImage(_mapImage, 0, 0);

    Point helpPoint;
    for (var x = 0; x < WIDTH; x++) for (var y = 0; y < HEIGHT; y++) {
      switch (_level[x][y]) {
        case MapTile.WATER:
          if (!_isWater(x * 2 - 1, y * 2 - 1)) continue;
          _waterSprite
              ..point = new Point(x * 16 - 8, y * 16 - 8)
              ..draw(context, _camera);
          break;
        case MapTile.DECORATION:
          _decoSprite
              ..point = new Point(x * 16, y * 16)
              ..draw(context, _camera);
          break;
        case MapTile.LEVEL:
          if (_data[x][y] == -2) helpPoint = new Point(x, y);
      }
    }
    _helpSprite
        ..point = helpPoint * 16 + new Point(16, -16)
        ..draw(context, _camera);

    if (!Mario.large) {
      _smallMario.draw(context, _camera);
    } else {
      _largeMario.draw(context, _camera);
    }

    _fontShadow.draw(context, _camera);
    _font.draw(context, _camera);
  }

  @override
  void enter() {
    _waterSprite.playSequence('loop', true);
    _decoSprite.playSequence('world${_worldNumber % 4}', true);
    _helpSprite.playSequence('help', true);
    _smallMario.playSequence('small', true);
    _largeMario.playSequence(Mario.fire ? 'fire' : 'large', true);

    _enterLevel = false;
    _levelDifficulty = 0;
    _levelType = 0;

    _font
        ..spriteStrings.clear()
        ..spriteStrings.add(new SpriteString('MARIO ${Mario.lives}',
            new Point(4, 4)))
        ..spriteStrings.add(new SpriteString('WORLD ${_worldNumber + 1}',
            new Point(256, 4)));
    _fontShadow
        ..spriteStrings.clear()
        ..spriteStrings.addAll(createFontShadowSpriteStrings(_font));

    // _playMapMusic();
  }

  @override
  void exit() {
    // _stopMusic();
  }

  @override
  void update(num delta) {
    if (_worldNumber == 8) return;

    _marioPoint += _marioAcceleration.toPoint();

    // TODO: Probably should use a drawable manager.
    _waterSprite.update(delta);
    _decoSprite.update(delta);
    _helpSprite.update(delta);
    // TODO: Figure out what this is doing.
    if (!Mario.large) {
      _smallMario
          ..point = new Point(
              _marioPoint.x + (_marioAcceleration.x * delta).floor(),
              _marioPoint.y + (_marioAcceleration.y * delta).floor() - 6)
          ..update(delta);
    } else {
      _largeMario
          ..point = new Point(
              _marioPoint.x + (_marioAcceleration.x * delta).floor(),
              _marioPoint.y + (_marioAcceleration.y * delta).floor() - 22)
          ..update(delta);
    }

    var x = _marioPoint.x ~/ 16;
    var y = _marioPoint.y ~/ 16;

    if (_level[x][y] == MapTile.ROAD) _data[x][y] = 0;

    if (_moveTime > 0) {
      _moveTime--;
      return;
    }
    _marioAcceleration = new Vector(0, 0);

    if (_canEnterLevel && keyboard.isKeyDown(KeyCode.S) &&
        _level[x][y] == MapTile.LEVEL && _data[x][y] != -11 &&
        _level[x][y] == MapTile.LEVEL && _data[x][y] != 0 &&
        _data[x][y] > -10) {
      _levelDifficulty = _worldNumber + 1;

      Mario.levelString = '$_levelDifficulty-';
      if (_data[x][y] < 0) {
        switch (_data[x][y]) {
          case -1:
            Mario.levelString += '?';
            break;
          case -2:
            Mario.levelString += 'X';
            _levelDifficulty += 2;
            break;
          default:
            Mario.levelString += '#';
            _levelDifficulty += 1;
        }
        _levelType = LevelType.CASTLE;
      } else {
        Mario.levelString += _data[x][y].toString();
        if (_data[x][y] > 1 && _random.nextInt(3) == 0) {
          _levelType = LevelType.UNDERGROUND;
        } else {
          _levelType = LevelType.OVERGROUND;
        }
      }

      _enterLevel = true;
    }

    _canEnterLevel = !keyboard.isKeyDown(KeyCode.S);

    if (keyboard.isKeyDown(KeyCode.LEFT)) _tryWalking(new Vector(-1, 0));
    if (keyboard.isKeyDown(KeyCode.RIGHT)) _tryWalking(new Vector(1, 0));
    if (keyboard.isKeyDown(KeyCode.UP)) _tryWalking(new Vector(0, -1));
    if (keyboard.isKeyDown(KeyCode.DOWN)) _tryWalking(new Vector(0, 1));
  }

  void _nextWorld() {
    _worldNumber++;

    // If player has won, wait for CheckForChange to get called.
    if (_worldNumber == 8) return;

    _moveTime = 0;
    _levelId = 0;
    _farthest = 0;
    _farthestCap = new Point();

    _generateLevel();
    _renderStatic();
  }

  void _generateLevel() {
    while (true) {
      var n0 = new ImprovedNoise();
      var n1 = new ImprovedNoise();
      var dec = new ImprovedNoise();

      for (var column in _level) for (var tile in column) tile = null;
      for (var column in _data) for (var tile in column) tile = null;

      var o0 = new Point(_random.nextInt(512), _random.nextInt(512));
      var o1 = new Point(_random.nextInt(512), _random.nextInt(512));

      for (var x = 0; x < WIDTH; x++) for (var y = 0; y < HEIGHT; y++) {
        var t0 = n0.perlinNoise(o0 + new Point(x * 10, y * 10));
        var t1 = n1.perlinNoise(o1 + new Point(x * 10, y * 10));
        var tDistance = t0 - t1;

        _level[x][y] = tDistance.isNegative ? MapTile.GRASS : MapTile.WATER;
      }

      var lowestPoint = new Point(double.MAX_FINITE, double.MAX_FINITE);
      var t = 0;
      for (var i = 0; i < 100 && t < 12; i++) {
        var x = _random.nextInt((WIDTH - 1) ~/ 3) * 3 + 2;
        var y = _random.nextInt((HEIGHT - 1) ~/ 3) * 3 + 1;
        if (_level[x][y] != MapTile.GRASS) continue;
        if (x < lowestPoint.x) lowestPoint = new Point(x, y);
        _level[x][y] = MapTile.LEVEL;
        _data[x][y] = -1;
        t++;
      }
      _data[lowestPoint.x][lowestPoint.y] = -2;

      _findConnection(WIDTH, HEIGHT);
      _findCaps(WIDTH, HEIGHT);

      if (_farthestCap == new Point()) continue;

      _data[_farthestCap.x][_farthestCap.y] = -2;
      _data[_marioPoint.x ~/ 16][_marioPoint.y ~/ 16] = -11;

      for (var x = 0; x < WIDTH; x++) for (var y = 0; y < HEIGHT; y++) {
        if (_level[x][y] != MapTile.GRASS ||
            x == _farthestCap.x && y == _farthestCap.y - 1 ||
            dec.perlinNoise(o0 + new Point(x * 10, y * 10)) <= 0) continue;
        _level[x][y] = MapTile.DECORATION;
      }

      return;
    }
  }

  void _findConnection(int width, int height) {
    for (var x = 0; x < width; x++) for (var y = 0; y < height; y++) {
      if (_level[x][y] != MapTile.LEVEL || _data[x][y] != -1) continue;
      _connect(new Point(x, y), width, height);
      _findConnection(width, height);
      return;
    }
    return;
  }

  void _connect(Point source, int width, int height) {
    var maxDistance = double.MAX_FINITE;

    var target;
    for (var x = 0; x < width; x++) for (var y = 0; y < height; y++) {
      if (_level[x][y] != MapTile.LEVEL || _data[x][y] != -2) continue;
      var distance =
          sqrt(pow((source.x - x).abs(), 2) + pow((source.y - y).abs(), 2));
      if (distance >= maxDistance) continue;
      target = new Point(x, y);
      maxDistance = distance;
    }

    _drawRoad(source, target);
    _level[source.x][source.y] = MapTile.LEVEL;
    _data[source.x][source.y] = -2;
  }

  void _drawRoad(Point source, Point target) {
    var xFirst = _random.nextInt(2) == 1;

    while (source.x != target.x || source.y != target.y) {
      _data[source.x][source.y] = 0;
      _level[source.x][source.y] = MapTile.ROAD;
      source += (source.x != target.x && (xFirst || source.y == target.y)) ?
          ((source.x > target.x) ? new Point(-1, 0) : new Point(1, 0)) :
          ((source.y > target.y) ? new Point(0, -1) : new Point(0, 1));
    }
  }

  void _findCaps(int width, int height) {
    var cap = new Point(-1, -1);

    for (var x = 0; x < width; x++) for (var y = 0; y < height; y++) {
      if (_level[x][y] != MapTile.LEVEL) continue;
      var roads = 0;

      for (var xx = x - 1; xx <= x + 1; xx++) {
        for (var yy = y - 1; yy <= y + 1; yy++) {
          if (_level[xx][yy] == MapTile.ROAD) roads++;
        }
      }

      if (roads != 1) {
        _data[x][y] = 1;
        continue;
      }
      _data[x][y] = 0;
      if (cap.x != -1) continue;
      cap = new Point(x, y);
    }

    _marioPoint = cap * 16;

    _travel(cap, -1, 0);
  }

  void _travel(Point point, int dir, int depth) {
    switch (_level[point.x][point.y]) {
      case MapTile.ROAD:
        _data[point.x][point.y] = 1;
        break;
      case MapTile.LEVEL:
        if (_data[point.x][point.y] > 0) {
          if (_levelId != 0 && _random.nextInt(4) == 0) {
            _data[point.x][point.y] = -3;
          } else {
            _data[point.x][point.y] = ++_levelId;
          }
        } else if (depth > 0) {
          _data[point.x][point.y] = -1;
          if (depth > _farthest) {
            _farthest = depth;
            _farthestCap = point;
          }
        }
        break;
      default: return;
    }

    if (dir != 2) _travel(point - new Point(1, 0), 0, depth++);
    if (dir != 3) _travel(point - new Point(0, 1), 1, depth++);
    if (dir != 0) _travel(point + new Point(1, 0), 2, depth++);
    if (dir != 1) _travel(point + new Point(0, 1), 3, depth++);
  }

  void _renderStatic() {
    const WIDTH = 320 ~/ 16;
    const HEIGHT = 240 ~/ 16;
    ImageElement image = resources.images['worldMap'];

    for (var x = 0; x < WIDTH; x++) for (var y = 0; y < HEIGHT; y++) {
      var destRect = new Rect(x * 16, y * 16, 16, 16);
      var sourceRect = new Rect(_worldNumber ~/ 4 * 16, 0, 16, 16);
      _mapContext.drawImageToRect(image, destRect, sourceRect: sourceRect);

      switch (_level[x][y]) {
        case MapTile.LEVEL:
          switch (_data[x][y]) {
            case 0:
              sourceRect = new Rect(0 * 16, 7 * 16, 16, 16);
              break;
            case -1:
              sourceRect = new Rect(3 * 16, 8 * 16, 16, 16);
              break;
            case -3:
              sourceRect = new Rect(0 * 16, 8 * 16, 16, 16);
              break;
            case -10:
              sourceRect = new Rect(1 * 16, 8 * 16, 16, 16);
              break;
            case -11:
              sourceRect = new Rect(1 * 16, 7 * 16, 16, 16);
              break;
            case -2:
              destRect = new Rect(x * 16, (y - 1) * 16, 16, 32);
              sourceRect = new Rect(2 * 16, 7 * 16, 16, 32);
              break;
            default:
              sourceRect = new Rect((_data[x][y] - 1) * 16, 6 * 16, 16, 16);
          }
          break;
        case MapTile.ROAD:
          sourceRect = new Rect(((_isRoad(x - 1, y) ? 1 : 0) +
              (_isRoad(x, y - 1) ? 2 : 0) + (_isRoad(x + 1, y) ? 4 : 0) +
              (_isRoad(x, y + 1) ? 8 : 0)) * 16, 2 * 16, 16, 16);
          break;
        case MapTile.WATER:
          for (var xx = 0; xx < 2; xx++) for (var yy = 0; yy < 2; yy++) {
            var sprite =
                (_isWater(x * 2 + (xx - 1), y * 2 + (yy - 1)) ? 0 : 1) +
                (_isWater(x * 2 + xx, y * 2 + (yy - 1)) ? 0 : 2) +
                (_isWater(x * 2 + (xx - 1), y * 2 + yy) ? 0 : 4) +
                (_isWater(x * 2 + xx, y * 2 + yy) ? 0 : 8) - 1;
            if (sprite >= 0 && sprite <= 14) {
              _mapContext.drawImageToRect(image,
                  new Rect(x * 16 + xx * 8, y * 16 + yy * 8, 8, 8),
                  sourceRect: new Rect(
                      sprite * 16, (4 + ((xx + yy).isOdd ? 1 : 0)) * 16, 8, 8));
            }
          }
          continue;
        default: continue;
      }
      _mapContext.drawImageToRect(image, destRect, sourceRect: sourceRect);
    }
  }

  bool _isRoad(int x, int y) {
    return _level[x][y] == MapTile.ROAD || _level[x][y] == MapTile.LEVEL;
  }

  bool _isWater(int x, int y) {
    if (x.isNegative) x = 0;
    if (y.isNegative) y = 0;

    for (var xx = 0; xx < 2; xx++) for (var yy = 0; yy < 2; yy++) {
      if (_level[(x + xx) ~/ 2][(y + yy) ~/ 2] != MapTile.WATER) return false;
    }

    return true;
  }

  void _tryWalking(Vector direction) {
    var point = new Point(_marioPoint.x ~/ 16, _marioPoint.y ~/ 16);
    var tryPoint = point + direction.toPoint();

    if (_level[tryPoint.x][tryPoint.y] != MapTile.ROAD &&
        _level[tryPoint.x][tryPoint.y] != MapTile.LEVEL ||
        _data[tryPoint.x][tryPoint.y] != 0 && _data[point.x][point.y] != 0 &&
        _data[point.x][point.y] > -10) return;

    _marioAcceleration = _marioAcceleration.scale(8);
    _moveTime = _calcDistance(point, direction);
  }

  int _calcDistance(Point point, Vector direction) {
    var nextPoint = point + direction.toPoint();
    if (_level[nextPoint.x][nextPoint.y] != MapTile.ROAD ||
        _level[point.x - direction.y][point.y + direction.x] == MapTile.ROAD ||
        _level[point.x + direction.y][point.y - direction.x] == MapTile.ROAD ) {
      return 0;
    }
    return 1 + _calcDistance(nextPoint, direction);
  }

  void _levelWon() {
    Point point = new Point(_marioPoint.x ~/ 16, _marioPoint.y ~/ 16);
    switch (_data[point.x][point.y]){
      case -2:
        _nextWorld();
        return;
      case -3:
        _data[point.x][point.y] = 0;
        break;
      default:
        _data[point.x][point.y] = -10;
    }
    _renderStatic();
  }
}