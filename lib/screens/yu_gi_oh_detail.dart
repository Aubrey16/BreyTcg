import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/deck_manager.dart';

class YuGiOhDetailPage extends StatelessWidget {
  final CardModel card;

  const YuGiOhDetailPage({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deckManager = DeckManager.of(context);

    void addToDeck() {
      final currentCount = deckManager!.deck
          .where((item) => item.name == card.name)
          .length;

      if (deckManager.deck.length >= 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deck is full. Maximum 20 cards allowed.')),
        );
        return;
      }

      if (currentCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum 3 copies of this card allowed.')),
        );
        return;
      }

      deckManager.addCard(card);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${card.name} added to deck!')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      resizeToAvoidBottomInset: true, // Adjust for keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Display
                card.imageUrl.isNotEmpty
                    ? Image.network(
                        card.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Placeholder(
                        fallbackHeight: 250,
                        fallbackWidth: double.infinity,
                      ),
                SizedBox(height: 16),

                // Card Description
                Text(
                  card.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Add to Deck Button
                Center(
                  child: ElevatedButton(
                    onPressed: addToDeck,
                    child: Text('Add to Deck'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
