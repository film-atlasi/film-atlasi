class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String sourceName; // Add the sourceName field here

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName, // Add the sourceName parameter here
  });
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? "No Title",
      description: json['description'] ?? "No Description",
      urlToImage: json['urlToImage'] ?? "",
      url: json['url'] ?? "",
      sourceName: json['sourceName'] ?? "No Source",
    );
  }
}
