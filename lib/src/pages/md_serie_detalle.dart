import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/md_serie_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

import 'package:scooby_app/src/providers/peliculas_provider.dart';

class MdSerieDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Serie serie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(serie),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, serie),
            _descripcion(serie),
            _crearCasting(context, serie),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Serie serie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          serie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500" + serie.backdropPath),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Serie serie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: serie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(serie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(serie.title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Text(serie.originalTitle,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(serie.voteAverage.toString(),
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Serie serie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        serie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(BuildContext context, Serie serie) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(serie.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(context, snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(BuildContext context, List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(context, actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Actor actor) {
    return InkWell(
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
      onTap: () {
        Navigator.pushNamed(context, 'actorDet', arguments: actor);
      },
    );
  }
}
