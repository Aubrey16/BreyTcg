import 'package:flutter/material.dart';

class DeckSlot extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onRemove;

  const DeckSlot({
    required this.name,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(imageUrl, fit: BoxFit.cover),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
