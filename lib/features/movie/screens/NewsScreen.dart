import 'package:film_atlasi/features/movie/screens/newsDetailsScreen.dart';
import 'package:film_atlasi/features/movie/services/news_services.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future<List<NewsArticle>>? futureNews;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void fetchNews() {
    setState(() {
      futureNews = NewsService().fetchNews("movies");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          fetchNews();
        },
        child: FutureBuilder<List<NewsArticle>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text("Haberleri yüklerken hata oluştu"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Haber bulunamadı"));
            }

            var newsList = snapshot.data!;

            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                var article = newsList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        article.urlToImage.isNotEmpty &&
                                Uri.tryParse(article.urlToImage)
                                        ?.hasAbsolutePath ==
                                    true
                            ? article.urlToImage
                            : "https://via.placeholder.com/300x200?text=G%C3%B6rsel+Bulunamad%C4%B1",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            "https://via.placeholder.com/300x200?text=G%C3%B6rsel+Bulunamad%C4%B1",
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      ListTile(
                        title: Text(article.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.description.isNotEmpty
                                  ? article.description
                                  : "Açıklama bulunmuyor",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Kaynak: ${article.sourceName ?? "Bilinmiyor"}",
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
