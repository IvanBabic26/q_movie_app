import 'package:flutter/material.dart';
import 'package:q_movie_app/constants/style_constants.dart';

class MovieGenreList {

  Widget getTextWidgets(List<String?> strings) {
    return Wrap(
      children: strings
          .map(
            (item) => Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
          child: Container(
            height: 21,
            width: 68,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(236, 155, 62, 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Center(
                child: Text(
                  item!,
                  style: kGenreText,
                ),
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }


}