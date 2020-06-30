import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:preview/src/controls.dart';
import 'package:preview/src/frame/frame.dart';
import 'package:preview/src/resizable.dart';
import 'package:preview/src/persist.dart';

import 'src/utils.dart';
export 'src/frame/frame.dart';
export 'src/frame/frames.dart';
export 'src/preview_page.dart';
export 'src/resizable.dart';

class Preview extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final BoxConstraints constraints;
  final FrameData frame;
  final ThemeData theme;

  const Preview({
    Key key,
    @required this.child,
    this.height,
    this.width,
    this.constraints,
    this.frame,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = frame != null ? Frame(frame: frame, child: child) : child;

    return Container(
      constraints: constraints,
      height: height,
      width: width,
      child: Theme(
        isMaterialAppTheme: true,
        data: theme ?? Theme.of(context),
        child: result,
      ),
    );
  }
}


mixin Previewer on StatelessWidget {
  Widget build(BuildContext context);
}

abstract class PreviewProvider extends StatelessWidget with Previewer{
  List<Preview> get previews;

  Widget build(BuildContext context) {
    return Scrollbar(
      child: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: previews
                .map<Widget>((e) => _Preview(child: e))
                .addInBetween(SizedBox(height: 20))
                .toList(),
          ),
        )),
      ),
    );
  }
}

abstract class ResizablePreviewProvider extends StatelessWidget with Previewer {
  Preview get preview;
 
  @override
  Widget build(BuildContext context) {
    return _Preview(
      resizable: true,
      child: preview,
    );
  }
}

class _Preview extends StatefulWidget {
  final Widget child;
  final bool resizable;

  const _Preview({
    Key key,
    @required this.child,
    this.resizable = false,
  }) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  PersistController controller;

  @override
  void initState() {
    
    controller = PersistController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final preview = Persist(controller: controller, child: widget.child);

    if (widget.resizable) {
      return OnHover(
          child: widget.child,
          builder: (context, hover, child) {
            final shouldDisplay = hover | !controller.isLive;
            return ResizableWidget(
              child: preview,
              trailing: AnimatedOpacity(
                opacity: shouldDisplay ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !shouldDisplay,
                  child: PreviewControls(
                    controller: controller,
                  ),
                ),
              ),
            );
          });
    }

    return OnHover(
      child: widget.child,
      builder: (context, hover, child) {
        final shouldDisplay = hover | !controller.isLive;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 32),
            Flexible(
              child: preview,
            ),
            AnimatedOpacity(
              opacity: shouldDisplay ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !shouldDisplay,
                child: PreviewControls(
                  controller: controller,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
