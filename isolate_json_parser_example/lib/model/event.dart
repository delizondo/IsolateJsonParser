import 'package:collection/collection.dart';
import 'package:isolate_json_parser/isolate_json_parser.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';
import 'geometry.dart';
import 'source.dart';

part 'event.g.dart';

@IsolateJsonParser()
@JsonSerializable()
class Event {
  final String? id;
  final String? title;
  final String? description;
  final String? link;
  final List<Category>? categories;
  final List<Source>? sources;
  final List<Geometry>? geometries;

  const Event({
    this.id,
    this.title,
    this.description,
    this.link,
    this.categories,
    this.sources,
    this.geometries,
  });

  @override
  String toString() {

    


    return 'Event(id: $id, title: $title, description: $description, link: $link, categories: $categories, sources: $sources, geometries: $geometries)';
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Event) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      link.hashCode ^
      categories.hashCode ^
      sources.hashCode ^
      geometries.hashCode;
}
