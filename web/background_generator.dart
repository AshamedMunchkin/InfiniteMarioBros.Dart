part of infinite_mario_bros;

class BackgroundGenerator {
  int levelWidth;
  int levelHeight;
  bool isDistant;
  LevelType levelType;

  BackgroundGenerator(int this.levelWidth, int this.levelHeight,
      bool this.isDistant, LevelType this.levelType);

  Level createLevel() {
    var level = new Level(levelWidth, levelHeight);
    var random = new Random();

    switch (levelType) {
      case LevelType.OVERGROUND:
        var range = isDistant ? 4 : 6;
        var offset = isDistant ? 2 : 1;
        var height = random.nextInt(range) + offset;
        for (var x = 0; x < levelWidth; x++) {
          var oldHeight = height;
          while (oldHeight == height) {
            height = random.nextInt(range) + offset;
          }
          for (var y = 0; y < levelHeight; y++) {
            var height0 = oldHeight < height ? oldHeight : height;
            var height1 = oldHeight < height ? height : oldHeight;
            if (y < height0) {
              if (isDistant) {
                level.map[x][y] = 4 + (y < 2 ? y : 2) * 8;
              } else {
                level.map[x][y] = 5;
              }
            } else if (y == height0) {
              level.map[x][y] =
                  (height0 == height ? 0 : 1) + (isDistant ? 2 : 0);
            } else if (y == height1) {
              level.map[x][y] =
                  (height0 == height ? 0 : 1) + (isDistant ? 2 : 0) + 16;
            } else {
              level.map[x][y] = (isDistant ? 2 : 0) +
                  ((y > height1) != (height0 == oldHeight) ? 1 : 0) + 8;
            }
          }
        }
        break;
      case LevelType.UNDERGROUND:
        if (isDistant) {
          var tt = 0;
          for (var x = 0; x < levelWidth; x++) {
            if (random.nextDouble() < 0.75) tt = (tt == 1 ? 0 : 1);
            for (var y = 0; y < levelHeight; y++) {
              var t = tt;
              var yy = y - 2;
              if (yy < 0 || y > 4) {
                yy = 2;
                t = 0;
              }
              level.map[x][y] = 4 + t + (3 + yy) * 8;
            }
          }
        } else {
          for (var x = 0; x < levelWidth; x++) {
            for (var y = 0; y < levelHeight; y++) {
              var t = x % 2;
              var yy = y - 1;
              if (yy < 0 || yy > 7) {
                yy = 7;
                t = 0;
              }
              if (t == 0 && yy > 1 && yy < 5) {
                t = -1;
                yy = 0;
              }
              level.map[x][y] = (6 + t + yy * 8);
            }
          }
        }
        break;
      case LevelType.CASTLE:
        if (isDistant) {
          for (var x = 0; x < levelWidth; x++) {
            for (var y = 0; y < levelHeight; y++) {
              var t = x % 2;
              var yy = y - 1;
              if (yy > 2 && yy < 5) {
                yy = 2;
              } else if (yy >= 5) {
                yy -= 2;
              }
              if (yy < 0) {
                t = 0;
                yy = 5;
              } else if (yy > 4) {
                t = 1;
                yy = 5;
              } else if (t < 1 && yy == 3) {
                t = 0;
                yy = 3;
              } else if (t < 1 && yy > 0 && yy < 3) {
                t = 0;
                yy = 2;
              }
              level.map[x][y] = (1 + t + (yy + 4) * 8);
            }
          }
        } else {
          for (var x = 0; x < levelWidth; x++) {
            for (var y = 0; y < levelHeight; y++) {
              var t = x % 3;
              var yy = y - 1;
              if (yy > 2 && yy < 5) {
                yy = 2;
              } else if (yy >= 5) {
                yy -= 2;
              }
              if (yy < 0) {
                t = 1;
                yy = 5;
              } else if (yy > 4) {
                t = 2;
                yy = 5;
              } else if (t < 2 && yy == 4) {
                t = 2;
                yy = 4;
              } else if (t < 2 && yy > 0 && yy < 4) {
                t = 4;
                yy = -3;
              }
              level.map[x][y] = (1 + t + (yy + 3) * 8);
            }
          }
        }
        break;
    }
    return level;
  }
}