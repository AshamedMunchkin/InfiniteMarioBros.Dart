part of infinite_mario_bros;

class Tile {
  final bool blockUpper;
  final bool blockAll;
  final bool blockLower;
  final bool special;
  final bool bumpable;
  final bool breakable;
  final bool pickUpable;
  final bool animated;

  Tile({bool this.blockUpper: false, bool this.blockAll:  false,
        bool this.blockLower: false, bool this.special:   false,
        bool this.bumpable:   false, bool this.breakable: false,
        bool this.pickUpable: false, bool this.animated:  false});
}

List<Tile> tiles = [];

void LoadBehaviors() {
  tiles.length = 256;
  tiles[1] = new Tile(blockLower: true, bumpable: true);
  tiles[2] = new Tile(blockLower: true, special: true, bumpable: true);
  for (var i = 4; i <= 7; i++) {
    tiles[i] = new Tile(blockAll: true, animated: true);
  }
  for (var i = 8; i <= 12; i++) tiles[i] = new Tile(blockAll: true);
  tiles[14] = new Tile(blockAll: true, special: true, animated: true);
  tiles[16] = new Tile(blockAll: true, breakable: true, animated: true);
  tiles[17] = new Tile(blockAll: true, bumpable: true, animated: true);
  tiles[18] =
      new Tile(blockAll: true, special: true, bumpable: true, animated: true);
  tiles[19] = new Tile(blockAll: true, breakable: true, animated: true);
  for (var i = 20; i <= 21; i++) {
    tiles[i] = new Tile(blockAll: true, bumpable: true, animated: true);
  }
  tiles[22] =
      new Tile(blockAll: true, special: true, bumpable: true, animated: true);
  tiles[23] = new Tile(blockAll: true, bumpable: true, animated: true);
  tiles[24] = new Tile(blockAll: true);
  for (var i = 26; i <= 28; i++) tiles[i] = new Tile(blockAll: true);
  tiles[30] = new Tile(blockAll: true);
  for (var i = 32; i <= 35; i++) {
    tiles[i] = new Tile(pickUpable: true, animated: true);
  }
  for (var i = 40; i <= 41; i++) tiles[i] = new Tile(blockAll: true);
  tiles[46] = new Tile(blockAll: true);
  for (var i = 56; i <= 57; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 128; i <= 130; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 132; i <= 134; i++) tiles[i] = new Tile(blockUpper: true);
  for (var i = 136; i <= 138; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 140; i <= 142; i++) tiles[i] = new Tile(blockAll: true);
  tiles[144] = new Tile(blockAll: true);
  tiles[146] = new Tile(blockAll: true);
  for (var i = 152; i <= 154; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 156; i <= 158; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 160; i <= 162; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 168; i <= 170; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 172; i <= 174; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 176; i <= 178; i++) tiles[i] = new Tile(blockAll: true);
  for (var i = 180; i <= 182; i++) tiles[i] = new Tile(blockUpper: true);
  for (var i = 224; i <= 226; i++) tiles[i] = new Tile(blockUpper: true);

  for (var i = 0; i < 255; i++) {
    if (tiles[i] != null) continue;
    tiles[i] = new Tile();
  }
}