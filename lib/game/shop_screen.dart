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
  static final TextStyle _textStyle =
      TextStyle(fontFamily: "Helvetica", fontWeight: FontWeight.w700);

  int _previewCost = 100;
  int _ballRemovalCost = 2500;
  int _scoreBooster = 1500;

  void onVisible() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Page title bar
      appBar: AppBar(
        title: Center(
            child: Text(
          'Shop',
          style: _textStyle,
        )),
      ),

      /// Main shop area
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
                    "Remove Assembly Balls\nCost: $_ballRemovalCost points",
                    "Remove C++ Balls\nCost: $_ballRemovalCost points",
                    "No more ball removal upgrades"
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
                    return widget.game.canRemoveBallType() &&
                        widget.game.canPurchase(_ballRemovalCost);
                  }),

              SizedBox(height: 20),

              /// Double points earned
              ShopButton(
                  maxTier: 5,
                  tierTexts: [
                    "Double points earned from fusion\nCost: $_scoreBooster points",
                    "Double points earned from fusion\nCost: $_scoreBooster points",
                    "Double points earned from fusion\nCost: $_scoreBooster points",
                    "Double points earned from fusion\nCost: $_scoreBooster points",
                    "Double points earned from fusion\nCost: $_scoreBooster points",
                    "No more point boosters"
                  ],
                  tierActions: [
                    () {
                      widget.game.upgradeScoreMultiplier();
                      widget.game.chargePurchase(_scoreBooster);
                      _scoreBooster = 2500;
                      setState(() {});
                    },
                    () {
                      widget.game.upgradeScoreMultiplier();
                      widget.game.chargePurchase(_scoreBooster);
                      _scoreBooster = 4000;
                      setState(() {});
                    },
                    () {
                      widget.game.upgradeScoreMultiplier();
                      widget.game.chargePurchase(_scoreBooster);
                      _scoreBooster = 7500;
                      setState(() {});
                    },
                    () {
                      widget.game.upgradeScoreMultiplier();
                      widget.game.chargePurchase(_scoreBooster);
                      _scoreBooster = 1000;
                      setState(() {});
                    },
                    () {
                      widget.game.upgradeScoreMultiplier();
                      widget.game.chargePurchase(_scoreBooster);
                      setState(() {});
                    },
                  ],
                  canPurchase: () {
                    return widget.game.canUpgradeScoreMultiplier() &&
                        widget.game.canPurchase(_scoreBooster);
                  }),

              SizedBox(height: 20),

              /// Cheater button
              ShopButton(
                  maxTier: 0,
                  tierTexts: [
                    "Give yourself 100k points (Debug to skip some gameplay)"
                  ],
                  tierActions: [
                    () {
                      widget.game.addScore(100000);
                      setState(() {});
                    }
                  ],
                  canPurchase: () {
                    return true;
                  }),

              SizedBox(height: 20),

              ShopButton(
                  maxTier: 0,
                  tierTexts: ["About the App"],
                  tierActions: [
                    () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("About the App", style: _textStyle),
                            content: Text(
                              "This app is a game based on suikagame, which is a game about dropping fruits to earn points.It is also known by the name watermelon due to its knockoffs. That is why the game is called fluttermelon, as it is a flutter base watermelon game. Because of the programming theme, I also went with a dark mode for the game. The only thing to mention is that the preview goes from left to right, furthest away to closest. Thats all, enjoy the game!",
                              style: TextStyle(fontFamily: "Helvetica"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Close", style: _textStyle),
                              ),
                            ],
                          );
                        },
                      );
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
