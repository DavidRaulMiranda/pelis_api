import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:scooby_app/main.dart';

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/md_serie_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/pages/md_menu.dart';

class SeriessProvider {
  String _apikey =
      '5e58c1f6bf9d489e7fb25488f4cf7811'; //ab85e2ec67c3e9d2e7970e8fd9c24fdd

  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Serie> _populares = [];

  final _popularesStreamController = StreamController<List<Serie>>.broadcast();

  Function(List<Serie>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Serie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Serie>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final serie = new Series.fromJsonList(decodedData['results']);

    return serie.items;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language}); // pelicula

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Serie>> buscarSerie(String query) async {
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
}
