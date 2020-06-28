import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:preview/resizable.dart';

import 'frame/frame.dart';
export 'frame/frames.dart';
export 'resizable.dart';

class PreviewPage extends StatelessWidget {
  final List<PreviewProvider> providers;
  final String path;
  final Widget child;

  const PreviewPage({
    Key key,
    List<PreviewProvider> providers,
    this.child,
    this.path,
  })  : this.providers = providers ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: KeyedSubtree(
        key: Key('page_$path'),
        child: _ProviderPageView(providers: providers, child: child),
      ),
    );
  }
}

class _ProviderPageView extends StatefulWidget {
  final List<PreviewProvider> providers;
  final Widget child;

  const _ProviderPageView({Key key, this.providers, this.child})
      : super(key: key);
  @override
  __ProviderPageViewState createState() => __ProviderPageViewState();
}

class __ProviderPageViewState extends State<_ProviderPageView> {
  int page = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previews',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        bottom: widget.providers.length <= 1
            ? null
            : PreferredSize(
                child: Container(
                  height: 40,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: page == 0 ? 0 : 1,
                        child: IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: () => controller.previousPage(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.easeInOut),
                        ),
                      ),
                      Text('${page + 1} / ${widget.providers.length}'),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: page == (widget.providers.length -1) ? 0 : 1,
                        child: IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () => controller.nextPage(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.easeInOut),
                        ),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size(
                  double.infinity,
                  40,
                ),
              ),
      ),
      body: widget.child != null
          ? Center(child: widget.child)
          : PageView.builder(
              controller: controller,
              onPageChanged: (page) {
                setState(() {
                  this.page = page;
                });
              },
              itemBuilder: (context, index) =>
                  widget.providers[index].build(context),
              itemCount: widget.providers.length,
            ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> addInBetween(T item) sync* {
    if (length <= 1) {
      yield* this;
      return;
    }
    for (final widget in take(length - 1)) {
      yield widget;
      yield item;
    }
    yield last;
  }
}

abstract class PreviewProvider {
  List<Preview> get previews;

  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: List<Widget>.from(previews)
              .addInBetween(
                SizedBox(
                  height: 20,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

abstract class ResizablePreviewProvider extends PreviewProvider {
  Preview get preview;
  List<Preview> get previews => [];
  @override
  Widget build(BuildContext context) {
    return ResizebleWidget(child: preview);
  }
}

class Preview extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final BoxConstraints constraints;
  final FrameData frame;
  const Preview(
      {Key key,
      @required this.child,
      this.height,
      this.width,
      this.constraints,
      this.frame})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = frame != null ? Frame(frame: frame, child: child) : child;
    return Container(
      constraints: constraints,
      height: height,
      width: width,
      child: widget,
    );
  }
}

extension ObjectNull on Object {
  bool get isNull => this == null;
  bool get isNotNull => !isNull;
}
