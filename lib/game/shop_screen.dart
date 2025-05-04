import 'package:flutter/material.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/shop_button.dart';

class ShopScreen extends StatefulWidget {
  final FluttermelonGame game;

  const ShopScreen({super.key, required this.game});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  double _previewCost = 100;

  void onVisible() {
    setState(() {});
  }

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
            children: [
              /// Preview upgrade button
              ShopButton(
                  maxTier: 4,
                  tierTexts: [
                    "Increase number of previews to 2\nCost: $_previewCost points",
                    "Increase number of previews to 3\nCost: $_previewCost points",
                    "Increase number of previews to 4\nCost: $_previewCost points",
                    "Increase number of previews to 5\nCost: $_previewCost points",
                    "No more preview upgrades!"
                  ],
                  tierActions: [
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost *= 2;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost *= 3;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost *= 4;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost *= 5;
                    }
                  ],
                  canPurchase: () {
                    return widget.game.canIncreasePreviewCount() &&
                        widget.game.canPurchase(_previewCost);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
