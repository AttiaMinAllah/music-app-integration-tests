import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/main.dart' as app;
import 'package:music_app/presentation/pages/top_albums_page.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'utils/test_utils.dart'; 

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await initializeDependencies();
  });

  tearDown(resetDependencies);

  group('Search Screen Tests', () {
    testWidgets('Search for an artist and navigate to top albums screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navigateToSearchPage(tester);

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget); 
      await tester.enterText(searchField, 'Coldplay'); 

      final searchPageButton = find.byType(AppbarSearchButton);
      expect(searchPageButton, findsOneWidget);
      await tester.tap(searchPageButton);

      mockArtistsBlocStateForSearch([
        TestArtist(name: 'Coldplay'),
        TestArtist(name: 'Coldplay, BTS'),
        TestArtist(name: 'COLDPLAY X BTS'),
        TestArtist(name: 'Coldplay & BTS'),
      ]);
      await tester.pumpAndSettle();

      final searchResultList = find.byType(GridView);
      final coldplayText = find.descendant(
        of: searchResultList,
        matching: find.text('Coldplay'),
      );

      await tester.tap(coldplayText);
      await tester.pumpAndSettle();

      expect(find.byType(TopAlbumPage), findsOneWidget);   
      });
  });
}
