import 'package:flutter/material.dart';
import 'package:q_movie_app/modules/bottomNavigationBar/components/navigation.dart';
import 'package:q_movie_app/modules/movies/screens/favourite_movies_screen.dart';
import 'package:q_movie_app/modules/movies/screens/popular_movies_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  static const String id = 'bottom_navigation_bar_screen';

  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  late List<GlobalKey<ScaffoldState>> bnbScaffoldKeys;

  /// list of screen that will render inside the BNB
  late List<Navigation> _items;
  @override
  void initState() {
    super.initState();
    bnbScaffoldKeys = [
      GlobalKey<ScaffoldState>(),
      GlobalKey<ScaffoldState>(),
    ];
    _items = [
      Navigation(
          widget:
              PopularMoviesScreen(popularMoviesScreenKey: bnbScaffoldKeys[0]),
          navigationKey: GlobalKey<NavigatorState>()),
      Navigation(
          widget: FavouriteMoviesScreen(
              favouriteMoviesScreenKey: bnbScaffoldKeys[1]),
          navigationKey: GlobalKey<NavigatorState>()),
    ];
  }

  /// function that renders components based on selected one in the BNB

  void _onItemTapped(int index) {
    if (bnbScaffoldKeys[_selectedIndex].currentState!.isDrawerOpen) {
      // Closes the drawer
      bnbScaffoldKeys[_selectedIndex].currentState?.openEndDrawer();
    }
    if (index == _selectedIndex) {
      _items[index]
          .navigationKey!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  /// navigation Tab widget for a list of all the screens and puts them in a Indexed Stack
  Widget _navigationTab(
      {GlobalKey<NavigatorState>? navigationKey, Widget? widget}) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => widget!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _items[_selectedIndex]
            .navigationKey!
            .currentState!
            .maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_selectedIndex != 0) {
            _onItemTapped(1);
            return false;
          }
        }

        /// let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _items
              .map((e) => _navigationTab(
                  navigationKey: e.navigationKey, widget: e.widget))
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined,
                      color: _selectedIndex == 0
                          ? const Color(0xFFEC9B3E)
                          : const Color(0xFFE4ECEF),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Movies',
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? const Color(0xFFEC9B3E)
                            : const Color(0xFFE4ECEF),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_added_outlined,
                      color: _selectedIndex == 1
                          ? const Color(0xFFEC9B3E)
                          : const Color(0xFFE4ECEF),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Favourites',
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? const Color(0xFFEC9B3E)
                            : const Color(0xFFE4ECEF),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            ),
          ],
          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
          currentIndex: _selectedIndex,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
