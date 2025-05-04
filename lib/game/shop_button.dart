import 'package:flutter/material.dart';

class ShopButton extends StatefulWidget {
  final int maxTier;
  final List<String> tierTexts;
  final List<VoidCallback> tierActions;
  final bool Function() canPurchase;

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
