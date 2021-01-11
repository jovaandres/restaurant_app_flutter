import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Testing app', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Test add to favorite', () async {
      await driver.waitFor(find.text('Melting Pot'));
      await driver.tap(find.byValueKey('Melting Pot'));

      await driver.waitFor(find.byValueKey('add to favorite'));
      await driver.tap(find.byValueKey('add to favorite'));

      await driver.tap(find.byValueKey('back'));

      await driver.waitFor(find.text('Melting Pot'));
      await driver.tap(find.byTooltip('Favorite'));

      await driver.waitFor(find.text('Melting Pot'));

      await driver.tap(find.byTooltip('Restaurant'));
    });

    test('Search Restaurant', () async {
      await driver.waitFor(find.byValueKey('search'));
      await driver.tap(find.byValueKey('search'));

      await driver.enterText('kafe');
      await driver.waitFor(find.text('Kafe Kita'));
    });
  });
}
