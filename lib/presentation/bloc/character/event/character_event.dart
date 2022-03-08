part of '../character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

class SearchCharacters extends CharacterEvent {
  const SearchCharacters();
}

class TextSearchChanged extends CharacterEvent {
  const TextSearchChanged({required this.text});

  final String text;
}
