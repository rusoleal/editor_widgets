import 'package:editor_widgets/dock_side.dart';
import 'package:flutter/widgets.dart';

/// Dock element represents a dockable widget
class DockElement {

  /// unique identifier
  final String id;

  /// element name.
  final String name;

  /// preferred dock side if available.
  final DockSide preferredDockSide;

  /// widget element.
  final Widget Function(BuildContext context) widgetBuilder;

  /// widget used to represent icon in toolbar.
  final Widget? icon;

  /// initial visibility state.
  final bool visible;

  /// default constructor.
  const DockElement({
    required this.id,
    required this.name,
    this.preferredDockSide = DockSide.leftTop,
    required this.widgetBuilder,
    this.icon,
    this.visible = false,
  });
}
