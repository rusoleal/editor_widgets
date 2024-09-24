import 'package:editor_widgets/tabbed_document.dart';
import 'package:flutter/material.dart';
import 'package:editor_widgets/dock_element.dart';
import 'package:editor_widgets/dock_layout.dart';
import 'package:editor_widgets/dock_side.dart';
import 'package:editor_widgets/dock_toolbar.dart';
import 'package:editor_widgets/tabbed_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  late DockLayout _dock;
  final GlobalKey<TabbedLayoutState> _tabbedLayoutKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _dock = DockLayout(
      topPane: false,
      leftPaneToolbar: const DockToolbar(
          part1: [DockSide.topLeft, DockSide.leftTop],
          part2: [DockSide.leftBottom, DockSide.bottomLeft]),
      rightPaneToolbar: const DockToolbar(
          part1: [DockSide.topRight, DockSide.rightTop],
          part2: [DockSide.rightBottom, DockSide.bottomRight]),
      elements: const [
        DockElement(
          id:'Explorer',
          name: 'Explorer',
          widget: Center(
            child: Text('Explorer'),
          ),
          icon: Icon(
            Icons.folder_outlined,
            color: Colors.grey,
          ),
          preferredDockSide: DockSide.leftTop,
          visible: true),
        DockElement(
          id: 'Messages',
          name: 'Messages',
          widget: Center(
            child: Text('Messages'),
          ),
          preferredDockSide: DockSide.rightTop,
          visible: true),
        DockElement(
          id: 'Info',
          name: 'Info',
          widget: Center(
            child: Text('Info'),
          ),
          preferredDockSide: DockSide.bottomLeft,
          visible: true),
      ],
      child: TabbedLayout(
        key: _tabbedLayoutKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // toolbar mockup
          Container(
            height: 50,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (_tabbedLayoutKey.currentState != null) {
                        _tabbedLayoutKey.currentState!.container
                            .addDocument(TabbedDocument(
                          name: 'name',
                          icon: const Icon(Icons.file_copy),
                          widgetBuilder: (context) {
                            return TextFormField(
                              expands: true,
                              maxLines: null,
                              minLines: null,
                            );
                          },
                        ));
                        //print(_tabbedLayoutKey.currentState!.container.documents.length);
                        setState(() {});
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Add empty document'),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: _dock),
          // status bar mockup
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text('status bar...'),
            ),
          )
        ],
      ),
    );
  }
}
