import 'dart:math';

import 'package:flutter/material.dart';
import 'package:preview/preview.dart';

class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({this.child});

  final Widget child;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

const ballDiameter = 30.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  double height = 400;
  double width = 200;

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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      width = min(constraints.maxWidth - 20, width);
      height = min(constraints.maxHeight - 20, height);

      final x = (constraints.maxWidth - width) / 2;
      final y = (constraints.maxHeight - height) / 2;

      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              height: height,
              width: width,
              color: Colors.red[100],
              child: widget.child,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2)),
            ),
          ),
          // top left
          Positioned(
            top: y - ballDiameter / 2,
            left: x - ballDiameter / 2,
            width: ballDiameter,
            height: ballDiameter,
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
          // top middle
          Positioned(
            top: y - ballDiameter / 2,
            left: x + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy) {
                var newHeight = height - dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                });
              },
            ),
          ),
          // top right
          Positioned(
            top: y - ballDiameter / 2,
            left: x + width - ballDiameter / 2,
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
          // center right
          Positioned(
            top: y + height / 2 - ballDiameter / 2,
            left: x + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy) {
                var newWidth = width + dx;

                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                });
              },
            ),
          ),
          // bottom right
          Positioned(
            top: y + height - ballDiameter / 2,
            left: x + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy) {
              
                var newHeight =   height + dy;
                var newWidth =  width + dx;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                });
              },
            ),
          ),
          // bottom center
          Positioned(
            top: y + height - ballDiameter / 2,
            left: x + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy) {
                var newHeight = height + dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                });
              },
            ),
          ),
          // bottom left
          Positioned(
            top: y + height - ballDiameter / 2,
            left: x - ballDiameter / 2,
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
          //left center
          Positioned(
            top: y + height / 2 - ballDiameter / 2,
            left: x - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy) {
                final newWidth = width - dx;
                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                });
              },
            ),
          ),
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
      );
    });
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
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return TranslateOnHover(
      builder: (context, hover) => GestureDetector(
        onPanStart: _handleDrag,
        onHorizontalDragStart: _handleDrag,
        onPanUpdate: _handleUpdate,
        onHorizontalDragUpdate: _handleUpdate,
        child: SizedBox(
          width: ballDiameter,
          height: ballDiameter,
          child: Center(
              child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: hover ? ballDiameter : ballDiameter / 2,
            height: hover ? ballDiameter : ballDiameter / 2,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              shape: BoxShape.circle,
            ),
          )),
        ),
      ),
    );
  }
}

typedef OnHoverChildBuilder = Widget Function(BuildContext context, bool hover);

class TranslateOnHover extends StatefulWidget {
  final OnHoverChildBuilder builder;
  // You can also pass the translation in here if you want to
  TranslateOnHover({Key key, this.builder}) : super(key: key);
  @override
  _TranslateOnHoverState createState() => _TranslateOnHoverState();
}

class _TranslateOnHoverState extends State<TranslateOnHover> {
  final nonHoverTransform = Matrix4.diagonal3Values(0.5, 0.5, 0);
  final hoverTransform = Matrix4.identity();
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (e) => _mouseEnter(true),
        onExit: (e) => _mouseEnter(false),
        child: widget.builder(context, _hovering));
  }

  void _mouseEnter(bool hover) {
    setState(() {
      _hovering = hover;
    });
  }
}
