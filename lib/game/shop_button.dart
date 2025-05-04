import 'package:flutter/material.dart';

class ShopButton extends StatefulWidget {
  final int maxTier;
  final List<String> tierTexts;
  final List<VoidCallback> tierActions;
  final bool Function(int tier) canPurchase;

  const ShopButton({
    super.key,
    required this.maxTier,
    required this.tierTexts,
    required this.tierActions,
    required this.canPurchase,
  });

  @override
  _ShopButtonState createState() => _ShopButtonState();
}

class _ShopButtonState extends State<ShopButton> {
  int currentTier = 0;

  void _onPressed() {
    if (widget.canPurchase(currentTier)) {
      widget.tierActions[currentTier]();
      setState(() {
        if (currentTier < widget.maxTier) {
          currentTier++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPurchasable = widget.canPurchase(currentTier);

    return Column(
      children: [
        ElevatedButton(
          onPressed: isPurchasable ? _onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPurchasable ? Colors.blue : Colors.grey,
          ),
          child: Text(
            widget.tierTexts[currentTier],
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: currentTier / widget.maxTier,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
      ],
    );
  }
}
