part of infinite_mario_bros;

class TitleState implements GameState {
  DrawableManager _drawableManager;
  Camera _camera;
  num _logoY;
  num _bounce;
  Background _background;
  Sprite _title;
  Sprite _logo;
  final SpriteFont _font = createRedFont();

  void checkForChange(GameStateContext context) {
    if (keyboard.isKeyDown(KeyCode.S)) {
      globalMapState = new MapState();
      context.changeState(globalMapState);
    }
  }

  void draw(CanvasRenderingContext2D context) {
    _drawableManager.draw(context, _camera);
  }

  void enter() {
    _drawableManager = new DrawableManager();
    _camera = new Camera();

    _background = new Background.overground(2048, 8);

    _title = new Sprite(resources.images['title'], point: new Point(0, 120),
        fixed: true);
    _logo = new Sprite(resources.images['logo'], fixed: true);
    _font.spriteStrings.add(
        new SpriteString('Press S to Start', new Point(96, 120)));
    _logoY = 20;

    _drawableManager.drawables.add(_background);
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