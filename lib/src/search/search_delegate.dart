import 'package:flutter/material.dart';
import 'package:scooby_app/main.dart';
import 'package:scooby_app/src/models/md_serie_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/pages/md_menu.dart';
import 'package:scooby_app/src/providers/md_serie_provider.dart';
import 'package:scooby_app/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final seriessProvider = new SeriessProvider();
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

//
  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    } else if (isMovieSeelcted == true) {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;

            return ListView(
                children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      return FutureBuilder(
        future: seriessProvider.buscarSerie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Serie>> snapshot_) {
          if (snapshot_.hasData) {
            final serie = snapshot_.data;

            return ListView(
                children: serie.map((serie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(serie.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(serie.title),
                subtitle: Text(serie.originalTitle),
                onTap: () {
                  close(context, null);
                  serie.uniqueId = '';
                  Navigator.pushNamed(context, 'tv', arguments: serie);
                },
              );
            }).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando la persona escribe

  //   final listaSugerida = ( query.isEmpty )
  //                           ? peliculasRecientes
  //                           : peliculas.where(
  //                             (p)=> p.toLowerCase().startsWith(query.toLowerCase())
  //                           ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: (){
  //           seleccion = listaSugerida[i];
  //           showResults( context );
  //         },
  //       );
  //     },
  //   );
  // }

}
