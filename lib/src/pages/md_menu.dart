import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scooby_app/main.dart';
import 'package:scooby_app/src/pages/pelicula_detalle.dart';
import 'package:scooby_app/src/providers/md_actores_provider.dart';
import 'package:scooby_app/src/providers/peliculas_provider.dart';
import 'package:scooby_app/src/search/search_delegate.dart';

import 'home_page.dart';
import 'md_home_page_actor.dart';

class MdMenu extends StatefulWidget {
  MdMenu({Key key}) : super(key: key);
  //default
  final peliculasProvider = new PeliculasProvider();

  //moded

  @override
  _MdMenuState createState() => _MdMenuState();
}

class _MdMenuState extends State<MdMenu> {
  _MdMenuState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Peliculas TMDB'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              //default
              Container(
                child: FlatButton(
                  color: Colors.red,
                  splashColor: Colors.black12,
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                    print("dflt");
                  },
                  child: Text("Default mode(Films)"),
                ),
                margin: EdgeInsets.only(top: 120),
              ),

              //inverted
              Container(
                child: FlatButton(
                  color: Colors.red,
                  splashColor: Colors.black12,
                  onPressed: () {
                    Navigator.pushNamed(context, 'mdactor');
                    print("actor");
                  },
                  child: Text("Flipped Mode(Actors)"),
                ),
                margin: EdgeInsets.only(top: 30),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Series'),
                    Switch(
                        value: isMovieSeelcted,
                        onChanged: (value) {
                          setState(() {
                            isMovieSeelcted = value;
                            print(isMovieSeelcted);
                          });
                        }),
                    Text('Films')
                  ],
                ),
                margin: EdgeInsets.only(top: 30),
              ),
              Container(
                child: FlatButton(
                  color: Colors.red,
                  splashColor: Colors.black12,
                  onPressed: () async {
                    //PeliculasProvider p = PeliculasProvider();
                    ActoresProvider p = ActoresProvider();
                    p.getMovies("Megan Fox");
                  },
                  child: Text("search&print"),
                ),
                margin: EdgeInsets.only(top: 120),
              )
            ],
          ),
        ));
  }
}
