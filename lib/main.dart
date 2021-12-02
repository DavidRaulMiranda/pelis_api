import 'package:flutter/material.dart';

import 'package:scooby_app/src/pages/home_page.dart';
import 'package:scooby_app/src/pages/md_serie_detalle.dart';
import 'package:scooby_app/src/pages/pelicula_detalle.dart';

import 'src/pages/md_actor_detalle.dart';
import 'src/pages/md_home_page_actor.dart';
import 'src/pages/md_menu.dart';

void main() => runApp(MyApp());

bool isMovieSeelcted = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas TMDB',
      initialRoute: 'mdMenu',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
        //mod
        'mdMenu': (BuildContext context) => MdMenu(),
        'mdactor': (BuildContext context) => MdHomePageActor(),
        'actorDet': (BuildContext context) => mdActorDetalle(),
        'tv': (BuildContext context) => MdSerieDetalle(),
      },
    );
  }
}
