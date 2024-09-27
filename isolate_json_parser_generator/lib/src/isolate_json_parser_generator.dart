import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:isolate_json_parser/isolate_json_parser.dart';

import 'package:source_gen/source_gen.dart';

class IsolateJsonParserGenerator implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final lib = LibraryReader(await buildStep.inputLibrary);
    const exportAnnotation = TypeChecker.fromRuntime(IsolateJsonParser);
    final annotated = [
      for (var member in lib.annotatedWith(exportAnnotation))
        member.element.name,
    ];
    if (annotated.isNotEmpty) {
      buildStep.writeAsString(
          buildStep.inputId.changeExtension('.exports'), annotated.join(','));
    }
  }

  @override
  final buildExtensions = const {
    '.dart': ['.exports']
  };
}

class ExportsBuilderGenerator implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['isolate_json_parser.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final exports = buildStep.findAssets(Glob('**/*.exports'));

    final content = [
      await for (var exportLibrary in exports)
        'import \'${exportLibrary.changeExtension('.dart').uri}\'; '
    ];
    content.join('\n');
    content.add("import 'package:flutter/foundation.dart';");

    final isolateJsonParser = _createIsolateJsonParserClass();
    content.join('\n');
    final abstractJsonParser = await _createAbstractJsonParser(buildStep);

    final emitter = DartEmitter();

    content.join('\n');
    content.add(DartFormatter().format('${isolateJsonParser.accept(emitter)}'));
    content.join('\n');
    content
        .add(DartFormatter().format('${abstractJsonParser.accept(emitter)}'));

    buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/isolate_json_parser.dart'),
        content.join('\n'));
  }

  Class _createIsolateJsonParserClass() {
    return Class((b) => b
      ..name = 'IsolateJsonParser'
      ..constructors.add(Constructor((c) => c..name = "_privateConstructor"))
      ..methods.add(Method((m1) => m1
        ..static = true
        ..returns = const Reference("IsolateJsonParser")
        ..type = MethodType.getter
        ..name = "instance"
        ..body = const Code("return IsolateJsonParser._privateConstructor();")))
      ..methods.add(Method((m2) => m2
        ..returns = const Reference("Future<List<T>> ")
        ..name = "parseJsonListBackground<T>"
        ..modifier = MethodModifier.async
        ..requiredParameters.add(Parameter((p1) => p1
          ..name = "jsonList"
          ..type = const Reference("List")))
        ..body = const Code("return compute(_parseList, jsonList);")))
      ..methods.add(Method((m3) => m3
        ..returns = const Reference("List<T>")
        ..name = "_parseList<T>"
        ..requiredParameters.add(Parameter((p1) => p1
          ..name = "jsonList"
          ..type = const Reference("List")))
        ..body = const Code(
            "return jsonList.map((json) => AbstractJsonParser.fromJson<T>(json)).toList();"))));
  }

  Future<Class> _createAbstractJsonParser(BuildStep buildStep) async {
    final exports = buildStep.findAssets(Glob('**/*.exports'));
    final methodContent = StringBuffer();

    methodContent.write("switch (T) {");
    await for (var exportLibrary in exports) {
      methodContent.write(
          "case ${await buildStep.readAsString(exportLibrary)}: return ${await buildStep.readAsString(exportLibrary)}.fromJson(json) as T;");
    }
    methodContent.write("default:throw UnimplementedError();  }");

    return Class((b) => b
      ..name = "AbstractJsonParser"
      ..methods.add(Method((m1) {
        m1.static = true;
        m1.returns = const Reference("T");
        m1.name = "fromJson<T>";
        m1.requiredParameters.add(Parameter((p1) => p1
          ..name = "json"
          ..type = const Reference("Map<String, dynamic>")));
        m1.body = Code(methodContent.toString());
      })));
  }
}
