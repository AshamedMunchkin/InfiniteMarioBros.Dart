part of infinite_mario_bros;

Map<int, Point> generateCharacterArray(y) {
  var characterArray = new Map<int, Point>();
  for (var character = 32; character < 127; character++) {
    characterArray[character] = new Point((character - 32) * 8, y);
  }
  return characterArray;
}

SpriteFont createBlackFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(0), fixed: true);

SpriteFont createRedFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(8), fixed: true);

SpriteFont createGreenFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(16), fixed: true);

SpriteFont createBlueFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(24), fixed: true);

SpriteFont createYellowFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(32), fixed: true);

SpriteFont createPinkFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(40), fixed: true);

SpriteFont createCyanFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(48), fixed: true);

SpriteFont createWhiteFont() => new SpriteFont(resources.images['font'], 8, 8,
    generateCharacterArray(56), fixed: true);

List<List<Rect>> backgroundSheet =
    new List<List<Rect>>.generate(resources.images['background'].width ~/ 32,
        (x) =>
            new List<Rect>.generate(resources.images['background'].height ~/ 32,
                (y) => new Rect(x * 32, y * 32, 32, 32)));

List<List<Rect>> levelSheet =
    new List<List<Rect>>.generate(resources.images['background'].width ~/ 16,
        (x) =>
            new List<Rect>.generate(resources.images['background'].height ~/ 16,
                (y) => new Rect(x * 16, y * 16, 16, 16)));