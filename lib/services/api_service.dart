import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../db_helper.dart';
import '../web_db_helper.dart';

class ApiService {
  static const String apiUrl = 'https://api.pokemontcg.io/v2/cards?pageSize=50';

  Future<void> fetchAndStoreCards() async {
    try {
      print('Fetching cards from API: $apiUrl');
      final response = await http.get(Uri.parse(apiUrl));
      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cards = data['data'] as List;
        print('Received ${cards.length} cards from API');

        // Use web-compatible database helper for web, SQLite for mobile
        final dynamic dbHelper =
            kIsWeb ? WebDatabaseHelper() : DatabaseHelper();

        for (var i = 0; i < cards.length; i++) {
          var card = cards[i];
          Map<String, dynamic> cardData = {
            'id': card['id'] ?? '',
            'name': card['name'] ?? 'Unknown',
            'imageSmall': card['images']?['small'] ?? '',
            'imageLarge': card['images']?['large'] ?? '',
          };

          await dbHelper.insertCard(cardData);
          if (i % 10 == 0) {
            print('Stored $i cards...');
          }
        }
        print('Successfully stored all ${cards.length} cards');
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchAndStoreCards: $e');
      throw Exception('Error fetching cards: $e');
    }
  }
}
