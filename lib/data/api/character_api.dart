import 'package:marvel/data/api/base_api.dart';
import 'package:marvel/domain/entities/character.dart';
import 'package:marvel/domain/repository/character_repository.dart';

class CharacterApi extends BaseApi implements CharacterRepository {
  @override
  Future<List<Character>> findCharacters({
    required int limit,
    required int offset,
    String? filter,
  }) async {
    var url = '$baseUrl$charactersPath?limit=$limit&offset=$offset';

    if (filter != null && filter.isNotEmpty) {
      url += '&nameStartsWith=$filter';
    }

    final responseJson = await get(url);

    final List<dynamic> jsonResults = responseJson['data']['results'];

    final characters = <Character>[];
    if (jsonResults.isNotEmpty) {
      characters.addAll(jsonResults.map((json) => Character.fromJson(json)));
    }
    return characters;
  }
}
