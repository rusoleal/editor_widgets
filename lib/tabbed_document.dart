import 'package:editor_widgets/tabbed_layout.dart';
import 'package:flutter/material.dart';

/// TabbedDocument represent a document in [TabbedLayout] widget
class TabbedDocument {
  /// document name
  String name;

  /// optional document icon
  Widget? icon;

  /// function to construct widget
  Widget Function(BuildContext context)? widgetBuilder;

  /// default constructor
  TabbedDocument({required this.name, this.icon, this.widgetBuilder});
}
