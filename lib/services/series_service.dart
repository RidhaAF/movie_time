import 'package:dio/dio.dart';
import 'package:movie_time/models/on_the_air_series_model.dart';
import 'package:movie_time/models/series_detail_model.dart';
import 'package:movie_time/models/series_season_detail_model.dart';
import 'package:movie_time/utilities/env.dart';

class SeriesService {
  String baseUrl = Env.baseURL;
  String imageBaseUrl = Env.imageBaseURL;
  String apiKey = Env.apiKey;
  String language = Env.language;
  String region = Env.region;
  var dio = Dio();

  Future<OnTheAirSeriesModel?> getOnTheAirSeries() async {
    String url =
        '$baseUrl/tv/on_the_air?api_key=$apiKey&language=$language&page=1';

    try {
      var response = await Dio().get(url);
      final data = OnTheAirSeriesModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<SeriesDetailModel?> getSeriesDetail(int id) async {
    String url = '$baseUrl/tv/$id?api_key=$apiKey&language=$language';

    try {
      var response = await Dio().get(url);
      final data = SeriesDetailModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<SeriesSeasonDetailModel?> getSeriesSeasonDetail(
    int id,
    int seasonNumber,
  ) async {
    String url =
        '$baseUrl/tv/$id/season/$seasonNumber?api_key=$apiKey&language=$language';

    try {
      var response = await Dio().get(url);
      final data = SeriesSeasonDetailModel.fromJson(response.data);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
