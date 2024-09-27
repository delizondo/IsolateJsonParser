library;

import 'package:build/build.dart';
import 'package:isolate_json_parser_generator/src/isolate_json_parser_generator.dart';

Builder metadataBuilder(BuilderOptions options) => IsolateJsonParserGenerator();

PostProcessBuilder temporaryFileCleanup(BuilderOptions options) =>
    FileDeletingBuilder(const ['.exports'],
        isEnabled: options.config['enabled'] as bool? ?? false);

Builder exportsBuilder(BuilderOptions options) => ExportsBuilderGenerator();
