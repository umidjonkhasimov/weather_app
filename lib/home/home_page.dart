import 'package:flutter/material.dart';
import 'package:weather_app/weather/weather_page.dart';

import '../profile/profile_page.dart';
import '../search/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPageRoute<HomePage> route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var currentIndex = 0;

  final navBarItems = [
    NavBarItem(index: 0, label: 'Home', iconData: Icons.home_rounded),
    NavBarItem(index: 1, label: 'Search', iconData: Icons.search_rounded),
    NavBarItem(index: 2, label: 'Profile', iconData: Icons.person_rounded),
  ];

  final body = [
    const WeatherPage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          body[currentIndex],
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: _buildNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navBarItems.map(
          (item) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = item.index;
                });
              },
              child: Container(
                width: 100,
                height: 40,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: currentIndex == item.index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.iconData,
                      color: currentIndex == item.index
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    if (currentIndex == item.index)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, value, child) {
                          return SizedBox(
                            child: Transform.scale(
                              scale: value,
                              // scale: value,
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: currentIndex == item.index
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class NavBarItem {
  final int index;
  final String label;
  final IconData iconData;

  NavBarItem({required this.index, required this.label, required this.iconData});
}
