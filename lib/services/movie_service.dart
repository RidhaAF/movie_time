import 'package:dio/dio.dart';
import 'package:movie_time/models/movie_model.dart';
import 'package:movie_time/utilities/env.dart';

class MovieService {
  String baseUrl = Env.baseURL;
  String imageBaseUrl = Env.imageBaseURL;
  String apiKey = Env.apiKey;
  String language = Env.language;
  String region = Env.region;
  var dio = Dio();
  var headers = {'Content-Type': 'application/json'};

  Future<MovieModel?> getPopular() async {
    var url = '$baseUrl/movie/popular?api_key=$apiKey&language=$language';

    try {
      var response = await dio.get(url, options: Options(headers: headers));
      print(response.data);
      final data = MovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
      throw Exception('Failed to load get popular');
    }
  }

  Future<MovieModel?> getLatest() async {
    String url = '$baseUrl/movie/latest?api_key=$apiKey&language=$language';
    try {
      var response = await Dio().get(url);
      print(response.data);
      final data = MovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
      throw Exception('Failed to load get latest');
    }
  }
}
