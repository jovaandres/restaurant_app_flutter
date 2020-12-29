import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';

class DetailProvider extends ChangeNotifier {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  final ApiService apiService;
  final String id;

  DetailProvider({@required this.apiService, @required this.id}) {
    fetchRestaurantDetail();
  }

  DetailRestaurant _restaurantResult;
  String _message;
  ResultState _state;

  DetailRestaurant get result => _restaurantResult;
  String get message => _message;
  ResultState get state => _state;

  Future<dynamic> fetchRestaurantDetail() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.restaurant.id == null) {
        _state = ResultState.NoData;
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant.restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error->>$e';
    }
  }
}
