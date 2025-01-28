import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/card_model.dart';

class DeckManager extends InheritedWidget {
  final List<CardModel> deck = [];
  bool isLoaded = false; // Track if the deck has been loaded

  DeckManager({required Widget child}) : super(child: child) {
    _loadDeck();
  }

  static DeckManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DeckManager>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  // Add a card to the deck
  void addCard(CardModel card) {
    deck.add(card);
    saveDeck(); // Save the updated deck
  }

  // Remove a card from the deck
  void removeCard(String cardName) {
    deck.removeWhere((card) => card.name == cardName);
    saveDeck(); // Save the updated deck
  }

  // Save the deck to shared preferences
  Future<void> saveDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final deckJson = deck.map((card) => card.toJson()).toList();
    await prefs.setString('deck', json.encode(deckJson));
    print('Deck saved: $deckJson');
  }

  // Load the deck from shared preferences
  Future<void> _loadDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final deckJson = prefs.getString('deck');
    if (deckJson != null) {
      final List decoded = json.decode(deckJson);
      deck.clear();
      deck.addAll(decoded.map((data) => CardModel.fromJson(data)).toList());
      print('Deck loaded: $deck');
    }
    isLoaded = true;
  }
}
