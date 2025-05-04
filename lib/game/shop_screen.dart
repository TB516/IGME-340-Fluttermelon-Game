import 'package:flutter/material.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_types.dart';
import 'package:fluttermelon/game/shop_button.dart';

class ShopScreen extends StatefulWidget {
  final FluttermelonGame game;

  const ShopScreen({super.key, required this.game});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  int _previewCost = 100;
  int _ballRemovalCost = 2500;

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
                      setState(() {});
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost = 600;
                      setState(() {});
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      _previewCost = 1200;
                      setState(() {});
                    },
                    () {
                      widget.game.increasePreviewCount();
                      widget.game.chargePurchase(_previewCost);
                      setState(() {});
                    }
                  ],
                  canPurchase: () {
                    return widget.game.canIncreasePreviewCount() &&
                        widget.game.canPurchase(_previewCost);
                  }),

              SizedBox(height: 20),

              /// Smaller ball removal
              ShopButton(
                  maxTier: 2,
                  tierTexts: [
                    "Remove Assembly Balls\nCost: 2500 points",
                    "Remove C++ Balls\nCost: 7500 points"
                  ],
                  tierActions: [
                    () {
                      widget.game.removeBallType(LangBallTypes.assembly);
                      widget.game.chargePurchase(_ballRemovalCost);
                      _ballRemovalCost = 7500;
                      setState(() {});
                    },
                    () {
                      widget.game.removeBallType(LangBallTypes.cpp);
                      widget.game.chargePurchase(_ballRemovalCost);
                      setState(() {});
                    }
                  ],
                  canPurchase: () {
                    return widget.game.canPurchase(_ballRemovalCost);
                  }),

              SizedBox(height: 20),

              ShopButton(
                  maxTier: 0,
                  tierTexts: [
                    "Give yourself 100k points (Debug to skip some gameplay)"
                  ],
                  tierActions: [
                    () {
                      widget.game.addScore(2500);
                      setState(() {});
                    }
                  ],
                  canPurchase: () {
                    return true;
                  })
            ],
          ),
        ),
      ),
    );
  }
}
