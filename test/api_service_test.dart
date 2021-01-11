import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';
import 'package:restaurant_app_flutter/provider/detail_provider.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';

class MockClient extends Mock implements ApiService {}

void main() {
  group('ApiService Test - Parsing Json =>', () {
    MockClient apiService;
    RestaurantProvider provider;
    DetailProvider detailProvider;

    final restaurantList = {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        },
      ]
    };

    final restaurantDetail = {
      "error": false,
      "message": "success",
      "restaurant": {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description":
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
        "city": "Medan",
        "address": "Jln. Pandeglang no 19",
        "pictureId": "14",
        "categories": [
          {"name": "Italia"}
        ],
        "menus": {
          "foods": [
            {"name": "Paket rosemary"}
          ],
          "drinks": [
            {"name": "Es krim"}
          ]
        },
        "rating": 4.2,
        "customerReviews": [
          {
            "name": "Ahmad",
            "review": "Tidak rekomendasi untuk pelajar!",
            "date": "13 November 2019"
          }
        ]
      }
    };

    setUp(() {
      apiService = MockClient();
      provider = RestaurantProvider(apiService: apiService);
      detailProvider = DetailProvider(apiService: apiService);
    });

    test('restaurant list must not be null after parsing', () async {
      when(apiService.getRestaurantList())
          .thenAnswer((_) async => Restaurant.fromJson(restaurantList));

      await provider.fetchRestaurantList();

      expect(provider.result.restaurants[0].id, 'rqdv5juczeskfw1e867');
    });

    test('restaurant detail must not be null after parsing', () async {
      when(apiService.getRestaurantDetail('rqdv5juczeskfw1e867'))
          .thenAnswer((_) async => RestaurantResult.fromJson(restaurantDetail));

      await detailProvider.fetchRestaurantDetail('rqdv5juczeskfw1e867');

      expect(detailProvider.result.id, 'rqdv5juczeskfw1e867');
    });
  });
}
