library character;

import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  const Character({
    required this.id,
    required this.name,
    required this.avatar,
    this.description,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  final int id;
  final String name;
  final String? description;

  @JsonKey(name: 'thumbnail')
  final Avatar avatar;
}

@JsonSerializable()
class Avatar {
  const Avatar({
    required this.path,
    required this.extension,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarToJson(this);

  final String path;
  final String extension;

  String get url {
    return '$path.$extension';
  }
}
