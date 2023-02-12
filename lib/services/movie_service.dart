import 'package:dio/dio.dart';
import 'package:movie_time/models/credit_model.dart';
import 'package:movie_time/models/movie_detail_model.dart';
import 'package:movie_time/models/now_playing_movie_model.dart';
import 'package:movie_time/models/popular_movie_model.dart';
import 'package:movie_time/models/recommendation_movie_model.dart';
import 'package:movie_time/models/upcoming_movie_model.dart';
import 'package:movie_time/utilities/env.dart';

class MovieService {
  String baseUrl = Env.baseURL;
  String imageBaseUrl = Env.imageBaseURL;
  String apiKey = Env.apiKey;
  String language = Env.language;
  String region = Env.region;
  var dio = Dio();

  Future<PopularMovieModel?> getPopularMovies() async {
    String url = '$baseUrl/movie/popular?api_key=$apiKey&language=$language';

    try {
      var response = await dio.get(url);
      final data = PopularMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NowPlayingMovieModel?> getNowPlayingMovies() async {
    String url =
        '$baseUrl/movie/now_playing?api_key=$apiKey&language=$language&page=1&region=$region';

    try {
      var response = await Dio().get(url);
      final data = NowPlayingMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UpcomingMovieModel?> getUpcomingMovies() async {
    String url =
        '$baseUrl/movie/upcoming?api_key=$apiKey&language=$language&page=1&region=$region';

    try {
      var response = await Dio().get(url);
      final data = UpcomingMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<MovieDetailModel?> getMovieDetail(int id) async {
    String url =
        '$baseUrl/movie/$id?api_key=$apiKey&language=$language&append_to_response=releases';

    try {
      var response = await Dio().get(url);
      final data = MovieDetailModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CreditModel?> getCredits(int id) async {
    String url =
        '$baseUrl/movie/$id/credits?api_key=$apiKey&language=$language';

    try {
      var response = await Dio().get(url);
      final data = CreditModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RecommendationMovieModel?> getRecommendationMovies(int id) async {
    String url =
        '$baseUrl/movie/$id/recommendations?api_key=$apiKey&language=$language&page=1';

    try {
      var response = await Dio().get(url);
      final data = RecommendationMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
