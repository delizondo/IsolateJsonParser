# Isolate Json Parser

The Isolate Json Parser package provides the annotation `@IsolateJsonParser` to mark classes that can be parsed using an Isolate in Dart.

## Requirements

To use this package you need to import [json_annotation](https://pub.dev/packages/json_annotation) or have the `fromJson` method implemented in your model class

```dart
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
```

As part of the installation, add the [isolate_json_parser_generator](https://pub.dev/packages/isolate_json_parser_generator) package in your `pubspec.yaml` file under `dev_dependencies`

## Usage

Add the `@IsolateJsonParser` annotation in the class you want to include,

```dart
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

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

}
```

Run `build_runner` with the command

```
flutter packages pub run build_runner
```

This will automatically generate the `isolate_json_parser.dart` file with the required classes for the package to work.

When you execute any API call that returns a JSON, you can call the `IsolateJsonParser` singleton to run the parsing of the returning JSON in an Dart Isolate.

```dart
  Future<List<Event>> downloadAndParseJson() async {
    final response =
        await _dio.get('https://eonet.gsfc.nasa.gov/api/v2.1/events');
    if (response.statusCode == 200) {
      var data = response.data as Map<String, dynamic>;
      var jsonList = data["events"];
      return IsolateJsonParser.parseJsonListBackground<Event>(jsonList);
    } else {
      throw Exception('Failed to load json');
    }
  }

```

Please check the [example](https://github.com/delizondo/IsolateJsonParser/tree/main/isolate_json_parser_example)

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
