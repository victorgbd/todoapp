import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todoapp/views/loading_notifier.dart';
import 'package:todoapp/views/new_todo_view.dart';
import 'package:todoapp/views/todo_notifier_provider.dart';

import 'data/model/todo_model.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todo');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO',
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/home': (context) => const MyHomePage(),
          '/new': (context) => const NewTodo(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: (() {
                Navigator.pushNamed(context, '/home');
              }),
              child: const Text("dale aqui"),
            ),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(todoNotifierProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  final DateFormat formatterdate = DateFormat('MM/dd/yyyy');
  final DateFormat formattertime = DateFormat('hh:mm:ss');

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(loadingNotifierProvider, (_, isLoading) {
      isLoading ? context.loaderOverlay.show() : context.loaderOverlay.hide();
    });

    final todos = ref.watch(todoNotifierProvider) ?? [];
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new');
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              var complete = todos.elementAt(index).isComplete == 'true';
              var date = DateTime.parse(todos.elementAt(index).date);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            width: screenSize.width * 0.62,
                            child: Text(
                              todos.elementAt(index).content,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20.0),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                              width: screenSize.width * 0.62,
                              child: Text(
                                'Creado: ${formatterdate.format(date)} a las ${formattertime.format(date)}',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.0),
                              )),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(todoNotifierProvider.notifier)
                            .delete(todos.elementAt(index));
                      },
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: complete ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        if (complete) {
                          complete = false;
                        } else {
                          complete = true;
                        }

                        ref
                            .read(todoNotifierProvider.notifier)
                            .update(todos.elementAt(index), complete);
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (() {
        ref.read(todoNotifierProvider.notifier).load();
      })),
    );
  }
}
