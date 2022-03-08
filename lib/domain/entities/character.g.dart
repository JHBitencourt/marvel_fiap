// GENERATED CODE - DO NOT MODIFY BY HAND

part of character;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: Avatar.fromJson(json['thumbnail'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.avatar,
    };

Avatar _$AvatarFromJson(Map<String, dynamic> json) => Avatar(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'path': instance.path,
      'extension': instance.extension,
    };
