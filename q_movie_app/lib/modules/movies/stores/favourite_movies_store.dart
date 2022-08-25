import 'package:flutter/foundation.dart';

class FavouriteMoviesStore extends ChangeNotifier {
  Set favourite = {};

  onTap(index) {
    favourite.contains(index) ? favourite.remove(index) : favourite.add(index);
    notifyListeners();
  }
}
