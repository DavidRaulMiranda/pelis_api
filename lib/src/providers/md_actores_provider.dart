import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

class ActoresProvider {
  String _apikey =
      '5e58c1f6bf9d489e7fb25488f4cf7811'; //ab85e2ec67c3e9d2e7970e8fd9c24fdd

  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _populares = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Cast.fromJsonList(decodedData['results']);

    return actores.actores;
  }

  //
  Future<List<Actor>> getTreding() async {
    final url = Uri.https(_url, '3/trending/person/week',
        {'api_key': _apikey, 'language': _language}); // Pelicula
    return await _procesarRespuesta(url);
  }

  //ger /person/popular
  Future<List<Actor>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/person/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    }); // Pelicula
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<Void> getBio(Actor actor) async {
    String s;
    String a = actor.id.toString();
    final url = Uri.https(_url, '3/person/$a', {
      'api_key': _apikey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    if (decodedData != null) {
      s = decodedData['biography'];
    } else {
      s = "no data";
    }
    actor.bio = s;
  }

  //get movies
  Future<List<Pelicula>> getMovies(String nombreActor) async {
    final url = Uri.https(_url, '3/search/person', {
      'api_key': _apikey,
      'language': _language,
      'query': nombreActor
    }); // pelicula
    //final url = 'https://api.themoviedb.org/3/search/person?language=en-US&query=%22Megan%20Fox%22&page=1&include_adult=false';
    final resp = await http.get(url);
    List<dynamic> c, b = [];
    var a;
    print(resp);
    final decodedData = json.decode(resp.body);
    print(decodedData);
    a = decodedData['results'];

    a.forEach((element) {
      b.addAll(element['known_for']);
      // c.add(element['known_for']);
    });

/*
    if (a.count == 1) {
      b = a[0]['known_for'];
    } else if (a.count > 1) {
      for (var i = 1; i < a.length; i++) {
        //print(a[i]);
        b.addAll(a[i]['known_for']);
        c.add(a[i]['known_for']);
        /*b.forEach((element) {
        c.add(element);
      });*/
      }*/
    // }

    //c.addAll(element['known_for'])

    final movies = new Peliculas.fromJsonList(b);

    return movies.items;
  }

//https://api.themoviedb.org/3/search/person?language=en-US&query=%22Megan%20Fox%22&page=1&include_adult=false
  Future<List<Actor>> buscarPelicula(String query) async {
    /*String query;
    if (isSwitched == false) {
      query = '3/search/tv';
    } else {
      query = '3/search/movie';
    }*/

    final url = Uri.https(_url, query, {
      'api_key': _apikey,
      'language': _language,
      'query': query
    }); // Pelicula
    return await _procesarRespuesta(url);
  }
}
