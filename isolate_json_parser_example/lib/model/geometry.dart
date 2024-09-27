import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geometry.g.dart';

@JsonSerializable()
class Geometry {
  final String? date;
  final String? type;
  final List<double>? coordinates;

  const Geometry({this.date, this.type, this.coordinates});

  @override
  String toString() {
    return 'Geometry(date: $date, type: $type, coordinates: $coordinates)';
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return _$GeometryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GeometryToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Geometry) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => date.hashCode ^ type.hashCode ^ coordinates.hashCode;
}
