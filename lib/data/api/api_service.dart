import 'dart:convert';

import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static final String _apiKey = '12345';

  Future<Restaurant> getRestaurantList() async {
    final response = await http.get(_baseUrl + 'list');
    if (response.statusCode == 200) {
      return Restaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantResult> getRestaurantDetail(String id) async {
    final response = await http.get(_baseUrl + 'detail/$id');
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<http.Response> addReview(String id, String name, String review) {
    return http.post(_baseUrl + 'review',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Auth-Token': _apiKey
        },
        body: jsonEncode(
            <String, String>{'id': id, 'name': name, 'review': review}));
  }
}
