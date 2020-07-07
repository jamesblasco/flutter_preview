import 'dart:math';

import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  final Size initialSize;
  final Widget trailing;

  ResizableWidget({
    this.child,
    this.initialSize = const Size(200, 200),
    this.trailing,
  });

  final Widget child;
  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

const _kballDiameter = 30.0;

class _ResizableWidgetState extends State<ResizableWidget> {
  double height;
  double width;

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    height = widget.initialSize.height;
    width = widget.initialSize.width;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = min(constraints.maxWidth - 20, width);
        height = min(constraints.maxHeight - 20, height);

        final x = (constraints.maxWidth - width) / 2;
        final y = (constraints.maxHeight - height) / 2;

        return OnHover(
          child: widget.child,
          builder: (context, hover, child) => Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: height,
                  width: width,
                  child: child,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              ),
              // top left
              Positioned(
                top: y - _kballDiameter / 2,
                left: x - _kballDiameter / 2,
                width: _kballDiameter,
                height: _kballDiameter,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height - dy;
                      var newWidth = width - dx;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),
              // top middle
              Positioned(
                top: y - _kballDiameter / 2,
                left: x + width / 2 - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height - dy;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                      });
                    },
                  ),
                ),
              ),
              // top right
              Positioned(
                top: y - _kballDiameter / 2,
                left: x + width - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height - dy;
                      var newWidth = width + dx;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),
              // center right
              Positioned(
                top: y + height / 2 - _kballDiameter / 2,
                left: x + width - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newWidth = width + dx;

                      setState(() {
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),
              // bottom right
              Positioned(
                top: y + height - _kballDiameter / 2,
                left: x + width - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height + dy;
                      var newWidth = width + dx;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),
              // bottom center
              Positioned(
                top: y + height - _kballDiameter / 2,
                left: x + width / 2 - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height + dy;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                      });
                    },
                  ),
                ),
              ),
              // bottom left
              Positioned(
                top: y + height - _kballDiameter / 2,
                left: x - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      var newHeight = height + dy;
                      var newWidth = width - dx;

                      setState(() {
                        height = newHeight > 0 ? newHeight : 0;
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),
              //left center
              Positioned(
                top: y + height / 2 - _kballDiameter / 2,
                left: x - _kballDiameter / 2,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: ManipulatingBall(
                    onDrag: (dx, dy) {
                      final newWidth = width - dx;
                      setState(() {
                        width = newWidth > 0 ? newWidth : 0;
                      });
                    },
                  ),
                ),
              ),

              // trailing
              if (widget.trailing != null)
                Positioned(
                    top: y,
                    height: height,
                    left: x + width,
                    right: 0,
                    child: widget.trailing),
              // center center
              // Positioned(
              //   top: x + height / 2 - ballDiameter / 2,
              //   left: y + width / 2 - ballDiameter / 2,
              //   child: ManipulatingBall(
              //     onDrag: (dx, dy) {

              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag});

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    final dx = details.globalPosition.dx - initX;
    final dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return OnHover(
      builder: (context, hover, _) => GestureDetector(
          onPanStart: _handleDrag,
          onHorizontalDragStart: _handleDrag,
          onPanUpdate: _handleUpdate,
          onHorizontalDragUpdate: _handleUpdate,
          child: GestureDetector(
            onVerticalDragStart: _handleDrag,
            onVerticalDragUpdate: _handleUpdate,
            child: SizedBox(
              width: _kballDiameter,
              height: _kballDiameter,
              child: Center(
                  child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: hover ? _kballDiameter : _kballDiameter / 2,
                height: hover ? _kballDiameter : _kballDiameter / 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1),
                  shape: BoxShape.circle,
                ),
              )),
            ),
          )),
    );
  }
}

typedef OnHoverChildBuilder = Widget Function(
    BuildContext context, bool hover, Widget child);

class OnHover extends StatefulWidget {
  final OnHoverChildBuilder builder;
  final Widget child;
  // You can also pass the translation in here if you want to
  OnHover({Key key, this.builder, this.child}) : super(key: key);
  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  final nonHoverTransform = Matrix4.diagonal3Values(0.5, 0.5, 0);
  final hoverTransform = Matrix4.identity();
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (e) => _mouseEnter(true),
        onExit: (e) => _mouseEnter(false),
        child: widget.builder(context, _hovering, widget.child));
  }

  void _mouseEnter(bool hover) {
    setState(() {
      _hovering = hover;
    });
  }
}
