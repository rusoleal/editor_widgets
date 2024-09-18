
import 'package:editor_widgets/dock_element.dart';
import 'package:editor_widgets/dock_side.dart';
import 'package:editor_widgets/dock_toolbar.dart';
import 'package:flutter/material.dart';

class DockLayout extends StatefulWidget {

  final Widget? child;
  final List<DockElement> tools;
  final bool leftPane;
  final bool topPane;
  final bool rightPane;
  final bool bottomPane;
  final DockToolbar leftPaneToolbar;
  final DockToolbar topPaneToolbar;
  final DockToolbar rightPaneToolbar;
  final DockToolbar bottomPaneToolbar;

  const DockLayout({super.key,
    this.child,
    this.tools=const [],
    this.leftPane=true,
    this.topPane=true,
    this.rightPane=true,
    this.bottomPane=true,
    this.leftPaneToolbar=const DockToolbar(),
    this.topPaneToolbar=const DockToolbar(),
    this.rightPaneToolbar=const DockToolbar(),
    this.bottomPaneToolbar=const DockToolbar()
  });

  @override
  State<StatefulWidget> createState() {
    return DockLayoutState();
  }

}

class DockLayoutState extends State<DockLayout> {

  late List<DockElement> _leftTopPaneTools;
  late List<DockElement> _leftBottomPaneTools;
  late List<DockElement> _topLeftPaneTools;
  late List<DockElement> _topRightPaneTools;
  late List<DockElement> _rightTopPaneTools;
  late List<DockElement> _rightBottomPaneTools;
  late List<DockElement> _bottomLeftPaneTools;
  late List<DockElement> _bottomRightPaneTools;

  late int _leftTopPaneToolsIndex;
  late int _leftBottomPaneToolsIndex;
  late int _topLeftPaneToolsIndex;
  late int _topRightPaneToolsIndex;
  late int _rightTopPaneToolsIndex;
  late int _rightBottomPaneToolsIndex;
  late int _bottomLeftPaneToolsIndex;
  late int _bottomRightPaneToolsIndex;

  late double _leftPaneSize;
  double? _leftTopPaneSize;
  late double _topPaneSize;
  double? _topLeftPaneSize;
  late double _rightPaneSize;
  double? _rightTopPaneSize;
  late double _bottomPaneSize;
  double? _bottomLeftPaneSize;

  double _leftTopPaneDragOpacity = 0.0;
  double _leftBottomPaneDragOpacity = 0.0;
  double _topLeftPaneDragOpacity = 0.0;
  double _topRightPaneDragOpacity = 0.0;
  double _rightTopPaneDragOpacity = 0.0;
  double _rightBottomPaneDragOpacity = 0.0;
  double _bottomLeftPaneDragOpacity = 0.0;
  double _bottomRightPaneDragOpacity = 0.0;

  static const double _minimumPaneSize = 60;
  late Map<DockElement,double> _paneOpacityButtons;
  //bool _dragging = false;
  late Offset _dragPosition;

  @override
  void initState() {
    super.initState();

    updatePanes();
  }

