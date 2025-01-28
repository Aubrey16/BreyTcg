import 'package:flutter/material.dart';
import '../utils/deck_manager.dart';
import '../screens/yu_gi_oh_list.dart';

class BuildingDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deckManager = DeckManager.of(context);

    if (!deckManager!.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: Text('Building Deck')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Building Deck')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                if (index < deckManager.deck.length) {
                  final card = deckManager.deck[index];
                  return Stack(
                    children: [
                      Image.network(
                        card.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.broken_image, color: Colors.red, size: 40),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            deckManager.removeCard(card.name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${card.name} removed from deck')),
                            );
                          },
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YuGiOhListPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.add, color: Colors.blue, size: 40),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  deckManager.deck.clear();
                  deckManager.saveDeck();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deck cleared successfully!')),
                  );
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await deckManager.saveDeck();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deck saved successfully!')),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
