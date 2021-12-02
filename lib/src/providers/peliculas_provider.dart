import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:scooby_app/main.dart';

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/pages/md_menu.dart';

class PeliculasProvider {
  String _apikey =
      '5e58c1f6bf9d489e7fb25488f4cf7811'; //ab85e2ec67c3e9d2e7970e8fd9c24fdd

  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = [];

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }
/*
  //md
  List<Actor> _trending = [];

  final _popularesActorController = 
       StreamController<List<Actor>>.broadcast();

   Function(List<Actor>) get popularesSinkActor =>
      _popularesActorController.sink.add;


  Stream<List<Actor>> get popularesActor =>
       _popularesActorController.stream;
  void disposeActorStreams() {
    _popularesActorController?.close();
//md
*/

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language}); // Pelicula
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
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

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language}); // pelicula

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    String s = "";
    if (isMovieSeelcted == true) {
      s = '3/search/movie';
    } else {
      s = '3/search/tv';
    }

    final url = Uri.https(_url, '$s', {
      'api_key': _apikey,
      'language': _language,
      'query': query
    }); // Pelicula
    return await _procesarRespuesta(url);
  }

  //get trnding people

  Future<List<Actor>> GetTrending() async {
    final url = Uri.https(_url, '3/trending/person/week',
        {'api_key': _apikey, 'language': _language}); // Pelicula

    _GetTrending(url);
    //return await _procesarRespuesta(url);
  }
  /*Future getTrending() async {
    final url = Uri.https(_url, '3/search/person', {
      'api_key': _apikey,
      'language': _language,
      'query': 'Megan Fox'
    }); // Pelicula

    _procesarRespTemp(url);
    //return await _procesarRespuesta(url);
  }*/

  //actores relevantes     https://api.themoviedb.org/3/search/person?language=en-US&query=%22Megan%20Fox%22&page=1&include_adult=false

//procesar respuesta actores

  Future<List<Actor>> _GetTrending(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    print(decodedData);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }
}
