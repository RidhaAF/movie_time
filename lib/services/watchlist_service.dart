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
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        final List<dynamic> contents = data['contents'] ?? [];
        for (var item in contents) {
          final ImageModel? response;
          if (item['content_type'] == 'movie') {
            response = await MovieService()
                .getImages(int.parse(item['content_id'] ?? '0'));
          } else {
            response = await SeriesService()
                .getImages(int.parse(item['content_id'] ?? '0'));
          }
          item['poster_path'] = response?.posters?[0].filePath;
        }
        data['contents'] = contents;

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

  Future<Map<String, dynamic>> addToWatchlist(WatchlistModel watchlist) async {
    final Map<String, dynamic> watchlistData = {
      'content_id': watchlist.contents?.first.contentId,
      'content_type': watchlist.contents?.first.contentType,
    };

    try {
      watchlist.userId = user?.uid;

      final QuerySnapshot querySnapshot = await firestore
          .collection('watchlists')
          .where('user_id', isEqualTo: watchlist.userId)
          .get();

      final DocumentReference watchlistRef = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first.reference
          : firestore.collection('watchlists').doc();

      await watchlistRef.set(
        {
          'user_id': watchlist.userId,
          'contents': FieldValue.arrayUnion([watchlistData]),
        },
        SetOptions(merge: true), // Use merge to avoid overwriting existing data
      );

      return {
        'success': true,
        'status': 201,
        'message': 'Added to Watchlist',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to watchlist: $e');
      }
      return {
        'success': false,
        'status': 500,
        'message': 'Failed to add to Watchlist',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> removeFromWatchlist(
      WatchlistModel watchlist) async {
    final Map<String, dynamic> watchlistData = {
      'content_id': watchlist.contents?.first.contentId,
      'content_type': watchlist.contents?.first.contentType,
    };

    try {
      watchlist.userId = user?.uid;

      final QuerySnapshot querySnapshot = await firestore
          .collection('watchlists')
          .where('user_id', isEqualTo: watchlist.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference watchlistRef =
            querySnapshot.docs.first.reference;

        await watchlistRef.update(
          {
            'contents': FieldValue.arrayRemove([watchlistData]),
          },
        );

        final updatedDocument = await watchlistRef.get();

        final List<dynamic> contents = updatedDocument['contents'];
        if (contents.isEmpty) {
          await watchlistRef.delete();
        }
      }

      return {
        'success': true,
        'status': 200,
        'message': 'Removed from Watchlist',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error removing from watchlist: $e');
      }
      return {
        'success': false,
        'status': 500,
        'message': 'Failed to remove from Watchlist',
        'error': e.toString(),
      };
    }
  }
}
