import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_time/models/now_playing_movie_model.dart';
import 'package:movie_time/models/on_the_air_series_model.dart';
import 'package:movie_time/models/popular_movie_model.dart';
import 'package:movie_time/models/upcoming_movie_model.dart';
import 'package:movie_time/utilities/env.dart';

class MovieService {
  String baseUrl = Env.baseURL;
  String imageBaseUrl = Env.imageBaseURL;
  String apiKey = Env.apiKey;
  String language = Env.language;
  String region = Env.region;
  var dio = Dio();

  Future<PopularMovieModel?> getPopular() async {
    var url = '$baseUrl/movie/popular?api_key=$apiKey&language=$language';

    try {
      var response = await dio.get(url);
      if (kDebugMode) {
        print(response.data);
      }
      final data = PopularMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NowPlayingMovieModel?> getNowPlaying() async {
    String url =
        '$baseUrl/movie/now_playing?api_key=$apiKey&language=$language&page=1&region=$region';
    try {
      var response = await Dio().get(url);
      if (kDebugMode) {
        print(response.data);
      }
      final data = NowPlayingMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OnTheAirSeriesModel?> getOnTheAirSeries() async {
    String url =
        '$baseUrl/tv/on_the_air?api_key=$apiKey&language=$language&page=1';
    try {
      var response = await Dio().get(url);
      if (kDebugMode) {
        print(response.data);
      }
      final data = OnTheAirSeriesModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UpcomingMovieModel?> getUpcomingMovie() async {
    String url =
        '$baseUrl/movie/upcoming?api_key=$apiKey&language=$language&page=1&region=$region';
    try {
      var response = await Dio().get(url);
      if (kDebugMode) {
        print(response.data);
      }
      final data = UpcomingMovieModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
