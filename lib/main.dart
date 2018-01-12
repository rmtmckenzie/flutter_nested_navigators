import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new Home(),
      routes: {
        "willpop": (context) => new WillPopTest(),
      },
    );
  }
}

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new FlatButton(
        onPressed: () => Navigator.pushNamed(context, "willpop"),
        child: new Text("Click to start test"),
        color: Colors.green,
      ),
    );
  }
}

class WillPopTest extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey();

  @override
  State<StatefulWidget> createState() => new WillPopTestState();
}

class WillPopTestState extends State<WillPopTest> with WidgetsBindingObserver {
  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @protected
  @mustCallSuper
  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    final NavigatorState navigator = widget.navigatorKey.currentState;
    assert(navigator != null);
    return await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> subRoutes = {
      "one": (context) => new Column(children: [
            new Text("page 1 - pressing back will take you to home"),
            new FlatButton(
                onPressed: () => Navigator.pushNamed(context, "two"),
                child: new Text("next"))
          ]),
      "two": (context) => new Column(children: [
            new Text(
                "page 2 - pressing back should take you to page 1 but doesn't - it would if widgetbindingobserver worked"),
            new FlatButton(
                onPressed: () => Navigator.pushNamed(context, "three"),
                child: new Text("next"))
          ]),
      "three": (context) => new Column(children: [
            new WillPopScope(
                child: new Text("You shouldn't be able to leave me!"),
                onWillPop: () async => false),
          ])
    };

    return new Column(
      children: [
        new Text("Will pop test"),
        new Expanded(
          child: new Container(
            color: Colors.grey.shade100,
            child: new Navigator(
              key: widget.navigatorKey,
              initialRoute: "one",
              onGenerateRoute: (RouteSettings settings) =>
                  new MaterialPageRoute(
                    settings: settings,
                    builder: (context) => new Material(
                          child: subRoutes[settings.name](context),
                        ),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
