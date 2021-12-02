import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/providers/md_actores_provider.dart';

class mdActorDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, actor),
            _descripcion(actor),
            _crearCasting(context, actor.name),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 60.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://th.bing.com/th/id/OIP.KCgO__JMVU5iXIG5ZdfjIgHaEK?pid=ImgDet&rs=1"), //<<<<<<<<<<<<<<<<<<<<<<<<<<
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: actor.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(actor.getFoto()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actor.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                //Text(actor.gender, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(actor.gender.toString(),
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

  Widget _descripcion(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        actor.bio,
        //textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(BuildContext context, nombreactor) {
    final peliProvider = new ActoresProvider();

    return FutureBuilder(
      future: peliProvider.getMovies(nombreactor),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(context, snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  //create pelicula  view
  Widget _crearActoresPageView(BuildContext context, List<Pelicula> peliculas) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _actorTarjeta(context, peliculas[i]),
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Pelicula pelicula) {
    return InkWell(
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
      onTap: () {
        pelicula.uniqueId = '${pelicula.id}-actmov';
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
