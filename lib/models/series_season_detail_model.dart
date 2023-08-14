class SeriesSeasonDetailModel {
  int? id;
  DateTime? airDate;
  List<Episode>? episodes;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;
  double? voteAverage;

  SeriesSeasonDetailModel({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
    this.voteAverage,
  });

  factory SeriesSeasonDetailModel.fromJson(Map<String, dynamic> json) {
    return SeriesSeasonDetailModel(
      id: json['id'],
      airDate: DateTime.parse(json['air_date']),
      episodes: (json['episodes'] != null)
          ? List<Episode>.from(json['episodes'].map((x) => Episode.fromJson(x)))
          : [],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      seasonNumber: json['season_number'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'air_date': airDate,
      'episodes': episodes,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'season_number': seasonNumber,
      'vote_average': voteAverage,
    };
  }
}

class Episode {
  DateTime? airDate;
  int? episodeNumber;
  String? episodeType;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  int? showId;
  String? stillPath;
  double? voteAverage;
  int? voteCount;
  List<Crew>? crew;
  List<Crew>? guestStars;

  Episode({
    this.airDate,
    this.episodeNumber,
    this.episodeType,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.runtime,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.crew,
    this.guestStars,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      airDate: DateTime.parse(json['air_date']),
      episodeNumber: json['episode_number'],
      episodeType: json['episode_type'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      productionCode: json['production_code'],
      runtime: json['runtime'],
      seasonNumber: json['season_number'],
      showId: json['show_id'],
      stillPath: json['still_path'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
      crew: (json['crew'] != null)
          ? (json['crew'] as List<dynamic>)
              .map((x) => Crew.fromJson(x))
              .toList()
          : [],
      guestStars: (json['guest_stars'] != null)
          ? (json['guest_stars'] as List<dynamic>)
              .map((x) => Crew.fromJson(x))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'air_date': airDate,
      'episode_number': episodeNumber,
      'episode_type': episodeType,
      'id': id,
      'name': name,
      'overview': overview,
      'production_code': productionCode,
      'runtime': runtime,
      'season_number': seasonNumber,
      'show_id': showId,
      'still_path': stillPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'crew': crew,
      'guest_stars': guestStars,
    };
  }
}

class Crew {
  String? job;
  String? department;
  String? creditId;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  String? character;
  int? order;

  Crew({
    this.job,
    this.department,
    this.creditId,
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.character,
    this.order,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      job: json['job'],
      department: json['department'],
      creditId: json['credit_id'],
      adult: json['adult'],
      gender: json['gender'],
      id: json['id'],
      knownForDepartment: json['known_for_department'],
      name: json['name'],
      originalName: json['original_name'],
      popularity: json['popularity'].toDouble(),
      profilePath: json['profile_path'],
      character: json['character'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job,
      'department': department,
      'credit_id': creditId,
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': knownForDepartment,
      'name': name,
      'original_name': originalName,
      'popularity': popularity,
      'profile_path': profilePath,
      'character': character,
      'order': order,
    };
  }
}
