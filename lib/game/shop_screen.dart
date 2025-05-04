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
    print(_previewCost);
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
                    "Increase number of previews to 2\nCost: 100 points",
                    "Increase number of previews to 3\nCost: 200 points",
                    "Increase number of previews to 4\nCost: 600 points",
                    "Increase number of previews to 5\nCost: 1200 points",
                    "No more preview upgrades!"
                  ],
                  tierActions: [
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost = 200;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost = 600;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost = 1200;
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
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
