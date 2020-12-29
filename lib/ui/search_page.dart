import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/provider/search_provider.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController myController;

  @override
  void initState() {
    myController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  void updateList(String newQuery) {
    Provider.of<SearchProvider>(context, listen: false)
        .fetchSearchedRestaurant(query: newQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Search Restaurant')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by name or menu',
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: myController,
                      onChanged: updateList),
                )),
            Expanded(
                flex: 9,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Consumer<SearchProvider>(
                      builder: (context, state, _) {
                        if (state.state == ResultState.Loading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state.state == ResultState.HasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: state.result.restaurants.length,
                              itemBuilder: (context, index) {
                                return buildRestaurantItem(
                                    context, state.result.restaurants[index]);
                              });
                        } else if (state.state == ResultState.NoData ||
                            state.state == ResultState.Error) {
                          return Center(child: Text(state.message));
                        } else {
                          return Center(child: Text(''));
                        }
                      },
                    )))
          ],
        ));
  }
}
