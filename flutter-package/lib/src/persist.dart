import 'package:flutter/material.dart';

class PersistController extends ChangeNotifier {
  Key __key = UniqueKey();

  bool _isLive = true;

  Key get _key => isLive ?  __key = UniqueKey() : __key;

  bool get isLive => _isLive;

  set isLive(bool value) {
    if (_isLive != value) {
      _isLive = value;
      notifyListeners();
    }
  }

  restart() {
    __key = UniqueKey();
    notifyListeners();
  }


}

class Persist extends StatefulWidget {
  final Widget child;
  final PersistController controller;

  const Persist({Key key, this.child, this.controller}) : super(key: key);
  @override
  _PersistState createState() => _PersistState();
}

class _PersistState extends State<Persist> {
  PersistController get controller => widget.controller;

  update() => setState(() {});

  @override
  void initState() {
    super.initState();
    controller.addListener(update);
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      child:  Builder(builder: (context) => widget.child,
      key: controller._key,
    ),);
  }

  @override
  void dispose() {
    controller.removeListener(update);
    super.dispose();
  }
}
