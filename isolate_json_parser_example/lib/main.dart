import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolate_json_parser_example/isolate_json_parser.dart';
import 'package:isolate_json_parser_example/model/event.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

//https://eonet.gsfc.nasa.gov/api/v2.1/events

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Isolate JSON Parser'),
        ),
        body: const ResultsList(),
      ),
    );
  }
}

class ResultsList extends ConsumerWidget {
  const ResultsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsData = ref.watch(searchResultsProvider);
    return searchResultsData.when(
      data: (results) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text(result.title ?? ""),
            subtitle: Text(result.description ?? ""),
          );
        },
      ),
      error: (e, st) => Text(e.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class APIClient {
  final _dio = Dio();
  Future<List<Event>> downloadAndParseJson() async {
    final response =
        await _dio.get('https://eonet.gsfc.nasa.gov/api/v2.1/events');
    if (response.statusCode == 200) {
      var data = response.data as Map<String, dynamic>;
      var jsonList = data["events"];
      return IsolateJsonParser.instance
          .parseJsonListBackground<Event>(jsonList);
    } else {
      throw Exception('Failed to load json');
    }
  }
}

final apiClientProvider = Provider<APIClient>((ref) {
  return APIClient();
});

final searchResultsProvider = FutureProvider<List<Event>>((ref) {
  return ref.watch(apiClientProvider).downloadAndParseJson();
});
