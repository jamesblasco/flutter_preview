import 'package:flutter/material.dart';

import 'package:preview/preview.dart';

class Chip extends StatelessWidget {
  final String title;
  final Color color;
  final bool outline;

  const Chip({Key key, this.title, this.color, this.outline = false})
      : super(key: key);

  const Chip.outlined({Key key, this.title, this.color})
      : this.outline = true,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final _color = color ?? Theme.of(context).accentColor;
    final padding = EdgeInsets.symmetric(horizontal: 20, vertical: 4);
    final radius = BorderRadius.circular(4);
    if (outline) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: _color), borderRadius: radius),
        padding: padding,
        child: Text(
          title,
          style: TextStyle(color: _color),
        ),
      );
    } else {
      final textColor =
          _color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
      return Container(
        decoration: BoxDecoration(color: _color, borderRadius: radius),
        padding: padding,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      );
    }
  }
}

class WidgetPreview extends PreviewProvider {
  @override
  List<Preview> get previews {
    return [
      Preview(
        child: Chip(title: 'TAG'),
      ),
      Preview(
        child: Chip(title: 'TAG'),
      ),
      Preview(
        child: Chip(
          color: Colors.red,
          title: 'TAG',
        ),
      ),
      Preview(
        child: Chip(
          color: Colors.black,
          title: 'TAG',
        ),
      ),
      Preview(
        child: Chip.outlined(
          color: Colors.white,
          title: 'TAG',
        ),
      ),
      Preview(
        child: Chip.outlined(
          color: Colors.red,
          title: 'TAG',
        ),
      ),
      Preview(
        child: Chip.outlined(
          title: 'TAG',
        ),
      ),
    ];
  }
}
