// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      link: json['link'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
          .toList(),
      geometries: (json['geometries'] as List<dynamic>?)
          ?.map((e) => Geometry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'categories': instance.categories,
      'sources': instance.sources,
      'geometries': instance.geometries,
    };
