part of infinite_mario_bros;

class MapTile {
  final _value;
  const MapTile._internal(this._value);
  toString() => 'MapTile.$_value';

  static const GRASS = const MapTile._internal('GRASS');
  static const WATER = const MapTile._internal('WATER');
  static const LEVEL = const MapTile._internal('LEVEL');
  static const ROAD = const MapTile._internal('ROAD');
  static const DECORATION = const MapTile._internal('DECORATION');
}