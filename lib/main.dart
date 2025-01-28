import 'package:flutter/material.dart';
import 'screens/yu_gi_oh_list.dart';
import 'screens/building_deck.dart';
import 'utils/deck_manager.dart';

void main() => runApp(BreyTCGApp());

class BreyTCGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeckManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Breytcg',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    YuGiOhListPage(),
    BuildingDeckPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.filter_1), label: 'Yu-Gi-Oh'),
          BottomNavigationBarItem(icon: Icon(Icons.deck), label: 'Building Deck'),
        ],
      ),
    );
  }
}
