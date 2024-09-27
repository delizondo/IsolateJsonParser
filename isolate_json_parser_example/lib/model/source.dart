import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

@JsonSerializable()
class Source {
  final String? id;
  final String? url;

  const Source({this.id, this.url});

  @override
  String toString() => 'Source(id: $id, url: $url)';

  factory Source.fromJson(Map<String, dynamic> json) {
    return _$SourceFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SourceToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Source) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode;
}
