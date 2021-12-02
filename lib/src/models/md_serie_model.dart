class Series {
  List<Serie> items = [];

  Series();

  Series.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      /*if (item['media_type'] == 'tv') {
        final pelicula = new Serie.fromJsonMap(item);
        items.add(pelicula);
      }*/
      final pelicula = new Serie.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

class Serie {
  String uniqueId;

  int voteCount;
  int id;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

  Serie({
    this.voteCount,
    this.id,
    this.voteAverage,
    this.title,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });

  Serie.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json['vote_count'];
    id = json['id'];
    voteAverage = json['vote_average'] / 1;
    title = json['name'] ?? "aaaa"; // Pelicula
    /*if (json['poster_path'] != null) {
      posterPath = json['poster_path'];
    } else {
      posterPath =
          "https://th.bing.com/th/id/OIP.KCgO__JMVU5iXIG5ZdfjIgHaEK?pid=ImgDet&rs=1";
    }*/
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_name'] ?? "bbbbbbbbbbbbbbbbbb"; // Pelicula
    genreIds = json['genre_ids'].cast<int>();
    if (json['backdrop_path'] != null) {
      backdropPath = json['backdrop_path'];
    } else {
      backdropPath =
          "https://th.bing.com/th/id/OIP.KCgO__JMVU5iXIG5ZdfjIgHaEK?pid=ImgDet&rs=1";
    }
    adult = json['adult'];
    overview = json['overview'] ?? "no desc";
    releaseDate = json['release_date'];
  }

  getPosterImg() {
    if (posterPath == null) {
      return 'https://media.istockphoto.com/vectors/no-image-available-sign-vector-id1138179183?k=20&m=1138179183&s=612x612&w=0&h=iJ9y-snV_RmXArY4bA-S4QSab0gxfAMXmXwn5Edko1M=';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg() {
    if (posterPath == null) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}
