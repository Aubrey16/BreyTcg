class CardModel {
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final int level;
  final String race;
  final double tcgPlayerPrice;

  CardModel({
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.race,
    required this.tcgPlayerPrice,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    // Mengambil URL gambar
    final cardImages = json['card_images'] as List<dynamic>?;
    final imageUrl = (cardImages != null && cardImages.isNotEmpty)
        ? cardImages[0]['image_url'] as String
        : 'https://via.placeholder.com/150';

    // Mengambil harga dari tcgplayer_price
    final cardPrices = json['card_prices'] as List<dynamic>?;
    final tcgPlayerPrice = (cardPrices != null && cardPrices.isNotEmpty)
        ? double.tryParse(cardPrices[0]['tcgplayer_price'] ?? '0.0') ?? 0.0
        : 0.0;

    return CardModel(
      name: json['name'] ?? 'Unknown Name',
      type: json['type'] ?? 'Unknown',
      description: json['desc'] ?? 'No description available',
      imageUrl: imageUrl,
      level: json['level'] ?? 0,
      race: json['race'] ?? 'Unknown',
      tcgPlayerPrice: tcgPlayerPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'desc': description,
      'card_images': [
        {'image_url': imageUrl},
      ],
      'level': level,
      'race': race,
      'tcgPlayerPrice': tcgPlayerPrice.toString(),
    };
  }
}
