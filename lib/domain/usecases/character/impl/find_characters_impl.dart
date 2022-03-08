import 'package:get_it/get_it.dart';
import 'package:marvel/domain/entities/character.dart';
import 'package:marvel/domain/repository/character_repository.dart';
import 'package:marvel/domain/usecases/character/find_characters.dart';

class FindCharactersImpl implements FindCharacters {
  final _repository = GetIt.I.get<CharacterRepository>();

  @override
  Future<List<Character>> findCharacters({
    required int limit,
    required int offset,
    String? filter,
  }) {
    return _repository.findCharacters(
        limit: limit, offset: offset, filter: filter);
  }
}
