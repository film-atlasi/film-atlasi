import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Haber Detayı")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage.isNotEmpty
                ? Image.network(article.urlToImage)
                : SizedBox(height: 200, child: Placeholder()),
            SizedBox(height: 10),
            Text(article.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(article.description),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final Uri _url = Uri.parse(article.url);
                if (await canLaunch(_url.toString())) {
                  await launch(_url.toString());
                }
              },
              child: Text("Haberi Oku"),
            ),
          ],
        ),
      ),
    );
  }
}
