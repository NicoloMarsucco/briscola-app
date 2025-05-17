/// The quote-author pair to be shown on the Main Menu.
class MainMenuQuote {
  /// The quote.
  ///
  /// It should not end with a full stop in order to look nicer
  /// on the main menu.
  final String quote;

  // The author of the quote.
  final String author;

  /// Fallback in case the quotes cannot be loaded.
  static MainMenuQuote fallback = MainMenuQuote("I love Briscola", "Anonymous");

  /// Initializes a new instance of [MainMenuQuote].
  MainMenuQuote(this.quote, this.author);

  /// Creates a new instance of [MainMenuQuote] from json.
  factory MainMenuQuote.fromJson(Map<String, dynamic> json) {
    return MainMenuQuote(json['quote'] as String, json['author'] as String);
  }

  /// The quotes with " before and after.
  String getFormattedQuote() {
    return "\"$quote\"";
  }

  /// The autor with cit. at the front.
  String getFormattedAuthor() {
    return "cit. $author";
  }
}