  void updatePanes() {

    _paneOpacityButtons = {};

    _leftTopPaneTools = [];
    _leftTopPaneToolsIndex = -1;
    _leftBottomPaneTools = [];
    _leftBottomPaneToolsIndex = -1;
    _leftPaneSize = 300;

    _topLeftPaneTools = [];
    _topLeftPaneToolsIndex = -1;
    _topRightPaneTools = [];
    _topRightPaneToolsIndex = -1;
    _topPaneSize = 300;

    _rightTopPaneTools = [];
    _rightTopPaneToolsIndex = -1;
    _rightBottomPaneTools = [];
    _rightBottomPaneToolsIndex = -1;
    _rightPaneSize = 300;

    _bottomLeftPaneTools = [];
    _bottomLeftPaneToolsIndex = -1;
    _bottomRightPaneTools = [];
    _bottomRightPaneToolsIndex = -1;
    _bottomPaneSize = 300;

    for (DockElement element in widget.tools) {
      switch (element.preferredDockSide) {
        case DockSide.leftTop:
          _leftTopPaneTools.add(element);
          if (element.visible && widget.leftPane  && _leftTopPaneToolsIndex == -1) {
            _leftTopPaneToolsIndex = _leftTopPaneTools.length-1;
          }
          break;
        case DockSide.leftBottom:
          _leftBottomPaneTools.add(element);
          if (element.visible && widget.leftPane && _leftBottomPaneToolsIndex == -1) {
            _leftBottomPaneToolsIndex = _leftBottomPaneTools.length-1;
          }
          break;
        case DockSide.topLeft:
          _topLeftPaneTools.add(element);
          if (element.visible && widget.topPane && _topLeftPaneToolsIndex == -1) {
            _topLeftPaneToolsIndex = _topLeftPaneTools.length-1;
          }
          break;
        case DockSide.topRight:
          _topRightPaneTools.add(element);
          if (element.visible && widget.topPane && _topRightPaneToolsIndex == -1) {
            _topRightPaneToolsIndex = _topRightPaneTools.length-1;
          }
          break;
        case DockSide.rightTop:
          _rightTopPaneTools.add(element);
          if (element.visible && widget.rightPane && _rightTopPaneToolsIndex == -1) {
            _rightTopPaneToolsIndex = _rightTopPaneTools.length-1;
          }
          break;
        case DockSide.rightBottom:
          _rightBottomPaneTools.add(element);
          if (element.visible && widget.rightPane && _rightBottomPaneToolsIndex == -1) {
            _rightBottomPaneToolsIndex = _rightBottomPaneTools.length-1;
          }
          break;
        case DockSide.bottomLeft:
          _bottomLeftPaneTools.add(element);
          if (element.visible && widget.bottomPane && _bottomLeftPaneToolsIndex == -1) {
            _bottomLeftPaneToolsIndex = _bottomLeftPaneTools.length-1;
          }
          break;
        case DockSide.bottomRight:
          _bottomRightPaneTools.add(element);
          if (element.visible && widget.bottomPane && _bottomRightPaneToolsIndex == -1) {
            _bottomRightPaneToolsIndex = _bottomRightPaneTools.length-1;
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        // update semi pane sizes
        if (_leftTopPaneSize == null) {

          double topSize = (_topLeftPaneToolsIndex != -1 || _topRightPaneToolsIndex != -1) ? _topPaneSize : 0;
          double bottomSize = (_bottomLeftPaneToolsIndex != -1 || _bottomRightPaneToolsIndex != -1) ? _bottomPaneSize : 0;

          _leftTopPaneSize = (constraints.maxHeight - topSize - bottomSize) / 2;
          if (_leftTopPaneSize! < 0) {
            _leftTopPaneSize = 0;
          }
          _rightTopPaneSize = _leftTopPaneSize;

          _topLeftPaneSize = (constraints.maxWidth) / 2;
          _bottomLeftPaneSize = (constraints.maxWidth) / 2;

        }

        Widget? topPaneToolbar = _getToolbar(widget.topPaneToolbar, Axis.horizontal);
        Widget? bottomPaneToolbar = _getToolbar(widget.bottomPaneToolbar, Axis.horizontal);
        Widget? leftPaneToolbar = _getToolbar(widget.leftPaneToolbar, Axis.vertical);
        Widget? rightPaneToolbar = _getToolbar(widget.rightPaneToolbar, Axis.vertical);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (topPaneToolbar != null)
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                child: topPaneToolbar
              ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (leftPaneToolbar != null)
                    Container(
                      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300))),
                      child: leftPaneToolbar
                    ),
                  Expanded(
                    child: DragTarget<DockElement>(
                      builder: (BuildContext context, List<DockElement?> candidateData, List<dynamic> rejectedData) {

                        List<Widget> stackElements = [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_topLeftPaneToolsIndex != -1 || _topRightPaneToolsIndex != -1)
                                SizedBox(height: _topPaneSize, child: _getTopPane()),
                              if (_topLeftPaneToolsIndex != -1 || _topRightPaneToolsIndex != -1)
                                MouseRegion(
                                  cursor: SystemMouseCursors.resizeRow,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onPanUpdate: (details) {
                                      _topPaneSize += details.delta.dy;
                                      if (_topPaneSize<_minimumPaneSize) {
                                        _topPaneSize = _minimumPaneSize;
                                      }
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                      child: Container(height: 1, color: Colors.grey.shade300,),
                                    ),
                                  ),
                                ),

                              Expanded( child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (_leftTopPaneToolsIndex != -1 || _leftBottomPaneToolsIndex != -1)
                                    SizedBox(width: _leftPaneSize, child: _getLeftPane()),
                                  if (_leftTopPaneToolsIndex != -1 || _leftBottomPaneToolsIndex != -1)
                                    MouseRegion(
                                      cursor: SystemMouseCursors.resizeColumn,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onPanUpdate: (details) {
                                          _leftPaneSize += details.delta.dx;
                                          if (_leftPaneSize<_minimumPaneSize) {
                                            _leftPaneSize = _minimumPaneSize;
                                          }
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                                          child: Container(width: 1, color: Colors.grey.shade300,),
                                        ),
                                      ),
                                    ),

                                  // main container
                                  Expanded( child: widget.child ?? const Center(child: Text('Empty container'),),),

                                  if (_rightTopPaneToolsIndex != -1 || _rightBottomPaneToolsIndex != -1)
                                    MouseRegion(
                                      cursor: SystemMouseCursors.resizeColumn,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onPanUpdate: (details) {
                                          _rightPaneSize -= details.delta.dx;
                                          if (_rightPaneSize<_minimumPaneSize) {
                                            _rightPaneSize = _minimumPaneSize;
                                          }
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                                          child: Container(width: 1, color: Colors.grey.shade300,),
                                        ),
                                      ),
                                    ),
                                  if (_rightTopPaneToolsIndex != -1 || _rightBottomPaneToolsIndex != -1)
                                    SizedBox(width: _rightPaneSize, child: _getRightPane()),
                                ],
                              ),),

                              if (_bottomLeftPaneToolsIndex != -1 || _bottomRightPaneToolsIndex != -1)
                                MouseRegion(
                                  cursor: SystemMouseCursors.resizeRow,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onPanUpdate: (details) {
                                      _bottomPaneSize -= details.delta.dy;
                                      if (_bottomPaneSize<_minimumPaneSize) {
                                        _bottomPaneSize = _minimumPaneSize;
                                      }
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                      child: Container(height: 1, color: Colors.grey.shade300,),
                                    ),
                                  ),
                                ),
                              if (_bottomLeftPaneToolsIndex != -1)
                                SizedBox(height: _bottomPaneSize, child: _getBottomPane()),
                            ],
                          ),
                        ];
                        if (candidateData.isNotEmpty) {

                          if (widget.topPane) {
                            stackElements.add(AnimatedOpacity(
                                opacity: _topLeftPaneDragOpacity,
                                duration: const Duration(milliseconds: 200),
                                child: Container(width: constraints.maxWidth/2, height: constraints.maxHeight/5, color: Colors.grey.withOpacity(0.5),))
                            );
                            stackElements.add(AnimatedOpacity(
                              opacity: _topRightPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(width: constraints.maxWidth/2, height: constraints.maxHeight/5, color: Colors.grey.withOpacity(0.5),)
                              ),
                            ));
                          }
                          if (widget.bottomPane) {
                            stackElements.add(AnimatedOpacity(
                              opacity: _bottomLeftPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(width: constraints.maxWidth/2, height: constraints.maxHeight/5, color: Colors.grey.withOpacity(0.5),)
                              ),
                            ));
                            stackElements.add(AnimatedOpacity(
                              opacity: _bottomRightPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(width: constraints.maxWidth/2, height: constraints.maxHeight/5, color: Colors.grey.withOpacity(0.5),)
                              ),
                            ));
                          }
                          if (widget.leftPane) {
                            double height = constraints.maxHeight;
                            double leftTopPadding = 0;
                            double leftBottomPadding = 0;
                            if (widget.topPane) {
                              height -= constraints.maxHeight/5;
                              leftTopPadding = constraints.maxHeight/5;
                            }
                            if (widget.bottomPane) {
                              height -= constraints.maxHeight/5;
                              leftBottomPadding = constraints.maxHeight/5;
                            }
                            stackElements.add(AnimatedOpacity(
                              opacity: _leftTopPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: EdgeInsets.only(top: leftTopPadding),
                                child: Container(width: constraints.maxWidth/5, height: height/2.0, color: Colors.grey.withOpacity(0.5),),
                              ),
                            ));
                            stackElements.add(AnimatedOpacity(
                              opacity: _leftBottomPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: leftBottomPadding),
                                    child: Container(width: constraints.maxWidth/5, height: height/2.0, color: Colors.grey.withOpacity(0.5),),
                                  )
                              ),
                            ));
                          }
                          if (widget.rightPane) {
                            double height = constraints.maxHeight;
                            double rightTopPadding = 0;
                            double rightBottomPadding = 0;
                            if (widget.topPane) {
                              height -= constraints.maxHeight/5;
                              rightTopPadding = constraints.maxHeight/5;
                            }
                            if (widget.bottomPane) {
                              height -= constraints.maxHeight/5;
                              rightBottomPadding = constraints.maxHeight/5;
                            }

                            stackElements.add(AnimatedOpacity(
                              opacity: _rightTopPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top: rightTopPadding),
                                  child: Container(width: constraints.maxWidth/5, height: height/2.0, color: Colors.grey.withOpacity(0.5),),
                                ),
                              ),
                            ));
                            stackElements.add(AnimatedOpacity(
                              opacity: _rightBottomPaneDragOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: rightBottomPadding),
                                    child: Container(width: constraints.maxWidth/5, height: height/2.0, color: Colors.grey.withOpacity(0.5),),
                                  )
                              ),
                            ));
                          }

                          // clear drag target opacity
                          _clearPaneDragOpacity();

                          // calculate split area depending on enabled panes.
                          double y1 = 0;
                          double y2 = constraints.maxHeight;
                          if (widget.topPane) {
                            y1 = constraints.maxHeight/5;
                          }
                          if (widget.bottomPane) {
                            y2 = constraints.maxHeight/5*4;
                          }

                          if (widget.topPane && _dragPosition.dy < constraints.maxHeight/5) {
                            if (_dragPosition.dx < constraints.maxWidth/2) {
                              _topLeftPaneDragOpacity = 0.5;
                            } else if (_dragPosition.dx > constraints.maxWidth/2) {
                              _topRightPaneDragOpacity = 0.5;
                            }
                          } else if (widget.bottomPane && _dragPosition.dy > constraints.maxHeight/5*4) {
                            if (_dragPosition.dx < constraints.maxWidth/2) {
                              _bottomLeftPaneDragOpacity = 0.5;
                            } else if (_dragPosition.dx > constraints.maxWidth/2) {
                              _bottomRightPaneDragOpacity = 0.5;
                            }
                          } else if (widget.leftPane && _dragPosition.dx < constraints.maxWidth/5) {
                            if (_dragPosition.dy < (y2-y1)/2) {
                              _leftTopPaneDragOpacity = 0.5;
                            } else {
                              _leftBottomPaneDragOpacity = 0.5;
                            }
                          } else if (widget.rightPane && _dragPosition.dx > constraints.maxWidth/5*4) {
                            if (_dragPosition.dy < (y2-y1)/2) {
                              _rightTopPaneDragOpacity = 0.5;
                            } else {
                              _rightBottomPaneDragOpacity = 0.5;
                            }
                          }
                        }

                        return Stack(
                          children: stackElements,
                        );
                      },
                      onAcceptWithDetails: (details) {
                        _clearPaneDragOpacity();

                        Offset globalPosition = details.offset+const Offset(80,20);
                        Offset localPosition = (context.findRenderObject() as RenderBox?)!.globalToLocal(globalPosition);
                        //print(localPosition);

                        DockSide? side;
                        if (widget.topPane && localPosition.dy < constraints.maxHeight/5) {
                          if (localPosition.dx < constraints.maxWidth/2) {
                            side = DockSide.topLeft;
                          } else {
                            side = DockSide.topRight;
                          }
                        } else if (widget.bottomPane && localPosition.dy > constraints.maxHeight/5*4) {
                          if (localPosition.dx < constraints.maxWidth/2) {
                            side = DockSide.bottomLeft;
                          } else {
                            side = DockSide.bottomRight;
                          }
                        } else if (widget.leftPane && localPosition.dx < constraints.maxWidth/5) {
                          if (localPosition.dy < constraints.maxHeight/2) {
                            side = DockSide.leftTop;
                          } else {
                            side = DockSide.leftBottom;
                          }
                        } else if (widget.rightPane && localPosition.dx > constraints.maxWidth/5*4) {
                          if (localPosition.dy < constraints.maxHeight/2) {
                            side = DockSide.rightTop;
                          } else {
                            side = DockSide.rightBottom;
                          }
                        }

                        if (side != null) {
                          _dockPane(details.data, side);
                          //print('dock pane ${details.data} to side $side');
                        }
                        setState(() {});
                      },
                      onMove: (details) {
                        Offset globalPosition = details.offset+const Offset(80,20);
                        _dragPosition = (context.findRenderObject() as RenderBox?)!.globalToLocal(globalPosition);
                        setState(() {});
                        //print(_dragPosition);
                      },
                    ),
                  ),
                  if (rightPaneToolbar != null)
                    Container(
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade300))),
                      child: rightPaneToolbar
                    ),
                ],
              ),
            ),
            if (bottomPaneToolbar != null)
              bottomPaneToolbar,
          ],
        );
      }
    );
  }

  void _dockPane(DockElement element, DockSide side) {
    if (_leftTopPaneTools.remove(element)) {
      _leftTopPaneToolsIndex = -1;
    }
    if (_leftBottomPaneTools.remove(element)) {
      _leftBottomPaneToolsIndex = -1;
    }
    if (_topLeftPaneTools.remove(element)) {
      _topLeftPaneToolsIndex = -1;
    }
    if (_topRightPaneTools.remove(element)) {
      _topRightPaneToolsIndex = -1;
    }
    if (_rightTopPaneTools.remove(element)) {
      _rightTopPaneToolsIndex = -1;
    }
    if (_rightBottomPaneTools.remove(element)) {
      _rightBottomPaneToolsIndex = -1;
    }
    if (_bottomLeftPaneTools.remove(element)) {
      _bottomLeftPaneToolsIndex = -1;
    }
    if (_bottomRightPaneTools.remove(element)) {
      _bottomRightPaneToolsIndex = -1;
    }

    switch (side) {
      case DockSide.leftTop:
        _leftTopPaneTools.add(element);
        _leftTopPaneToolsIndex = _leftTopPaneTools.length-1;
        break;
      case DockSide.leftBottom:
        _leftBottomPaneTools.add(element);
        _leftBottomPaneToolsIndex = _leftBottomPaneTools.length-1;
        break;
      case DockSide.topLeft:
        _topLeftPaneTools.add(element);
        _topLeftPaneToolsIndex = _topLeftPaneTools.length-1;
        break;
      case DockSide.topRight:
        _topRightPaneTools.add(element);
        _topRightPaneToolsIndex = _topRightPaneTools.length-1;
        break;
      case DockSide.rightTop:
        _rightTopPaneTools.add(element);
        _rightTopPaneToolsIndex = _rightTopPaneTools.length-1;
        break;
      case DockSide.rightBottom:
        _rightBottomPaneTools.add(element);
        _rightBottomPaneToolsIndex = _rightBottomPaneTools.length-1;
        break;
      case DockSide.bottomLeft:
        _bottomLeftPaneTools.add(element);
        _bottomLeftPaneToolsIndex = _bottomLeftPaneTools.length-1;
        break;
      case DockSide.bottomRight:
        _bottomRightPaneTools.add(element);
        _bottomRightPaneToolsIndex = _bottomRightPaneTools.length-1;
        break;
    }
  }

  void _clearPaneDragOpacity() {
    _leftTopPaneDragOpacity = 0.0;
    _leftBottomPaneDragOpacity = 0.0;
    _topLeftPaneDragOpacity = 0.0;
    _topRightPaneDragOpacity = 0.0;
    _rightTopPaneDragOpacity = 0.0;
    _rightBottomPaneDragOpacity = 0.0;
    _bottomLeftPaneDragOpacity = 0.0;
    _bottomRightPaneDragOpacity = 0.0;
  }

  Widget? _getLeftPane() {
    if (_leftTopPaneToolsIndex == -1 && _leftBottomPaneToolsIndex == -1) {
      return null;
    }

    List<Widget> widgets = [];
    if (_leftTopPaneToolsIndex != -1 && _leftBottomPaneToolsIndex == -1) {
      widgets.add(Expanded(child: _wrapPane(_leftTopPaneTools[_leftTopPaneToolsIndex], DockSide.leftTop)));
    }
    else if (_leftTopPaneToolsIndex == -1 && _leftBottomPaneToolsIndex != -1) {
      widgets.add(Expanded(child: _wrapPane(_leftBottomPaneTools[_leftBottomPaneToolsIndex], DockSide.leftBottom)));
    }
    else {
      widgets.add(SizedBox(height: _leftTopPaneSize, child: _wrapPane(_leftTopPaneTools[_leftTopPaneToolsIndex], DockSide.leftTop)));
      widgets.add(MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            _leftTopPaneSize = _leftTopPaneSize! + details.delta.dy;
            if (_leftTopPaneSize! < _minimumPaneSize) {
              _leftTopPaneSize = _minimumPaneSize;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Container(height: 1, color: Colors.grey.shade300,),
          ),
        ),
      ),
      );
      widgets.add(Expanded(child: _wrapPane(_leftBottomPaneTools[_leftBottomPaneToolsIndex], DockSide.leftBottom)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget? _getRightPane() {
    if (_rightTopPaneToolsIndex == -1 && _rightBottomPaneToolsIndex == -1) {
      return null;
    }

    List<Widget> widgets = [];
    if (_rightTopPaneToolsIndex != -1 && _rightBottomPaneToolsIndex == -1) {
      widgets.add(Expanded(child: _wrapPane(_rightTopPaneTools[_rightTopPaneToolsIndex], DockSide.rightTop)));
    }
    else if (_rightTopPaneToolsIndex == -1 && _rightBottomPaneToolsIndex != -1) {
      widgets.add(Expanded(child: _wrapPane(_rightBottomPaneTools[_rightBottomPaneToolsIndex], DockSide.rightBottom)));
    }
    else {
      widgets.add(SizedBox(height: _rightTopPaneSize, child: _wrapPane(_rightTopPaneTools[_rightTopPaneToolsIndex], DockSide.rightTop)));
      widgets.add(MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            _rightTopPaneSize = _rightTopPaneSize! + details.delta.dy;
            if (_rightTopPaneSize! < _minimumPaneSize) {
              _rightTopPaneSize = _minimumPaneSize;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Container(height: 1, color: Colors.grey.shade300,),
          ),
        ),
      ),
      );
      widgets.add(Expanded(child: _wrapPane(_rightBottomPaneTools[_rightBottomPaneToolsIndex], DockSide.rightBottom)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget? _getTopPane() {
    if (_topLeftPaneToolsIndex == -1 && _topRightPaneToolsIndex == -1) {
      return null;
    }

    List<Widget> widgets = [];
    if (_topLeftPaneToolsIndex != -1 && _topRightPaneToolsIndex == -1) {
      widgets.add(Expanded(child: _wrapPane(_topLeftPaneTools[_topLeftPaneToolsIndex], DockSide.topLeft)));
    }
    else if (_topLeftPaneToolsIndex == -1 && _topRightPaneToolsIndex != -1) {
      widgets.add(Expanded(child: _wrapPane(_topRightPaneTools[_topRightPaneToolsIndex], DockSide.topRight)));
    }
    else {
      widgets.add(SizedBox(width: _topLeftPaneSize, child: _wrapPane(_topLeftPaneTools[_topLeftPaneToolsIndex], DockSide.topLeft)));
      widgets.add(MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            _topLeftPaneSize = _topLeftPaneSize! + details.delta.dx;
            if (_topLeftPaneSize! < _minimumPaneSize) {
              _topLeftPaneSize = _minimumPaneSize;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Container(width: 1, color: Colors.grey.shade300,),
          ),
        ),
      ),
      );
      widgets.add(Expanded(child: _wrapPane(_topRightPaneTools[_topRightPaneToolsIndex], DockSide.topRight)));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget? _getBottomPane() {
    if (_bottomLeftPaneToolsIndex == -1 && _bottomRightPaneToolsIndex == -1) {
      return null;
    }

    List<Widget> widgets = [];
    if (_bottomLeftPaneToolsIndex != -1 && _bottomRightPaneToolsIndex == -1) {
      widgets.add(Expanded(child: _wrapPane(_bottomLeftPaneTools[_bottomLeftPaneToolsIndex], DockSide.bottomLeft)));
    }
    else if (_bottomLeftPaneToolsIndex == -1 && _bottomRightPaneToolsIndex != -1) {
      widgets.add(Expanded(child: _wrapPane(_bottomRightPaneTools[_bottomRightPaneToolsIndex], DockSide.bottomRight)));
    }
    else {
      widgets.add(SizedBox(width: _bottomLeftPaneSize, child: _wrapPane(_bottomLeftPaneTools[_bottomLeftPaneToolsIndex], DockSide.bottomLeft)));
      widgets.add(MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            _bottomLeftPaneSize = _bottomLeftPaneSize! + details.delta.dx;
            if (_bottomLeftPaneSize! < _minimumPaneSize) {
              _bottomLeftPaneSize = _minimumPaneSize;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Container(width: 1, color: Colors.grey.shade300,),
          ),
        ),
      ),
      );
      widgets.add(Expanded(child: _wrapPane(_bottomRightPaneTools[_bottomRightPaneToolsIndex], DockSide.bottomRight)));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget _wrapPane(DockElement pane, DockSide side) {

    return ClipRect(
      child: MouseRegion(
        onEnter: (event) => setState(() { _paneOpacityButtons[pane] = 1.0; }),
        onExit: (event) => setState(() { _paneOpacityButtons[pane] = 0.0; }),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Draggable(
                  data: pane,
                  dragAnchorStrategy: (draggable, context, position) => const Offset(80,20),
                  feedback: Material(
                    color: Colors.transparent,
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.grey.shade500)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(pane.name, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(pane.name, style: TextStyle(color: Colors.grey.shade700), overflow: TextOverflow.clip, maxLines: 1,),
                  ),
                )),
                AnimatedOpacity(
                  opacity: _paneOpacityButtons[pane] ?? 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInCubic,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Icon(Icons.more_vert, color: Colors.grey.shade400, size: 16,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {
                            switch (side) {
                              case DockSide.leftTop:
                                _leftTopPaneToolsIndex=-1;
                                break;
                              case DockSide.leftBottom:
                                _leftBottomPaneToolsIndex=-1;
                                break;
                              case DockSide.topLeft:
                                _topLeftPaneToolsIndex=-1;
                                break;
                              case DockSide.topRight:
                                _topRightPaneToolsIndex=-1;
                                break;
                              case DockSide.rightTop:
                                _rightTopPaneToolsIndex = -1;
                                break;
                              case DockSide.rightBottom:
                                _rightBottomPaneToolsIndex = -1;
                                break;
                              case DockSide.bottomLeft:
                                _bottomLeftPaneToolsIndex = -1;
                                break;
                              case DockSide.bottomRight:
                                _bottomRightPaneToolsIndex = -1;
                                break;
                            }
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Icon(Icons.remove, color: Colors.grey.shade400,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(child: pane.widget),
          ],
        ),
      ),
    );
  }

  // get all buttons associated to side
  List<Widget> _getSideElements(DockSide side, double size) {

    List<Widget> toReturn = [];

    List<DockElement> tools;
    switch (side) {
      case DockSide.leftTop:
        tools = _leftTopPaneTools;
        break;
      case DockSide.leftBottom:
        tools = _leftBottomPaneTools;
        break;
      case DockSide.topLeft:
        tools = _topLeftPaneTools;
        break;
      case DockSide.topRight:
        tools = _topRightPaneTools;
        break;
      case DockSide.rightTop:
        tools = _rightTopPaneTools;
        break;
      case DockSide.rightBottom:
        tools = _rightBottomPaneTools;
        break;
      case DockSide.bottomLeft:
        tools = _bottomLeftPaneTools;
        break;
      case DockSide.bottomRight:
        tools = _bottomRightPaneTools;
        break;
    }

    for (var tool in tools) {

      Widget w;

      if (tool.icon != null) {
        w = Padding(
          padding: const EdgeInsets.all(4.0),
          child: AspectRatio(aspectRatio: 1, child: tool.icon!),
        );
      } else {
        w = const Padding(
          padding: EdgeInsets.all(4.0),
          child: AspectRatio(aspectRatio: 1, child: FlutterLogo()),
        );
      }
      toReturn.add(InkWell(
        onTap: () {
          _presentElement(tool);
        },
        child: Tooltip(
          message: tool.name,
          child: w
        )
      ));
    }

    return toReturn;
  }

  // compose toolbar
  Widget? _getToolbar(DockToolbar toolbarDef, Axis axis) {

    List<Widget> widgets = [];

    for (int a=0; a<toolbarDef.part1.length; a++) {
      List<Widget> elements = _getSideElements(toolbarDef.part1[a], toolbarDef.toolbarSize);
      if (widgets.isNotEmpty && elements.isNotEmpty) {
        widgets.add(Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
        ));
      }
      widgets.addAll(elements);
    }
    widgets.add(Expanded(child: Container(),));
    List<Widget> widgetsPart2 = [];
    for (DockSide side in toolbarDef.part2) {
      List<Widget> elements = _getSideElements(side, toolbarDef.toolbarSize);
      if (widgetsPart2.isNotEmpty && elements.isNotEmpty) {
        widgetsPart2.add(Padding(
          padding: axis==Axis.horizontal ? const EdgeInsets.fromLTRB(3, 8, 3, 8) : const EdgeInsets.fromLTRB(8, 3, 8, 3),
          child: Container(
            color: Colors.grey.shade300,
            width: axis==Axis.horizontal?1:null,
            height: axis==Axis.horizontal?null:1,
          ),
        ));
      }
      widgetsPart2.addAll(elements);
    }
    widgets.addAll(widgetsPart2);

    // check if toolbar is empty. Only 1 element added (expanded separator)
    if (widgets.length == 1) {
      return null;
    }

    if (axis == Axis.horizontal) {
      return SizedBox(
        height: toolbarDef.toolbarSize,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      );
    } else {
      return SizedBox(
        width: toolbarDef.toolbarSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      );
    }
  }

  // bring to front element
  void _presentElement(DockElement element) {

    for (int a=0; a<_leftTopPaneTools.length; a++) {
      if (_leftTopPaneTools[a] == element) {
        if (_leftTopPaneToolsIndex == a) {
          _leftTopPaneToolsIndex = -1;
        } else {
          _leftTopPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_leftBottomPaneTools.length; a++) {
      if (_leftBottomPaneTools[a] == element) {
        if (_leftBottomPaneToolsIndex == a) {
          _leftBottomPaneToolsIndex = -1;
        } else {
          _leftBottomPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_topLeftPaneTools.length; a++) {
      if (_topLeftPaneTools[a] == element) {
        if (_topLeftPaneToolsIndex == a) {
          _topLeftPaneToolsIndex = -1;
        } else {
          _topLeftPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_topRightPaneTools.length; a++) {
      if (_topRightPaneTools[a] == element) {
        if (_topRightPaneToolsIndex == a) {
          _topRightPaneToolsIndex = -1;
        } else {
          _topRightPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_rightTopPaneTools.length; a++) {
      if (_rightTopPaneTools[a] == element) {
        if (_rightTopPaneToolsIndex == a) {
          _rightTopPaneToolsIndex = -1;
        } else {
          _rightTopPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_rightBottomPaneTools.length; a++) {
      if (_rightBottomPaneTools[a] == element) {
        if (_rightBottomPaneToolsIndex == a) {
          _rightBottomPaneToolsIndex = -1;
        } else {
          _rightBottomPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_bottomLeftPaneTools.length; a++) {
      if (_bottomLeftPaneTools[a] == element) {
        if (_bottomLeftPaneToolsIndex == a) {
          _bottomLeftPaneToolsIndex = -1;
        } else {
          _bottomLeftPaneToolsIndex = a;
        }
        break;
      }
    }

    for (int a=0; a<_bottomRightPaneTools.length; a++) {
      if (_bottomRightPaneTools[a] == element) {
        if (_bottomRightPaneToolsIndex == a) {
          _bottomRightPaneToolsIndex = -1;
        } else {
          _bottomRightPaneToolsIndex = a;
        }
        break;
      }
    }

    setState(() {});
  }
}