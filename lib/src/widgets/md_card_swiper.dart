import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

class CardSwiperActor extends StatelessWidget {
  final List<Actor> actors;

  CardSwiperActor({@required this.actors});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          actors[index].uniqueId = '${actors[index].id}-tarjeta';

          return Hero(
            tag: actors[index].id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'actorDet',
                      arguments: actors[index]),
                  child: FadeInImage(
                    image: NetworkImage(actors[index].getFoto()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: actors.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
