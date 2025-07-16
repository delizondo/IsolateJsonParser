import 'package:isolate_json_parser_example/model/event.dart'; 
import 'package:flutter/foundation.dart';
import 'dart:async';
class IsolateJsonParserBuilder {
  static Future<List<T>> parseJsonListBackground<T>(List jsonList) async {
    return compute(_parseList, jsonList);
  }

  static List<T> _parseList<T>(List jsonList) {
    return jsonList
        .map((json) => AbstractJsonParser.fromJson<T>(json))
        .toList();
  }

  static Future<T> parseJsonBackground<T>(Map<String, dynamic> json) async {
    return compute(_parseObject, json);
  }

  static T _parseObject<T>(Map<String, dynamic> json) {
    return AbstractJsonParser.fromJson<T>(json);
  }
}

class AbstractJsonParser {
  static T fromJson<T>(Map<String, dynamic> json) {
    if (T == Event || T == FutureOr<Event>) {
      return Event.fromJson(json) as T;
    } else {
      throw UnimplementedError("$T not implemented");
    }
  }
}
