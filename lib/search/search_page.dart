import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/home/home_page.dart';
import 'package:weather_app/search/bloc/search_bloc.dart';
import 'package:weather_app/weather/weather_page.dart';
import 'package:weather_app/weather/weather_repository/weather_repostiory.dart';

import '../details/details_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(WeatherRepositoryImpl()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView({super.key});

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SearchBar(
                    backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    elevation: const MaterialStatePropertyAll(0),
                    controller: _searchController,
                    hintText: 'Search',
                    onChanged: (value) => setState(() {}),
                    onSubmitted: (value) {
                      context
                          .read<SearchBloc>()
                          .add(SearchEventSearchCountries(query: value));
                    },
                    trailing: [
                      Visibility(
                        visible: _searchController.text.isNotEmpty,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                          icon: const Icon(Icons.cancel_rounded),
                        ),
                      ),
                    ],
                  ),
                  state is SearchStateDataReady
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              final currItem = state.data[index];
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  DetailsPage.route(currItem),
                                ),
                                title: Text(currItem.name),
                                subtitle: Text(currItem.country),
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
