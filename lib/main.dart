import 'package:everest_app/controller/app_controller.dart';
import 'package:state_extended/state_extended.dart';
import 'package:flutter/material.dart' hide StateSetter;
import 'package:everest_app/view/home.dart';

void main() => runApp(const MyApp(key: Key('MyApp')));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends AppStateX<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();
  static _MyAppState? _this;

  _MyAppState._()
      : super(
          controller: AppController(),
          object: 'Hello',
        );

  /// Override this build function if you don't want to use the built-in FutureBuilder or InheritedWidget
  @override
  Widget build(BuildContext context) => super.build(context);

  /// This is the widget returned by the built-in FutureBuilder widget.
  /// Override this build function if you don't want to use the built-in InheritedWidget
  @override
  Widget buildWidget(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: super.buildWidget(context),
      );

  /// This returns the 'child' widget supplied to the InheritedWidget.
  @override
  Widget buildChild(BuildContext context) => MyHomePage(key: UniqueKey());
}
