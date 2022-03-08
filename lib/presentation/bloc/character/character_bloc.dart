import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel/domain/entities/character.dart';
import 'package:marvel/domain/repository/character_repository.dart';

part 'event/character_event.dart';

part 'event/character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc({
    required CharacterRepository characterRepository,
  })  : _characterRepository = characterRepository,
        super(const ContentLoading()) {
    on<SearchCharacters>(_onSearchCharacters);
    on<TextSearchChanged>(_onTextSearchChanged);
    add(const SearchCharacters());
  }

  final CharacterRepository _characterRepository;
  final int limit = 20;

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    await _searchCharacters(event, emit);
  }

  Future<void> _onTextSearchChanged(
    TextSearchChanged event,
    Emitter<CharacterState> emit,
  ) async {
    await _searchCharacters(event, emit, filter: event.text);
  }

  Future<void> _searchCharacters(
    CharacterEvent event,
    Emitter<CharacterState> emit, {
    String? filter,
  }) async {
    try {
      if (filter != null || state is! CharactersLoaded) {
        final characters = await _searchOnRepository(
          offset: 0,
          filter: filter,
        );

        if (characters.isEmpty) {
          emit(NoContent(
            message: 'Nenhum personagem encontrado',
            filter: filter,
          ));
        } else {
          emit(CharactersLoaded(
            characters: characters,
            hasReachedMax: characters.length < limit,
            filter: filter,
          ));
        }
        return;
      }

      if (!_hasReachedMax(state) && state is CharactersLoaded) {
        final stateLoaded = state as CharactersLoaded;
        final characters = await _searchOnRepository(
          offset: stateLoaded.characters.length,
          filter: stateLoaded.filter,
        );

        emit(CharactersLoaded(
          characters: stateLoaded.characters + characters,
          hasReachedMax: characters.isEmpty || characters.length < limit,
          filter: stateLoaded.filter,
        ));
      }
    } catch (_) {
      emit(const ErrorContent(message: 'Erro ao buscar os personagens'));
    }
  }

  Future<List<Character>> _searchOnRepository({
    required int offset,
    String? filter,
  }) async {
    return await _characterRepository.findCharacters(
      limit: limit,
      offset: offset,
      filter: filter,
    );
  }

  bool _hasReachedMax(CharacterState state) =>
      state is CharactersLoaded && state.hasReachedMax;
}
