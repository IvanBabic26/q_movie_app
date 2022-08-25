class FavouriteMovies {
  int? id;
  String? title;
  String? overview;
  List<dynamic>? genreIds;
  dynamic voteAverage;
  String? posterPath;

  FavouriteMovies({
    this.id,
    this.title,
    this.overview,
    this.genreIds,
    this.voteAverage,
    this.posterPath,
  });

  FavouriteMovies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    overview = json['overview'];
    genreIds = json['genre_ids'].toList();
    voteAverage = json['vote_average'];
    posterPath = json['poster_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['overview'] = overview;
    data['vote_average'] = voteAverage;
    data['genre_ids'] = genreIds;
    data['poster_path'] = posterPath;
    return data;
  }
}
