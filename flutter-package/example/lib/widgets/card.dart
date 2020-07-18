import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:preview/preview.dart';

class MusicCard extends StatelessWidget {
  final String title;
  final String singer;
  final double radius;
  final ImageProvider image;
  final VoidCallback onTap;

  const MusicCard(
      {Key key,
      this.title,
      this.image,
      this.onTap,
      this.singer,
      this.radius = 0})
      : super(key: key);

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final Completer<void> completer = Completer<void>();
    stream.addListener(ImageStreamListener(
        (ImageInfo info, bool syncCall) => completer.complete()));
    await completer.future;

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      clipBehavior: Clip.hardEdge,
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
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: FutureBuilder<Color>(
                    future: getImagePalette(image),
                    builder: (context, snapshot) {
                      final color = snapshot.hasData
                          ? snapshot.data.withOpacity(0.5)
                          : null;
                      final brightness = ThemeData.estimateBrightnessForColor(
                          color ?? Colors.black);
                      final textColor = brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        color: color,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 300),
                                style: TextStyle(color: textColor),
                                child: Flexible(
                                  child: Text(title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Flexible(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 300),
                                  style: TextStyle(color: textColor),
                                  child: Text(singer,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
        height: 300,
        width: 200,
        mode: UpdateMode.hotReload,
        child: MusicCard(
          title: 'Blond',
          singer: 'Frank Ocean',
          image: PreviewImage.asset('preview/assets/cover1.jpg'),
          onTap: () => {},
        ),
      ),
      Preview(
        height: 200,
        width: 200,
        mode: UpdateMode.hotRestart,
        child: MusicCard(
          title: 'Safe',
          singer: 'Arlo',
          image: PreviewImage.asset('preview/assets/cover2.jpg'),
          onTap: () => {},
        ),
      ),
      Preview(
        height: 200,
        width: 300,
        mode: UpdateMode.hotReload,
        child: MusicCard(
          title: '1989',
          singer: 'Taylor Swift',
          image: PreviewImage.asset('preview/assets/cover3.jpg'),
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
      mode: UpdateMode.hotReload,
      screenshotSettings:
          ScreenshotSettings(pixelRatio: 4, filename: 'test.png'),
      child: MusicCard(
        title: 'Blond',
        singer: 'Frank Ocean',
        image: PreviewImage.asset('preview/assets/cover1.jpg'),
        onTap: () => {},
      ),
    );
  }
}

class AlbumData extends Object {
  final String title;
  final String singer;
  final String asset;

  AlbumData(this.title, this.singer, this.asset);
}

class StaggeredCard extends StatelessWidget with Previewer {
  @override
  String get title => 'Grid';

  @override
  Widget build(BuildContext context) {
    final a = AlbumData('Blond', 'Frank Ocean', 'preview/assets/cover1.jpg');
    final b = AlbumData('Blond', 'Frank Ocean', 'preview/assets/cover2.jpg');
    final c = AlbumData('Blond', 'Frank Ocean', 'preview/assets/cover3.jpg');
    final list = [a, b, c, b, a, c, b, a, a, a, a, a, a, a];
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(4),
      crossAxisCount: 4,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final album = list[index];
        return MusicCard(
          radius: 12,
          onTap: () => {},
          title: album.title,
          singer: album.singer,
          image: PreviewImage.asset(album.asset),
        );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isOdd ? 2 : 4),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
