import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/provider/search_provider.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/no_connection_widget.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';
import 'package:rxdart/rxdart.dart';

var _textQuery = BehaviorSubject<String>();

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchQueryController;
  static const title = 'Search Restaurants';
  String _oldString = '';

  @override
  void initState() {
    _searchQueryController = TextEditingController();
    _searchQueryController.addListener(updateList);
    super.initState();
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(updateList);
    _searchQueryController.dispose();
    super.dispose();
  }

  updateList() {
    _textQuery.add(_searchQueryController.text);
    _textQuery
        .where((value) => value.isNotEmpty && value != _oldString)
        .debounceTime(Duration(milliseconds: 500))
        .listen((query) {
      Provider.of<SearchProvider>(context, listen: false)
          .fetchSearchedRestaurant(query);
      _oldString = _searchQueryController.text;
    });
  }

  Widget _buildList(TextEditingController myController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Center(
          child: Text(
            '• Explore Restaurant •',
            style: textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
              key: Key('texy field'),
              style: textStyle,
              keyboardType: TextInputType.name,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search Restaurant',
                hintText: 'Search by name or menu',
                isDense: true,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.lightBlueAccent,
                  size: 24,
                ),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              controller: myController),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<SearchProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.state == ResultState.HasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        return buildRestaurantItem(
                            context, state.result.restaurants[index]);
                      });
                } else if (state.state == ResultState.NoData) {
                  return Center(
                      child: EmptyWidget(message: 'Try another keyword'));
                } else if (state.state == ResultState.Error) {
                  return Center(child: NoConnectionWidget());
                } else {
                  return Center(
                    child: Text(''),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildList(_searchQueryController),
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: SafeArea(
        child: _buildList(_searchQueryController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iOSBuilder: _buildIOS,
    );
  }
}
