import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';

void main() {
  group('ApiService Test - Parsing Json', () {
    // arrange
    ApiService apiService;
    final restaurantName = 'melt';
    final id = 'rqdv5juczeskfw1e867';
    final name = 'Jova';
    final review = 'Kopinya pahit';
    final meltingPot = {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description":
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
      "pictureId": "14",
      "city": "Medan",
      "rating": 4.2
    };

    setUp(() {
      apiService = ApiService();
    });

    test('restaurant list must not be null after parsing', () async {
      // act
      Restaurant result = await apiService.getRestaurantList();

      // assert
      expect(result.error, false);
      expect(result.restaurants[0].id, Restaurants.fromJson(meltingPot).id);
    });

    test('restaurant search result must not be null after parsing', () async {
      // act
      Restaurant result = await apiService.searchRestaurant(restaurantName);

      // assert
      expect(result.error, false);
      expect(result.restaurants[0].name, Restaurants.fromJson(meltingPot).name);
    });

    test('restaurant detail must not be null after parsing', () async {
      // act
      RestaurantResult result = await apiService.getRestaurantDetail(id);

      // assert
      expect(result.error, false);
      expect(result.restaurant.id, Restaurants.fromJson(meltingPot).id);
    });

    test('should succeed add comment to restaurant', () async {
      // act
      await apiService.addReview(id, name, review);
      RestaurantResult result = await apiService.getRestaurantDetail(id);

      // assert
      expect(result.error, false);
      expect(result.restaurant.customerReviews.last.review, review);
    });
  });
}
