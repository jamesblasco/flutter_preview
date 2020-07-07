import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/flutter_storyboard.dart';
import 'package:preview/preview.dart';
import 'package:random_color/random_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Storyboard Example',
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.light,
      // home: HomeScreen(),
      initialRoute: '/settings',
      routes: {
        '/': (_) => HomeScreen(),
        '/counter': (_) => CounterScreen(),
        '/settings': (_) => SettingsScreen(),
        for (var i = 0; i < 25; i++)
          '/screen_$i': (_) => _generateScreen(
                title: Text('Screen$i'),
                color: RandomColor(i).randomColor(),
              ),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/about') return AboutScreen();
            return UnknownScreen();
          },
        );
      },
    );
  }
}

Widget _generateScreen({
  Text title,
  FloatingActionButton fab,
  Color color,
}) {
  return Builder(
    builder: (context) {
      final Map<String, dynamic> args =
          ModalRoute.of(context).settings.arguments;
      return Scaffold(
        appBar: AppBar(title: title),
        backgroundColor: color,
        body: args == null ? null : Center(child: Text(args.toString())),
        floatingActionButton: fab,
      );
    },
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text(_size.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.info),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SettingsScreen(),
          ));
        },
      ),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key key}) : super(key: key);

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Example'),
      ),
      body: Center(
        child: Text('Counter: $_counter'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (mounted)
            setState(() {
              _counter++;
            });
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings 2'),
      ),
      backgroundColor: Colors.blue.shade300,
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      backgroundColor: Colors.purple.shade300,
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404'),
      ),
      backgroundColor: Colors.red.shade300,
    );
  }
}

class StoryBoardPreview extends PreviewProvider with Previewer {
  @override
  Widget build(BuildContext context) {
    return StoryBoard.material(
      initialOffset: Offset(0, 0),
      initialScale: 0.2,
      enabled: true,
      usePreferences: true,
      crossAxisCount: 7,
      canPanAndScrollWithGesture: true,
      cupertinoDevice: CupertinoDevice.iPhone8,
      screenSize: Size(400, 700),
      customScreens: [
        for (var i = 0; i < 25; i++)
          _generateScreen(
            title: Text('Screen$i'),
            color: RandomColor(i + 25).randomColor(),
          ),
      ],
      customRoutes: [
        RouteSettings(name: '/about'),
        RouteSettings(name: '/counter'),
        RouteSettings(name: '/screen_2'),
        RouteSettings(name: '/screen_5'),
        RouteSettings(
          name: '/screen_8',
          arguments: <String, dynamic>{"id": 1234},
        ),
      ],
      child: MyApp().build(context),
    );
  }

  @override
  List<Preview> get previews => [];
}

class NormalPreview extends PreviewProvider {
  @override
  List<Preview> get previews => [
        Preview(
          child: MyApp(),
          frame: Frames.iphone8,
        )
      ];
}

class NormalPreview2 extends PreviewProvider {
  @override
  List<Preview> get previews => [
        Preview(
          child: MyApp(),
          frame: Frames.iphone8,
        )
      ];
}

class NormalPreview3 extends PreviewProvider {
  @override
  List<Preview> get previews => [
        Preview(
          child: MyApp(),
          frame: Frames.iphone8,
        )
      ];
}
