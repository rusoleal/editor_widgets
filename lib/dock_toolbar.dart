import 'package:editor_widgets/dock_layout.dart';
import 'package:editor_widgets/dock_side.dart';

/// Toolbar definition used in [DockLayout]
///
/// Horizontal toolbar layout
/// [[[part1 icons   .............   part2 icons]]]
///
/// Vertical toolbar layout
/// [[[
/// part1 icons
///
/// .
/// .
/// .
/// .
///
/// part2 icons
/// ]]]
///
class DockToolbar {
  /// list of sides represented in part1 of toolbar.
  final List<DockSide> part1;

  /// list of sides represented in part2 of toolbar.
  final List<DockSide> part2;

  /// toolbar size.
  final double toolbarSize;

  /// default constructor.
  const DockToolbar(
      {this.part1 = const [], this.part2 = const [], this.toolbarSize = 40});
}
