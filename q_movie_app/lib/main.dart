import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:q_movie_app/modules/movies/screens/favourite_movies_screen.dart';
import 'package:q_movie_app/modules/movies/screens/popular_movies_screen.dart';
import 'package:q_movie_app/modules/start/screens/splash_screen.dart';
import 'package:q_movie_app/modules/movies/stores/favourite_movies_store.dart';
import 'package:q_movie_app/constants/style_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavouriteMoviesStore()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: kMainColorTheme),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          PopularMoviesScreen.id: (context) => const PopularMoviesScreen(),
          FavouriteMoviesScreen.id: (context) => const FavouriteMoviesScreen(),
        },
      ),
    );
  }
}
