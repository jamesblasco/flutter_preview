import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      builder: DevicePreview.appBuilder,
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
        title: Text('Home Screen '),
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

class DevicePreviewPreview extends PreviewProvider with Previewer {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => MyApp(),
    );
  }

  @override
  List<Preview> get previews => [];
}

class DevicePreviewPreview2 extends PreviewProvider with Previewer {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => MyApp(),
    );
  }

  @override
  List<Preview> get previews => [];
}
