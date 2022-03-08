import 'package:marvel/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> findCharacters({
    required int limit,
    required int offset,
    String? filter,
  });
}
