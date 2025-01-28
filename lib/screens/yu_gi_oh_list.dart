import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import '../models/card_model.dart';
import '../widgets/card_tile.dart';
import 'yu_gi_oh_detail.dart';

class YuGiOhListPage extends StatefulWidget {
  @override
  _YuGiOhListPageState createState() => _YuGiOhListPageState();
}

class _YuGiOhListPageState extends State<YuGiOhListPage> {
  List<CardModel> allCards = [];
  List<CardModel> displayedCards = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int itemsPerPage = 15;
  int currentPage = 1;

  String searchQuery = '';
  String selectedLevel = 'All';
  String selectedRace = 'All';
  String selectedPriceRange = 'All';

  final List<String> levelOptions = ['All', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10','11','12','13'];
  final List<String> raceOptions = ['All', 'Dragon', 'Warrior', 'Spellcaster', 'Wyrm'];
  final List<String> priceOptions = ['All', '<=\$10', '>=\$11 & <=50', '>=\$51 & <=\$100', '>\$100'];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCards();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchCards() async {
    try {
      final data = await ApiService.fetchYuGiOhCards();
      setState(() {
        allCards = data.map((json) => CardModel.fromJson(json)).toList();
        displayedCards = allCards.take(itemsPerPage).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCards() {
    List<CardModel> filtered = allCards;


    if (selectedLevel != 'All') {
      filtered = filtered.where((card) => card.level.toString() == selectedLevel).toList();
    }

 
    if (selectedRace != 'All') {
      filtered = filtered.where((card) => card.race == selectedRace).toList();
    }


    if (selectedPriceRange != 'All') {
      filtered = filtered.where((card) {
        final price = card.tcgPlayerPrice;
        switch (selectedPriceRange) {
          case '<=\$10':
            return price <= 10;
          case '>=\$11 & <=\$50':
            return price >= 11 && price <= 50;
          case '>=\$51 & <=\$100':
            return price >= 51 && price <= 100;
          case '>\$100':
            return price > 100;
          default:
            return true;
        }
      }).toList();
    }


    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((card) => card.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    setState(() {
      displayedCards = filtered.take(itemsPerPage).toList();
      currentPage = 1;
    });
  }

  void _loadMoreCards() {
    if (displayedCards.length < allCards.length) {
      setState(() {
        isLoadingMore = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          int start = displayedCards.length;
          int end = start + itemsPerPage;
          displayedCards.addAll(allCards.sublist(start, end > allCards.length ? allCards.length : end));
          isLoadingMore = false;
        });
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        displayedCards.length < allCards.length) {
      _loadMoreCards();
    }
  }

  Widget buildFilterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Level'),
          DropdownButton<String>(
            value: selectedLevel,
            items: levelOptions.map((level) {
              return DropdownMenuItem(value: level, child: Text(level));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
              filterCards();
            },
          ),
          SizedBox(height: 16),
          Text('Type'),
          DropdownButton<String>(
            value: selectedRace,
            items: raceOptions.map((race) {
              return DropdownMenuItem(value: race, child: Text(race));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedRace = value!;
              });
              filterCards();
            },
          ),
          SizedBox(height: 16),
          Text('Price (TCGPlayer)'),
          DropdownButton<String>(
            value: selectedPriceRange,
            items: priceOptions.map((price) {
              return DropdownMenuItem(value: price, child: Text(price));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPriceRange = value!;
              });
              filterCards();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search cards...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  filterCards();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => buildFilterSheet(),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : displayedCards.isEmpty
              ? Center(child: Text('No cards match the filter.'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: displayedCards.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= displayedCards.length) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final card = displayedCards[index];
                    return CardTile(
                      name: card.name,
                      imageUrl: card.imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YuGiOhDetailPage(card: card),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
