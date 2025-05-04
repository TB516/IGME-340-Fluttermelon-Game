import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/shop.dart';

void main() async {
  runApp(const FluttermelonApp());
}

class FluttermelonApp extends StatelessWidget {
  const FluttermelonApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fluttermelon',
        theme: ThemeData(colorScheme: ColorScheme.highContrastDark()),
        debugShowCheckedModeBanner: false,
        home: FluttermelonHome());
  }
}

class FluttermelonHome extends StatefulWidget {
  const FluttermelonHome({super.key});

  @override
  State<FluttermelonHome> createState() => _FluttermelonHomeState();
}

class _FluttermelonHomeState extends State<FluttermelonHome> {
  int curBottomTab = 0;

  late final FluttermelonGame _game;
  late final bottomNavScreens;

  final bottomNavButtons = [
    BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Game'),
    BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop')
  ];

  @override
  void initState() {
    super.initState();

    _game = FluttermelonGame();

    bottomNavScreens = [
      GameWidget(game: _game),
      Shop(game: _game),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(index: curBottomTab, children: bottomNavScreens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curBottomTab,
        items: bottomNavButtons,
        onTap: (value) {
          setState(() {
            curBottomTab = value;

            if (value == 0) {
              _game.resumeEngine();
            } else {
              _game.pauseEngine();
            }
          });
        },
      ),
    );
  }
}
