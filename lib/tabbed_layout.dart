import 'dart:collection';

import 'package:editor_widgets/tabbed_document.dart';
import 'package:editor_widgets/tabbed_layout_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tab layout widget
class TabbedLayout extends StatefulWidget {

  final void Function(TabbedDocument? document)? onSelectedDocument;

  /// default constructor
  const TabbedLayout({super.key, this.onSelectedDocument});

  @override
  State<StatefulWidget> createState() {
    return TabbedLayoutState();
  }
}

/// [TabbedLayout] state implementation
class TabbedLayoutState extends State<TabbedLayout> {
  late TabbedLayoutContainer _container;
  late ScrollController _tabScrollController;
  GlobalKey _tabScrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _container = TabbedLayoutContainer();
    _container.onRefresh = _refreshEvent;
    _container.onSelectedDocument = _selectedDocumentEvent;

    _tabScrollController = ScrollController();
  }

  @override
  void dispose() {
    _container.onRefresh = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    if (_container.activeDocument != null &&
        _container.activeDocument!.widgetBuilder != null) {
      _container.activeDocument!.lastBuiltWidget = _container.activeDocument!.widgetBuilder!(context);
      content = Container(
          key: ObjectKey(_container.activeDocument),
          child: _container.activeDocument!.lastBuiltWidget);
    }

    return Shortcuts(
      shortcuts: {
        if (defaultTargetPlatform == TargetPlatform.macOS)
          SingleActivator(LogicalKeyboardKey.keyW, meta: true): CloseTabIntent()
        else
          SingleActivator(LogicalKeyboardKey.keyW, control: true): CloseTabIntent(),
        SingleActivator(LogicalKeyboardKey.tab, control: true): NextDocumentIntent(),
        SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true): PriorDocumentIntent(),
      },
      child: Actions(
        actions: {
          CloseTabIntent: CallbackAction<CloseTabIntent>(onInvoke: (CloseTabIntent intent) {
            if (_container.activeDocument != null) {
              _container.removeDocument(_container.activeDocument!);
            }
          }),
          NextDocumentIntent: CallbackAction<NextDocumentIntent>(onInvoke: (intent) {
            _container.nextDocument();
          },),
          PriorDocumentIntent: CallbackAction<PriorDocumentIntent>(onInvoke: (intent) {
            _container.priorDocument();
          },),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    key: _tabScrollKey,
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    children: _container.documents
                        .map(
                          (element) => Container(
                            key: element.key,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: element == _container.activeDocument
                                            ? Colors.grey.shade400
                                            : Colors.transparent,
                                        width: 4))),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  _container.activeDocument = element;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FittedBox(
                                          child: element.icon ?? const FlutterLogo(),
                                        ),
                                      ),
                                      Text(element.name),
                                      InkWell(
                                        onTap: () async {
                                          if (element.onSave != null) {
                                            await element.onSave!(element.lastBuiltWidget);
                                          }
                                          _container.removeDocument(element);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Icon(
                                            Icons.close,
                                            size: 13,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Expanded(child: content)
            ],
          ),
        ),
      ),
    );

  }

  /// get [TabbedLayoutContainer] container
  TabbedLayoutContainer get container => _container;

  void _refreshEvent(UnmodifiableListView<TabbedDocument> documents) {
    setState(() {});
  }

  void _selectedDocumentEvent(TabbedDocument? document) {

    if (widget.onSelectedDocument != null) {
      widget.onSelectedDocument!(document);
    }

    if (document == null) {
      return;
    }

    if (document.key.currentContext != null) {
      RenderBox childRenderBox = document.key.currentContext!.findRenderObject() as RenderBox;
      RenderBox parentRenderBox = _tabScrollKey.currentContext!.findRenderObject() as RenderBox;
      Offset position = childRenderBox.localToGlobal(Offset.zero, ancestor: parentRenderBox);
      print('selected renderbox: ${position}');
      //_tabScrollController.jumpTo(rb.paintBounds.left);
    } else {
      print('Trying to calculate tab position but don\'t exists yet.');
    }
    setState(() {});
  }
}

class CloseTabIntent extends Intent {
  const CloseTabIntent();
}

class NextDocumentIntent extends Intent {
  const NextDocumentIntent();
}

class PriorDocumentIntent extends Intent {
  const PriorDocumentIntent();
}
