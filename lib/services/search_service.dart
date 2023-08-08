import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_time/utilities/env.dart';

class SearchService {
  String baseUrl = Env.baseURL;
  String imageBaseUrl = Env.imageBaseURL;
  String apiKey = Env.apiKey;
  String language = Env.language;
  String region = Env.region;
  var dio = Dio();

  Future searchMulti(String query) async {
    String url =
        '$baseUrl/search/multi?query=$query&api_key=$apiKey&include_adult=false&language=$language&page=1';

    try {
      var response = await dio.get(url);
      final data = response.data;
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw Exception(e);
    }
  }
}
