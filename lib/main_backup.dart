import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:warframetools/lists/requiem.dart';

void main() {
  runApp(const MyApp());
}

final pb = PocketBase('http://127.0.0.1:8090');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  RecordModel texto = RecordModel({});

  void changetext() async {
    try {
      await pb
          .collection('users')
          .authWithPassword('test@example.com', '12345678');

      final result = await pb.collection('testpost').getList();
      if (kDebugMode) {
        print(
          "THE STATE OF THE LIST OF TESTPOSTS: ${result.totalItems == 0 ? "empty" : "GOOD"}",
        );
      }
      setState(() {
        if (result.items.isNotEmpty) {
          texto = result.items.first;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    changetext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              texto.data['zbi']?.toString() ?? 'No data',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IconButton(
              onPressed: () async {
                for (final relic in requiemRelics) {
                  try {
                    await pb.collection('voidrelics').create(
                      body: {
                        'name': relic.name,
                        'type': relic.type,
                        'counter': relic.counter,
                      },
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error creating relic: $e');
                    }
                  }
                }
              },
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
          changetext();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
