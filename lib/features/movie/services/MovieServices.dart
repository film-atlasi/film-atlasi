import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:http/http.dart' as http;
import 'package:film_atlasi/features/movie/models/Movie.dart';

class MovieService {
  final String apiKey = 'c427167528d75438842677fbca3866fe';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/search/movie?api_key=$apiKey&query=$query&language=tr-TR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Film arama başarısız oldu');
    }
  }

  Future<Movie?> getMovieFromFireStore(String id) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final postsCollection = firestore.collection('films');
      final docSnapshot = await postsCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Movie.fromFirebase(docSnapshot);
      } else {
        throw Exception('Film bulunamadı');
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getMovieTrailer(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        final trailer = results.firstWhere(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => results.isNotEmpty ? results.first : null,
        );

        if (trailer != null) {
          return 'https://www.youtube.com/watch?v=${trailer['key']}';
        }
      }
    }

    // Eğer TMDB'de fragman yoksa, IMDB'ye yönlendirebiliriz
    final imdbUrl = await getIMDBTrailer(movieId);
    return imdbUrl;
  }

  /// IMDB sayfasına yönlendirme için bir fonksiyon
  Future<String?> getIMDBTrailer(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/external_ids?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['imdb_id'] != null) {
        return 'https://www.imdb.com/title/${data['imdb_id']}/';
      }
    }
    return null;
  }

  Future<Map<String, String>> getWatchProviders(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId/watch/providers?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results']['TR'] != null) {
        final providers = data['results']['TR']['flatrate'] as List<dynamic>?;
        if (providers != null) {
          return {
            for (var provider in providers)
              provider['provider_name'].toString():
                  "https://image.tmdb.org/t/p/w200${provider['logo_path']}"
          };
        }
      }
      return {};
    } else {
      throw Exception('İzleme sağlayıcıları alınamadı');
    }
  }

  Future<Map<int, String>> fetchGenreMap() async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genres = data['genres'] as List<dynamic>;
      return {for (var genre in genres) genre['id']: genre['name']};
    } else {
      throw Exception('Tür bilgisi alınamadı');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Gelen JSON: $data"); // Gelen JSON'u konsola yazdır
      return Movie.fromJson(data);
    } else {
      throw Exception('Film detayları alınamadı');
    }
  }

  //trend filmler için apı kullanımı
  Future<List<Movie>> getTrendingMovies({String timeWindow = 'week'}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/trending/movie/$timeWindow?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Gelen veriyi görmek için
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Trend filmler alınamadı');
    }
  }

  //BİLİM KURGU FİLMLERİ CEKME
  Future<List<Movie>> getTrendingSciFiMovies(
      {String timeWindow = 'day'}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/trending/movie/$timeWindow?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Bilim Kurgu türündeki filmleri filtrele
      return (data['results'] as List)
          .where((movie) =>
              movie['genre_ids'] != null &&
              (movie['genre_ids'] as List).contains(878))
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Trend ve Bilim Kurgu filmleri alınamadı');
    }
  }

  //Romantik komedi
  Future<List<Movie>> getRomantikKomedi() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&with_genres=10749,35&sort_by=vote_average.desc&vote_count.gte=100'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // En yüksek puanlı Romantik (10749) ve Komedi (35) türündeki filmleri al
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('En yüksek puanlı Romantik Komedi filmleri alınamadı');
    }
  }

  Future<List<Actor>> getMovieActors(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> castJson = data['cast'];
      return castJson.map((json) => Actor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cast');
    }
  }

  Future<Movie?> getMovieByUid(String Uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final moviesCollection = firestore.collection('films');
      final docSnapshot = await moviesCollection.doc(Uid).get();
      if (docSnapshot.exists) {
        return Movie.fromFirebase(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching movie by UID: $e');
      return null;
    }
  }

  // actorlerin filmlerini sergileme için kullanılıyor
  Future<List<Movie>> getMoviesByActor(int actorId, int page) async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&with_cast=$actorId&page=$page&language=tr-TR';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();

        return movies;
      } else {
        print("API Hatası: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("İstek sırasında hata oluştu: $e");
      return [];
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Yakında çıkacak filmler alınamadı');
    }
  }

  Future<List<Movie>> getHorrorMovies() async {
    return await fetchMoviesByGenre(27); // 27 korku filmleri için genre ID
  }

  Future<List<Movie>> getClassicMovies() async {
    // Klasik filmler için 1950-1980 arası filmler
    return await fetchMoviesByYear(1950, 1980);
  }

  Future<List<Movie>> getLGBTQMovies() async {
    // LGBTQ+ filmler için anahtar kelime araması
    return await searchMovies("lgbtq");
  }

  Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&with_genres=$genreId&sort_by=popularity.desc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Genre ID: $genreId için filmler alınamadı');
    }
  }

  Future<List<Movie>> fetchMoviesByYear(int startYear, int endYear) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&primary_release_date.gte=$startYear-01-01&primary_release_date.lte=$endYear-12-31&sort_by=vote_average.desc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception(
          '$startYear-$endYear yılları arasındaki filmler alınamadı');
    }
  }

  Future<List<Movie>> fetchFilteredMovies({
    required double minImdb,
    required String genre,
    required String country,
    required int year,
    required int minDuration,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey'
        '&language=tr-TR'
        '&vote_average.gte=$minImdb'
        '&with_genres=$genre'
        '&primary_release_year=$year'
        '&with_runtime.gte=$minDuration'
        '&region=$country'
        '&sort_by=popularity.desc',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Filtrelenmiş filmler alınamadı');
    }
  }

  Future<List<Movie>> getPopularMoviesOnNetflix() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&with_watch_providers=8&watch_region=TR&sort_by=popularity.desc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Netflix\'te popüler filmler alınamadı');
    }
  }
}
