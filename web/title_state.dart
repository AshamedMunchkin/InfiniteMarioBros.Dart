part of infinite_mario_bros;

class TitleState implements GameState {
  final Resources _resources = new Resources();
  final Keyboard _keyboard = new Keyboard();
  DrawableManager _drawableManager;
  Camera _camera;
  num _logoY;
  num _bounce;
  Sprite _title;
  Sprite _logo;
  final SpriteFont _font = redFont;

  void checkForChange(GameStateContext context) {
    /*if (_keyboard.isKeyDown(KeyCode.S)) {
      globalMapState = new MapState();
      marioCharacter = new Character(_resources.images['smallMario']);
      context.changeState(globalMapState);
    }*/
  }

  void draw(CanvasRenderingContext2D context) {
    _drawableManager.draw(context, _camera);
  }

  void enter() {
    _drawableManager = new DrawableManager();
    _camera = new Camera();

    var backgroundGenerator =
        new BackgroundGenerator(2048, 15, true, LevelType.OVERGROUND);
    var backgroundLayer0 =
        new BackgroundRenderer(backgroundGenerator.createLevel(), 320, 240, 2);
    backgroundGenerator.isDistant = false;
    var backgroundLayer1 =
        new BackgroundRenderer(backgroundGenerator.createLevel(), 320, 240, 1);

    _title = new Sprite(_resources.images['title'], point: new Point(0, 120),
        fixed: true);
    _logo = new Sprite(_resources.images['logo'], fixed: true);
    _font.spriteStrings.add(
        new SpriteString('Press S to Start', new Point(96, 120)));
    _logoY = 20;

    _drawableManager.drawables.add(backgroundLayer0);
    _drawableManager.drawables.add(backgroundLayer1);
    _drawableManager.drawables.add(_title);
    _drawableManager.drawables.add(_logo);
    _drawableManager.drawables.add(_font);

    _bounce = 0;

    //PlayTitleMusic();
  }

  void exit() {
    //StopMusic();
  }

  void update(num delta) {
    _bounce += delta * 2;
    _logoY = 20 + sin(_bounce) * 10;
    _logo.point = new Point(0, _logoY);

    _camera.point += new Point(delta * 25, 0);

    _drawableManager.update(delta);
  }
}