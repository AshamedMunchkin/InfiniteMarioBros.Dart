library infinite_mario_bros;

import 'dart:html';
import 'dart:math';
import 'package:enjine/enjine.dart';
import 'package:meta/meta.dart';

part 'background.dart';
part 'background_generator.dart';
part 'background_renderer.dart';
part 'mario.dart';
part 'improved_noise.dart';
part 'level.dart';
part 'level_type.dart';
part 'loading_state.dart';
part 'map_state.dart';
part 'map_tile.dart';
part 'sprite_cuts.dart';
part 'tile.dart';
part 'title_state.dart';

final Resources resources = new Resources();
final Keyboard keyboard = new Keyboard();
MapState globalMapState;

void main() {
  new Application('#canvas', new LoadingState(), 320, 240);
}

List<SpriteString> createFontShadowSpriteStrings(SpriteFont spriteFont) {
  var result = new List<SpriteString>();
  spriteFont.spriteStrings.forEach((spriteString) =>
      result.add(new SpriteString(spriteString.string,
          spriteString.point + new Point(1, 1))));

  return result;
}