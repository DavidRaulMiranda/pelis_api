import 'package:scooby_app/src/providers/md_actores_provider.dart';

class Cast {
  ActoresProvider ac = ActoresProvider();
  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
      ac.getBio(actor);
    });
  }
}

class Actor {
  String uniqueId; //

  int castId;
  String character;
  String creditId;
  String overview;
  int gender;
  int id;
  String name;
  int order;
  String bio;
  String profilePath;
  List<String> peliculas;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
    this.overview,
    this.bio,
    //this.peliculas,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    bio = "";
    profilePath = json['profile_path'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}

class ActorMovies {}
