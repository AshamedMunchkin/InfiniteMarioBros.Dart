library infinite_mario_bros;

import 'dart:html';
import 'dart:math';
import 'package:enjine/enjine.dart';
import 'package:meta/meta.dart';

part 'background_generator.dart';
part 'background_renderer.dart';
part 'level.dart';
part 'level_type.dart';
part 'loading_state.dart';
part 'sprite_cuts.dart';
part 'tile.dart';
part 'title_state.dart';

final Resources resources = new Resources();

void main() {
  new Application('#canvas', new LoadingState(), 320, 240);
}