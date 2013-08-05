part of infinite_mario_bros;

class LevelType {
  final _value;
  const LevelType._internal(this._value);
  toString() => 'LevelType.$_value';

  static const OVERGROUND = const LevelType._internal('OVERGROUND');
  static const UNDERGROUND = const LevelType._internal('UNDERGROUND');
  static const CASTLE = const LevelType._internal('CASTLE');
}