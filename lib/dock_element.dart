
import 'package:editor_widgets/dock_side.dart';
import 'package:flutter/widgets.dart';

class DockElement {

  final String name;
  final DockSide preferredDockSide;
  final Widget widget;
  final Widget? icon;
  final bool visible;

  const DockElement({
    required this.name,
    this.preferredDockSide=DockSide.leftTop,
    required this.widget,
    this.icon,
    this.visible=false,
  });

}