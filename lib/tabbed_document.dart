
import 'package:flutter/material.dart';

class TabbedDocument {

  String name;
  Widget? icon;
  Widget Function(BuildContext context)? widgetBuilder;

  TabbedDocument({required this.name, this.icon, this.widgetBuilder});
}