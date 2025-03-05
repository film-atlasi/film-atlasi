import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';

class TrailerScreen extends StatefulWidget {
  final String? trailerUrl;
  final Movie movie;

  const TrailerScreen(
      {super.key, required this.trailerUrl, required this.movie});

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  Future<void> _refreshPage() async {
    setState(() {});
  }
  YoutubePlayerController? _controller;
  bool isYouTubeVideo = false;
  int _selectedIndex = 1; // kesfet sekmesi için 0

  @override
  void initState() {
    super.initState();

    if (widget.trailerUrl != null) {
      if (widget.trailerUrl!.contains("youtube.com")) {
        isYouTubeVideo = true;
        final videoId = YoutubePlayer.convertUrlToId(widget.trailerUrl!);
        if (videoId != null) {
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
        }
      }
    }
  }

  void _launchIMDB() async {
    if (widget.trailerUrl != null) {
      final url = Uri.parse(widget.trailerUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: RefreshIndicator( // 🔥 SAYFA AŞAĞI ÇEKİLİNCE YENİLEME
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Sayfa çekilebilir olsun
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filmin afişi
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/original${widget.movie.posterPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Fragman oynatıcı veya IMDB butonu
              if (isYouTubeVideo && _controller != null) ...[
                Center(child: YoutubePlayer(controller: _controller!)),
              ] else if (widget.trailerUrl != null) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: _launchIMDB,
                    child: const Text("IMDB'de İzle"),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Bu film için fragman bulunamadı.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // **Her durumda filmin içeriği burada olacak**
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.movie.overview,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 24),
                        const SizedBox(width: 5),
                        Text(
                          widget.movie.voteAverage.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Iletipaylas(movie: widget.movie),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share, size: 24),
                          tooltip: 'Paylaş',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
