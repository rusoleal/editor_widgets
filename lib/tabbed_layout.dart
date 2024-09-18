
import 'dart:collection';

import 'package:editor_widgets/tabbed_document.dart';
import 'package:editor_widgets/tabbed_layout_container.dart';
import 'package:flutter/material.dart';

class TabbedLayout extends StatefulWidget {

  //final TabbedLayoutContainer container;

  const TabbedLayout({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabbedLayoutState();
  }

}

class TabbedLayoutState extends State<TabbedLayout> {

  late TabbedLayoutContainer _container;

  @override
  void initState() {
    super.initState();

    _container = TabbedLayoutContainer();
    _container.onRefresh = _refresh;
  }

  @override
  void dispose() {
    _container.onRefresh = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget content = Container();
    if (_container.activeDocument != null && _container.activeDocument!.widgetBuilder != null) {
      content = Container(
        key: ObjectKey(_container.activeDocument),
        child: _container.activeDocument!.widgetBuilder!(context)
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300))
          ),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _container.documents.map((element) => Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                    color: element==_container.activeDocument ? Colors.grey.shade400 : Colors.transparent,
                    width: 4
                  ))
                ),
                child: InkWell(
                  onTap: () {
                    _container.activeDocument = element;
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(child: element.icon??  const FlutterLogo(),),
                      ),
                      Text(element.name),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Icon(Icons.close, size: 13, color: Colors.grey.shade400,),
                      )
                    ],),
                  ),
                ),
              ),).toList(),
            ),
          ),
        ),
        Expanded(child: content)
      ],
    );

    /*return DefaultTabController(
      length: _container.documents.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            tabs: _container.documents.map((e) => Tab(icon: e.icon, text: e.name,),).toList(growable: false),
            isScrollable: true,
          ),
          Expanded(child: TabBarView(
            children: _container.documents.map((e) => e.widgetBuilder!=null?e.widgetBuilder!(context):Container(),).toList(growable: false)
          ))
        ],
      )
    );*/
  }

  TabbedLayoutContainer get container => _container;

  void _refresh(UnmodifiableListView<TabbedDocument> documents) {
    setState(() {});
  }

}
