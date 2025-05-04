import 'package:flutter/material.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/shop_button.dart';

class Shop extends StatefulWidget {
  final FluttermelonGame game;

  const Shop({super.key, required this.game});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final List<Widget> shopButtons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Shop')),
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
