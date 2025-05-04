import 'package:flutter/material.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/shop_button.dart';

class ShopScreen extends StatefulWidget {
  final FluttermelonGame game;

  const ShopScreen({super.key, required this.game});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Example list of ShopButton widgets
  final List<Widget> shopButtons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: shopButtons,
          ),
        ),
      ),
    );
  }
}
