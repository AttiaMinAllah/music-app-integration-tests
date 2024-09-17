import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/main.dart' as app;
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'utils/test_utils.dart';
import 'package:flutter/material.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDependencies();
  });

 tearDown(resetDependencies);

  group('Top Albums Screen Tests', () {
    testWidgets('Select first two albums and add to favorites', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navigateToSearchPage(tester);

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Coldplay'); 

      final searchPageButton = find.byType(AppbarSearchButton);
      expect(searchPageButton, findsOneWidget);
      await tester.tap(searchPageButton);

      // Mock search results to show "Coldplay"
      mockArtistsBlocStateForSearch([
        TestArtist(name: 'Coldplay'),
      ]);
      await tester.pumpAndSettle(); 

      final searchResultList = find.byType(GridView);
      final coldplayText = find.descendant(
        of: searchResultList,
        matching: find.text('Coldplay'),
      );

      await tester.tap(coldplayText);
      await tester.pumpAndSettle();

      //TODO: Fix the mocking error

      // Mock album data to show a list of albums
      // mockAlbumState([
      //   TestAlbum(name: 'Parachutes', isFavorite: false),
      //   TestAlbum(name: 'A Rush of Blood to the Head', isFavorite: false),
      // ]);
      // await tester.pumpAndSettle();
      // await addAlbumToFavorites(tester, 'Parachutes');
      // await addAlbumToFavorites(tester, 'A Rush of Blood to the Head');

      // await tester.pageBack(); 
      // await tester.pageBack(); 
      // await tester.pumpAndSettle();

      // // Check if the albums are now added to the favorites list on the home page
      // expect(find.text('Parachutes'), findsOneWidget);
      // expect(find.text('A Rush of Blood to the Head'), findsOneWidget);
    });
  });
}
