import 'package:film_atlasi/utils/helpers.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Sekme sayısı
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keşfet'),
          backgroundColor: Colors.black,
          bottom: const TabBar(
            isScrollable: true, // Sekmelerin kaydırılabilir olmasını sağlar
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Genel Bakış'),
              Tab(text: 'En Çok Okunanlar'),
              Tab(text: 'Yeni Çıkanlar'),
              Tab(text: 'En Beğenilenler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(
                child: Text('Genel Bakış Sayfası')), // İlk sekme içeriği
            HorizontalCardList(), // En Çok Okunanlar
            HorizontalCardList(), // Yeni Çıkanlar
            HorizontalCardList(), // En Beğenilenler
          ],
        ),
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Text("en çok okunanlar", textAlign: TextAlign.start ,),
        ),
        Expanded(
          flex: 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Yatay kaydırma yönü
            itemCount: 10, // Kart sayısı
            itemBuilder: (context, index) {
              return Container(
                width:
                    MediaQuery.of(context).size.width * 0.7, // Kart genişliği
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.book, size: 50, color: Colors.white),
                    AddVerticalSpace(context, 0.01),
                    Text(
                      "Kart $index",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
