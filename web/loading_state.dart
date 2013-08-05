part of infinite_mario_bros;

class LoadingState implements GameState {
  Resources _resources = new Resources();
  bool imagesLoaded = false;
  num screenColor = 0;
  int colorDirection = 1;

  @override
  void checkForChange(GameStateContext context) {
    if (imagesLoaded) context.changeState(new TitleState());
  }

  @override
  void draw(CanvasRenderingContext2D context) {
    if (!imagesLoaded) {
      var color = screenColor.toInt();
      context.fillStyle = 'rgb($color, $color, $color)';
    } else {
      context.fillStyle = 'rgb(0, 0, 0)';
    }
    context.fillRect(0, 0, 640, 480);
  }

  @override
  void enter() {
    _resources
        ..images['background'] = new ImageElement(src: 'images/bgsheet.png')
        ..images['endScene'] = new ImageElement(src: 'images/endscene.gif')
        ..images['enemies'] = new ImageElement(src: 'images/enemysheet.png')
        ..images['fireMario'] =
            new ImageElement(src: 'images/firemariosheet.png')
        ..images['font'] = new ImageElement(src: 'images/font.gif')
        ..images['gameOverGhost'] =
            new ImageElement(src: 'images/gameovergost.gif')
        ..images['items'] = new ImageElement(src: 'images/itemsheet.png')
        ..images['logo'] = new ImageElement(src: 'images/logo.gif')
        ..images['map'] = new ImageElement(src: 'images/mapsheet.png')
        ..images['mario'] = new ImageElement(src: 'images/mariosheet.png')
        ..images['particles'] =
            new ImageElement(src: 'images/particlesheet.png')
        ..images['racoonMario'] =
            new ImageElement(src: 'images/racoonmariosheet.png')
        ..images['smallMario'] =
            new ImageElement(src: 'images/smallmariosheet.png')
        ..images['title'] = new ImageElement(src: 'images/title.gif')
        ..images['worldMap'] = new ImageElement(src: 'images/worldmap.png');

    var testAudio = new AudioElement();

    if (testAudio.canPlayType('audio/mp3') == '') {
      _resources.audioManager
          ..add('1up', 'sounds/1-up.mp3')
          ..add('breakblock', 'sounds/breakblock.mp3')
          ..add('bump', 'sounds/bump.mp3')
          ..add('cannon', 'sounds/cannon.mp3')
          ..add('coin', 'sounds/coin.mp3')
          ..add('death', 'sounds/death/death.mp3')
          ..add('exit', 'sounds/exit.mp3')
          ..add('fireball', 'sounds/fireball.mp3')
          ..add('jump', 'sounds/jump.mp3')
          ..add('kick', 'sounds/kick.mp3')
          ..add('pipe', 'sounds/pipe.mp3')
          ..add('powerdown', 'sounds/powerdown.mp3')
          ..add('powerup', 'sounds/powerup.mp3')
          ..add('sprout', 'sounds/sprout.mp3')
          ..add('stagestart', 'sounds/stagestart.mp3')
          ..add('stomp', 'sounds/stomp.mp3');
    } else {
      _resources.audioManager
          ..add('1up', 'sounds/1-up.wav')
          ..add('breakblock', 'sounds/breakblock.wav')
          ..add('bump', 'sounds/breakblock.wav')
          ..add('cannon', 'sounds/cannon.wav')
          ..add('coin', 'sounds/coin.wav')
          ..add('death', 'sounds/death.wav')
          ..add('exit', 'sounds/exit.wav')
          ..add('fireball', 'sounds/fireball.wav')
          ..add('jump', 'sounds/jumps.wav')
          ..add('kick', 'sounds/kick.wav')
          ..add('message', 'sounds/message.wav')
          ..add('pipe', 'sounds/pipe.wav')
          ..add('powerdown', 'sounds/powerdown.wav')
          ..add('powerup', 'sounds/powerup.wav')
          ..add('sprout', 'sounds/sprout.wav')
          ..add('stagestart', 'sounds/stagestart.wav')
          ..add('stomp', 'sounds/stomp.wav');
    }

    LoadBehaviors();
  }

  @override
  void exit() {}

  @override
  void update(num delta) {
    if (!imagesLoaded) {
      imagesLoaded = _resources.images.values.every((image) => image.complete);
    }

    screenColor += colorDirection * 255 * delta;
    if (screenColor > 255) {
      screenColor = 255;
      colorDirection = -1;
    }
    if (screenColor < 0) {
      screenColor = 0;
      colorDirection = 1;
    }
  }
}