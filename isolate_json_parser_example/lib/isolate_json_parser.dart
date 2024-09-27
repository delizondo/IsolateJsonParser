import 'package:isolate_json_parser_example/model/event.dart'; 
import 'package:flutter/foundation.dart';
class IsolateJsonParser {
  static Future<List<T>> parseJsonListBackground<T>(List jsonList) async {
    return compute(_parseList, jsonList);
  }

  static List<T> _parseList<T>(List jsonList) {
    return jsonList
        .map((json) => AbstractJsonParser.fromJson<T>(json))
        .toList();
  }
}

class AbstractJsonParser {
  static T fromJson<T>(Map<String, dynamic> json) {
    switch (T) {
      case Event:
        return Event.fromJson(json) as T;
      default:
        throw UnimplementedError();
    }
  }
}
