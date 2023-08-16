import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_time/models/image_model.dart';
import 'package:movie_time/models/watchlist_model.dart';
import 'package:movie_time/services/movie_service.dart';
import 'package:movie_time/services/series_service.dart';

class WatchlistService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<WatchlistModel>?> getWatchlists() async {
    List<WatchlistModel> watchlists = [];

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('watchlists')
          .where('user_id', isEqualTo: user?.uid)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        final ImageModel? response;
        if (data['watchlist_type'] == 'movie') {
          response = await MovieService().getImages(int.parse(data['id']));
        } else {
          response = await SeriesService().getImages(int.parse(data['id']));
        }
        data['poster_path'] = response?.posters?[0].filePath;
        WatchlistModel watchlist = WatchlistModel.fromJson(data);
        watchlists.add(watchlist);
      }

      return watchlists;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting watchlists: $e');
      }
      return null;
    }
  }
}
