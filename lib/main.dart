import 'package:flutter/material.dart';
import 'package:life_counter/life_event.dart';

import 'add_life_event_page.dart';
import 'objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LifeCounterPage(),
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});
  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  Store? store;
  Box<LifeEvent>? lifeEventBox;
  List<LifeEvent> lifeEvents = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    store = await openStore();
    lifeEventBox = store?.box<LifeEvent>();
    fetchLifeEvents();
  }

  void fetchLifeEvents() {
    lifeEvents = lifeEventBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('life Counter'),
      ),
      body: ListView.builder(
        itemCount: lifeEvents.length,
        itemBuilder: (context, index) {
          final lifeEvent = lifeEvents[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  lifeEvent.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )),
                Text(
                  lifeEvent.count.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      lifeEvent.count++;
                      lifeEventBox?.put(lifeEvent);
                      fetchLifeEvents();
                    });
                  },
                  icon: const Icon(Icons.plus_one),
                ),
                IconButton(
                  onPressed: () {
                    lifeEventBox?.remove(lifeEvent.id);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newLifeEvent = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AddLifeEventPage();
              },
            ),
          );

          if (newLifeEvent != null) {
            lifeEventBox?.put(newLifeEvent);
            fetchLifeEvents();
          }
        },
      ),
    );
  }
}
