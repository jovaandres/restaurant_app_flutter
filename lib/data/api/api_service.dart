import 'dart:convert';

import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';
import 'package:restaurant_app_flutter/common/constant.dart';

class ApiService {
  Future<Restaurant> getRestaurantList() async {
    final response = await http.get(baseUrl + 'list');
    if (response.statusCode == 200) {
      return Restaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantResult> getRestaurantDetail(String id) async {
    final response = await http.get(baseUrl + 'detail/$id');
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<Restaurant> searchRestaurant(String query) async {
    final response = await http.get(baseUrl + 'search?q=$query');
    if (response.statusCode == 200) {
      return Restaurant.fromJsonSearch(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<http.Response> addReview(String id, String name, String review) {
    return http.post(baseUrl + 'review',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Auth-Token': apiKey
        },
        body: jsonEncode(
            <String, String>{'id': id, 'name': name, 'review': review}));
  }
}
