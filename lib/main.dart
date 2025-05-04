import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late final SharedPreferences _preferences;

  GlobalKey<ShopScreenState> shopKey = GlobalKey<ShopScreenState>();

  int curBottomTab = 0;

  int _highScore = 0;

  FluttermelonGame _game =
      FluttermelonGame(resetGameCallback: () {}, highScore: 0);
  List<Widget> bottomNavScreens = [
    Text("waiting"),
    Text("Waiting"),
  ];

  final bottomNavButtons = [
    BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Game'),
    BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop')
  ];

  void _resetGame({int score = 0}) {
    _highScore = _preferences.getInt('highScore') ?? 0;

    if (score > _highScore) {
      _preferences.setInt('highScore', score);
      _highScore = score;
    }

    _game =
        FluttermelonGame(resetGameCallback: _resetGame, highScore: _highScore);

    shopKey = GlobalKey<ShopScreenState>();

    bottomNavScreens = [
      GameWidget(game: _game),
      ShopScreen(key: shopKey, game: _game),
    ];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      _preferences = await SharedPreferences.getInstance();
      _resetGame();
      setState(() {}); // Ensure the UI updates after initialization
    });
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
              shopKey.currentState?.onVisible();
              _game.pauseEngine();
            }
          });
        },
      ),
    );
  }
}
