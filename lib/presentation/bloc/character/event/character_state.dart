part of '../character_bloc.dart';

const undefined = Object();

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharactersLoaded extends CharacterState {
  const CharactersLoaded({
    required this.characters,
    required this.hasReachedMax,
    this.filter,
  });

  CharactersLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    Object? filter = undefined,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filter: filter == undefined ? this.filter : filter as String?,
    );
  }

  final List<Character> characters;
  final String? filter;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [characters, filter, hasReachedMax];
}

class ContentLoading extends CharacterState {
  const ContentLoading();
}

class NoContent extends CharacterState {
  const NoContent({this.message = '', this.filter});

  final String message;
  final String? filter;

  @override
  List<Object?> get props => [message, filter];
}

class ErrorContent extends CharacterState {
  const ErrorContent({required this.message});

  final String message;
}
