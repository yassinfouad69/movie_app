import 'package:equatable/equatable.dart';
import 'genre_model.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<int>? genreIds;
  final List<Genre>? genres;
  final int? runtime;
  final int? favoritesCount;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    this.genreIds,
    this.genres,
    this.runtime,
    this.favoritesCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['title_english'] ?? '',
      overview: json['summary'] ?? json['description_full'] ?? json['synopsis'],
      posterPath: json['medium_cover_image'] ?? json['large_cover_image'],
      backdropPath: json['background_image'] ?? json['background_image_original'],
      voteAverage: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      voteCount: 0,
      releaseDate: json['year'] != null ? json['year'].toString() : null,
      genreIds: null,
      genres: json['genres'] != null && json['genres'] is List
          ? (json['genres'] as List)
              .asMap()
              .entries
              .map((entry) => Genre(
                    id: entry.key,
                    name: entry.value.toString(),
                  ))
              .toList()
          : null,
      runtime: json['runtime'],
      favoritesCount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'genres': genres?.map((genre) => genre.toJson()).toList(),
      'runtime': runtime,
      'popularity': favoritesCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        genreIds,
        genres,
        runtime,
        favoritesCount,
      ];
}
