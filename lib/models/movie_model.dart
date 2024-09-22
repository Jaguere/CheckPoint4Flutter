import 'dart:convert';

class Result {
  int page;
  List<Movie>? movies;
  List<Review>? reviews;
  int totalPages;
  int totalResults;

  Result({
    required this.page,
    this.movies,
    this.reviews,
    required this.totalPages,
    required this.totalResults,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        page: json["page"],
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
  factory Result.fromJsonReviews(Map<String, dynamic> json) => Result(
        page: json["page"],
        reviews: List<Review>.from(json["results"].map((x) => Review.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Movie {
  bool adult;
  String backdropPath;
  List<int>? genreIds;
  List<Genre>? genres;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    this.genreIds,
    this.genres,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? '',
        genreIds: List<int>.from(
            json["genre_ids"]?.map((x) => x) ?? List<int>.empty()),
        id: json["id"] ?? 0,
        originalLanguage: json["original_language"] ?? '',
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble() ?? 0,
        posterPath: json["poster_path"] ?? '',
        releaseDate: DateTime.tryParse(json["release_date"]),
        title: json["title"] ?? '',
        video: json["video"] ?? false,
        voteAverage: json["vote_average"]?.toDouble() ?? 0,
        voteCount: json["vote_count"] ?? 0,
      );
  factory Movie.fromJsonDetails(Map<String, dynamic> json) => Movie(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? '',
        genres: List<Genre>.from(json['genres']?.map((x) => Genre.fromJson(x))),
        id: json["id"] ?? 0,
        originalLanguage: json["original_language"] ?? '',
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble() ?? 0,
        posterPath: json["poster_path"] ?? '',
        releaseDate: DateTime.tryParse(json["release_date"]),
        title: json["title"] ?? '',
        video: json["video"] ?? false,
        voteAverage: json["vote_average"]?.toDouble() ?? 0,
        voteCount: json["vote_count"] ?? 0,
      );
}

class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json['name'],
      );
}
class Review {
  String author;
  String content;
  DateTime? date;
  DateTime? lastUpdated;
  String id;
  Review({
    required this.author,
    required this.content,
    required this.date,
    required this.lastUpdated,
    required this.id,
  });
  factory Review.fromJson(Map<String,dynamic> json) => Review(
    author: json['author'],
    content: json['content'],
    date: DateTime.tryParse(json['created_at']),
    lastUpdated: DateTime.tryParse(json['updated_at']),
    id: json['id']
  );
}
