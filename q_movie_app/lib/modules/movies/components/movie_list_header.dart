import 'package:flutter/material.dart';
import 'package:q_movie_app/constants/style_constants.dart';

class MoviesListHeader extends StatelessWidget {
  const MoviesListHeader({Key? key, this.listTitle}) : super(key: key);
  final String? listTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 28, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'lib/assets/images/q-logo.png',
            height: 28.0,
            width: 28.0,
          ),
          const SizedBox(
            height: 28.0,
          ),
          Text(
            listTitle!,
            style: kListHeadings,
          ),
        ],
      ),
    );
  }
}
