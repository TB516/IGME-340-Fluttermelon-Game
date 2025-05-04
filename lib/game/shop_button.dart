import 'package:flutter/material.dart';

class ShopButton extends StatefulWidget {
  final int maxTier;
  final List<String> tierTexts;
  final List<VoidCallback> tierActions;
  final bool Function() canPurchase;

  /// Creates a shop button with passed in data.
  /// Max tier - number of tiers the button has
  /// Tier texts - list of text for each tier
  /// tier actions - List of actions to perform when the button is clicked at the tier
  /// can purchase - callback function to ensure the upgrade can be purchased
  const ShopButton({
    super.key,
    required this.maxTier,
    required this.tierTexts,
    required this.tierActions,
    required this.canPurchase,
  });

  @override
  ShopButtonState createState() => ShopButtonState();
}

class ShopButtonState extends State<ShopButton> {
  static final TextStyle _textStyle =
      TextStyle(fontFamily: "Helvetica", fontWeight: FontWeight.w700);
  int currentTier = 0;

  /// Calls callback for current tier level then increases to next tier
  void _onPressed() {
    widget.tierActions[currentTier]();

    if (widget.maxTier != 0) {
      currentTier++;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isPurchasable = widget.canPurchase();

    return Column(
      children: [
        /// Actual text button
        ElevatedButton(
          onPressed: isPurchasable ? _onPressed : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
          ),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                widget.tierTexts[currentTier],
                textAlign: TextAlign.center,
                style: _textStyle,
              )),
        ),
        SizedBox(height: 8),

        /// Light up buttons to indicate number of upgrades purchased
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.maxTier, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < currentTier ? Colors.green : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}
