import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';

class SearchService {
  final MovieService _movieService = MovieService();

  Future<List<dynamic>> search(String query) async {
    final movies = await _movieService.searchMovies(query);
    final users = await UserServices.searchUsers(query);
    return [...users, ...movies];
  }
}