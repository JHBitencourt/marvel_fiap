import 'package:marvel/domain/entities/character.dart';

abstract class FindCharacters {
  Future<List<Character>> findCharacters({
    required int limit,
    required int offset,
    String? filter,
  });
}
