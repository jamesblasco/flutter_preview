import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:preview/preview.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicCard extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final VoidCallback onTap;

  const MusicCard({Key key, this.title, this.image, this.onTap})
      : super(key: key);

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: FutureBuilder<Color>(
                  future: getImagePalette(image),
                  builder: (context, snapshot) => Container(
                    color: snapshot.hasData
                        ? snapshot.data.withOpacity(0.2)
                        : null,
                    child: Center(
                      child: Text(title),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class WidgetPreview extends PreviewProvider {
  
  @override
  List<Preview> get previews {
    return [
      Preview(
        key: Key('test'),
        height: 300,
        width: 200,
        child: MusicCard(
          title: 'Testa',
          image: AssetImage('preview_assets/cover1.jpg'),
          onTap: () => {},
        ),
      ),
      Preview(
        key: Key('test1'),
        height: 200,
        width: 200,
        child: MusicCard(
          title: 'Test2',
          image: AssetImage('preview_assets/cover2.jpg'),
          onTap: () => {},
        ),
      ),
      Preview(
        key: Key('test2'),
        height: 200,
        width: 200,
        child: MusicCard(
          title: 'Test2',
          image: AssetImage('preview_assets/cover3.jpg'),
          onTap: () => {},
        ),
      ),
    ];
  }
}

class Resizable extends ResizablePreviewProvider with Previewer {
  @override
  Preview get preview {
    return Preview(
      child: MusicCard(
        title: 'Test 1',
        image: AssetImage('preview_assets/cover1.jpg'),
        onTap: () => {},
      ),
    );
  }
}

