import 'dart:convert';

class WatchlistModel {
  String? id;
  String? userId;
  List<Content>? contents;

  WatchlistModel({
    this.id,
    this.userId,
    this.contents,
  });

  factory WatchlistModel.fromRawJson(String str) =>
      WatchlistModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
        id: json["id"],
        userId: json["user_id"],
        contents: List<Content>.from(
            json["contents"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "contents": List<dynamic>.from(contents!.map((x) => x.toJson())),
      };
}

class Content {
  String? contentId;
  String? contentType;
  String? posterPath;

  Content({
    this.contentId,
    this.contentType,
    this.posterPath,
  });

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        contentId: json["content_id"],
        contentType: json["content_type"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "content_type": contentType,
      };
}
