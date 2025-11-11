import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WebDatabaseHelper {
  static const String _cardsKey = 'pokemon_cards';

  Future<void> insertCard(Map<String, dynamic> card) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cards = await getCards();

    // Remove existing card with same id if any
    cards.removeWhere((c) => c['id'] == card['id']);

    // Add new card
    cards.add(card);

    // Save to shared preferences
    String jsonString = jsonEncode(cards);
    await prefs.setString(_cardsKey, jsonString);
  }

  Future<List<Map<String, dynamic>>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_cardsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<int> getCardCount() async {
    List<Map<String, dynamic>> cards = await getCards();
    return cards.length;
  }

  Future<void> deleteAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cardsKey);
  }
}
