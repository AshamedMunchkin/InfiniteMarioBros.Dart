part of infinite_mario_bros;

class Mario /*extends NotchSprite(null)*/ {
  static bool _large = false;
  static bool get large => _large;
  static bool _fire = false;
  static bool get fire => _fire;
  static int _coins = 0;
  static int get coins => _coins;
  static int _lives = 3;
  static int get lives => _lives;
  static String levelString;

  static const num _GROUND_INTERTIA = 0.89;
  static const num _AIR_INERTIA = 0.89;

  num _runTime;
  bool _wasOnGround = false;
  bool _onGround = false;
  bool _mayJump = false;
  bool _ducking = false;
  bool _sliding = false;
  int _jumpTime = 0;
  Vector _jumpSpeed;
  bool _canShoot = false;

  int _width = 4;
  int _height = 24;

  //LevelState _world;
  int _facing;
  int _powerUpTime = 0;

  Point _deathPosition;

  int _deathTime = 0;
  int _winTime = 0;
  int _invulnerableTime = 0;

  //NotchSprite _carried;

}