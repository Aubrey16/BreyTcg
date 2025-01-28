import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const yugiohApi = 'https://db.ygoprodeck.com/api/v7/cardinfo.php';

  static Future<List<dynamic>> fetchYuGiOhCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_cards');

    // Jika ada cache, gunakan cache
    if (cachedData != null) {
      print('Loading cards from cache');
      return json.decode(cachedData);
    }

    // Jika tidak ada cache, ambil dari API
    final response = await http.get(Uri.parse(yugiohApi));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // Simpan data ke cache
      prefs.setString('cached_cards', json.encode(data));
      print('Fetching cards from API');
      return data;
    } else {
      throw Exception('Failed to load Yu-Gi-Oh cards');
    }
  }
}
