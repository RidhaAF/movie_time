import 'dart:convert';

class WatchlistModel {
  String? id;
  String? userId;
  String? watchlistType;
  String? posterPath;

  WatchlistModel({
    this.id,
    this.userId,
    this.watchlistType,
    this.posterPath,
  });

  factory WatchlistModel.fromRawJson(String str) =>
      WatchlistModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
        id: json["id"],
        userId: json["user_id"],
        watchlistType: json["watchlist_type"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "watchlist_type": watchlistType,
      };
}
