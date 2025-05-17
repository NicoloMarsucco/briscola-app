import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import 'main_menu_quote.dart';

/// Provides a random quote to the main menu screen.
class RandomQuoteProvider {
  /// The quotes to be shown.
  static late final List<MainMenuQuote> _quotes;

  /// Generator of random int to choose sentence randomly.
  static final _random = Random();

  /// Flag to ensure quotyes are loaded only once.
  static bool _isLoaded = false;

  /// Initializes the quote provider by loading quotes from assets.
  ///
  /// This method be called once before [getRandomQuote] is called.
  static Future<void> loadQuotes() async {
    if (_isLoaded) {
      return;
    }
    _isLoaded = true;
    try {
      final jsonString =
          await rootBundle.loadString("assets/quotes/quotes.json");
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _quotes = jsonList
          .map((item) => MainMenuQuote.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _quotes = [MainMenuQuote.fallback];
    }
  }

  /// Provides the quote for the home screen.
  static MainMenuQuote getRandomQuote() {
    return _quotes[_random.nextInt(_quotes.length)];
  }
}
