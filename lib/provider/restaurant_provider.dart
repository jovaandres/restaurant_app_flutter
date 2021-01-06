import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({@required this.apiService}) {
    fetchRestaurantList();
  }

  Restaurant _restaurantResult;
  String _message;
  ResultState _state;

  Restaurant get result => _restaurantResult;

  String get message => _message;

  ResultState get state => _state;

  Future<dynamic> fetchRestaurantList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error->>$e';
    }
  }
}
